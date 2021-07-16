//
//  MyWalletSheetVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 15/03/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import ObjectMapper

class MyWalletSheetVC: UIViewController {
    // holdView can be UIImageView instead
    
    enum HistoryType{
        case wallet
        case investBuy
        case sell
    }
    //MARK:- OUTLETS
    //==============
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var investBuyHistoryBtn: UIButton!
    @IBOutlet weak var walletHistoryBtn: UIButton!
    @IBOutlet weak var mainCotainerView: UIView!
    @IBOutlet weak var bottomLayoutConstraint : NSLayoutConstraint!
    @IBOutlet weak var mainTableView: UITableView!
    
    //MARK:- VARIABLE
    //================
    var searchText = ""
    var walletModule = WalletModule()
    let userType = UserDefaults.standard.value(forKey: UserDefaultsKey.key.isFromInvestor) as? String
    var historyType: HistoryType = .wallet
    lazy var swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(closePullUp))
    var investBuyCellData = [("Payment Method",""),("Category",""),("Amount",""),("Currency",""),("Invest. Date",""),("Maturity. Date",""),("Status","")]
    var fullView: CGFloat {
        return (UIApplication.shared.statusBarFrame.height +
            (isDeviceIPad ? 65.0 : 51.0 ))
    }
    var textContainerHeight : CGFloat? {
        didSet{
            self.mainTableView.reloadData()
        }
    }
    private lazy var loader  : UIView = {
              return createActivityIndicator(self.view)
          }()
    var partialView: CGFloat {
        return (textContainerHeight ?? 0.0) + UIApplication.shared.statusBarFrame.height + (isDeviceIPad ? 78.0 : 64.0)
    }
    //MARK:- VIEW LIFE CYCLE
    //======================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard self.isMovingToParent else { return }
        UIView.animate(withDuration: 0.6, animations: { [weak self] in
            let frame = self?.view.frame
            let yComponent = self?.partialView
            self?.view.frame = CGRect(x: 0, y: yComponent!, width: frame!.width, height: frame!.height)
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainCotainerView.roundCorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 15)
        mainCotainerView.addShadowToTopOrBottom(location: .top, color: UIColor.black.withAlphaComponent(0.5))
    }
    
    @IBAction func filterBtnAction(_ sender: Any) {
        let filterVC = MyYieldFilterVC.instantiate(fromAppStoryboard: .Filter)
        filterVC.modalPresentationStyle = .overCurrentContext
        self.present(filterVC, animated: true, completion: nil)
    }
    
    
    @IBAction func walletHistoryBtnAction(_ sender: UIButton) {
        self.historyType = .wallet
        self.walletHistoryBtn.setTitleColor(.red, for: .normal)
        self.investBuyHistoryBtn.setTitleColor(#colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1), for: .normal)
        self.mainTableView.reloadData()
    }
    
    @IBAction func investBuyHistoryBtnAciton(_ sender: UIButton) {
        self.historyType = .investBuy
        self.walletHistoryBtn.setTitleColor(#colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1), for: .normal)
        self.investBuyHistoryBtn.setTitleColor(.red, for: .normal)
        self.mainTableView.reloadData()
    }
    
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)
        let y = self.view.frame.minY
        if ( y + translation.y >= fullView) && (y + translation.y <= partialView ) {
            self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
        
        if recognizer.state == .ended {
            var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )
            
            duration = duration > 1.3 ? 1 : duration
            
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                if  velocity.y >= 0 {
                    self.view.frame = CGRect(x: 0, y: self.partialView, width: self.view.frame.width, height: self.view.frame.height)
//                    self.holdView.alpha = 1.0
//                    self.listingCollView.alwaysBounceVertical = false
                } else {
                    self.view.frame = CGRect(x: 0, y: self.fullView, width: self.view.frame.width, height: self.view.frame.height)
//                    self.holdView.alpha = 1.0
//                    self.listingCollView.alwaysBounceVertical = true
                }
                
            }) { (completion) in
            }
        }
    }
    
    private func hitWalletHistoryAPI(){
        self.loader.isHidden = false
        self.presenter?.HITAPI(api: Base.wallet_sell_hisory.rawValue, params: nil, methodType: .GET, modelClass: WalletEntity.self, token: true)
    }
    
    private func hitBuyInvestHistoryAPI(){
        self.loader.isHidden = false
        self.presenter?.HITAPI(api: Base.wallet_buy_Invest_hisory.rawValue, params: nil, methodType: .GET, modelClass: WalletEntity.self, token: true)
    }
}

//MARK:- Private functions
//========================
extension MyWalletSheetVC {
    
    private func initialSetup() {
        setupTableView()
        setUpFont()
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(BottomSheetVC.panGesture))
        view.addGestureRecognizer(gesture)
        setupSwipeGesture()
//        hitWalletHistoryAPI()
//        hitBuyInvestHistoryAPI()
    }
    
    private func setupTableView() {
        self.mainTableView.isUserInteractionEnabled = true
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.emptyDataSetDelegate = self
        self.mainTableView.emptyDataSetSource = self
        self.mainTableView.registerCell(with: MyWalletTableCell.self)
        self.mainTableView.registerHeaderFooter(with: MyWalletSectionView.self)
    }
    
    private func setupSwipeGesture() {
        swipeDown.direction = .down
        swipeDown.delegate = self
        mainTableView.addGestureRecognizer(swipeDown)
    }
    
    private func setUpFont(){
        self.walletHistoryBtn.setTitleColor(.red, for: .normal)
        self.investBuyHistoryBtn.setTitleColor(#colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1), for: .normal)
        if userType == UserType.campaigner.rawValue {
            investBuyHistoryBtn.isHidden = true
            walletHistoryBtn.setTitle(Constants.string.walletHistory.localize(), for: .normal)
            investBuyHistoryBtn.setTitle(Constants.string.investBuyHistory.localize(), for: .normal)
        } else {
            investBuyHistoryBtn.isHidden = false
            walletHistoryBtn.setTitle(Constants.string.walletHistory.localize(), for: .normal)
            investBuyHistoryBtn.setTitle(Constants.string.investBuyHistory.localize(), for: .normal)
        }
        [investBuyHistoryBtn,walletHistoryBtn].forEach { (lbl) in
            lbl?.titleLabel?.font  = isDeviceIPad ? .setCustomFont(name: .semiBold, size: .x18) : .setCustomFont(name: .semiBold, size: .x14)
        }
    }
    
    @objc func closePullUp() {
        UIView.animate(withDuration: 0.3, animations: {
            let frame = self.view.frame
            self.view.frame = CGRect(x: 0, y: self.partialView, width: frame.width, height: frame.height)
//            self.holdView.alpha = 1.0
        })
    }
    
    func rotateLeft(dropdownView: UIView,left: CGFloat = -1) {
        UIView.animate(withDuration: 1.0, animations: {
            dropdownView.transform = CGAffineTransform(rotationAngle: ((180.0 * CGFloat(Double.pi)) / 180.0) * CGFloat(left))
            self.view.layoutIfNeeded()
        })
    }
    
    private func setSearchBar(){
        self.searchBar.delegate = self
        if #available(iOS 13.0, *) {
            self.searchBar.backgroundColor = #colorLiteral(red: 1, green: 0.3843137255, blue: 0.4235294118, alpha: 1)
            searchBar.tintColor = .white
            searchBar.setIconColor(.white)
            searchBar.setPlaceholderColor(.white)
            self.searchBar.searchTextField.font = .setCustomFont(name: .medium, size: isDeviceIPad ? .x18 : .x14)
            self.searchBar.searchTextField.textColor = .lightGray
        } else {
            // Fallback on earlier versions
        }
    }
          
}

//MARK:- UITableViewDelegate
//========================
extension MyWalletSheetVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch historyType {
        case .wallet:
            return (self.walletModule.wallet_histories?[section].isSelected ?? false) ? 5 : 0
        case .investBuy:
            return (self.walletModule.invest_histories?[section].isSelected ?? false) ? (investBuyCellData.endIndex) : 0
        default:
            return (self.walletModule.sell_histories?[section].isSelected ?? false) ? 5 : 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: MyWalletTableCell.self, indexPath: indexPath)
        switch historyType {
        case .wallet:
            cell.titleLbl.text = investBuyCellData[indexPath.row].0
        case .investBuy:
            if let invest_histories = self.walletModule.invest_histories{
                investBuyCellData = [("Payment Method",invest_histories[indexPath.section].type ?? ""),("Category",""),("Amount",String(invest_histories[indexPath.section].amount ?? 0.0)),("Currency",invest_histories[indexPath.section].payment_type ?? ""),("Invest. Date",invest_histories[indexPath.section].created_at ?? ""),("Maturity. Date",invest_histories[indexPath.section].created_at ?? ""),("Status",invest_histories[indexPath.section].status ?? "")]
                 cell.titleLbl.text = investBuyCellData[indexPath.row].0
                 cell.descLbl.text = investBuyCellData[indexPath.row].1
            }
        default:
             cell.titleLbl.text = investBuyCellData[indexPath.row].0
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch historyType {
        case .wallet:
            return self.walletModule.wallet_histories?.endIndex ?? 0
        case .investBuy:
            return self.walletModule.invest_histories?.endIndex ?? 0
        default:
            return self.walletModule.sell_histories?.endIndex ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueHeaderFooter(with: MyWalletSectionView.self)
        switch historyType {
        case .wallet:
            view.populateData(model: self.walletModule.wallet_histories?[section] ?? History())
        case .investBuy:
            view.populateData(model: self.walletModule.invest_histories?[section] ??  History())
        default:
            view.populateData(model: self.walletModule.sell_histories?[section] ??  History())
        }
        view.sectionTappedAction = { [weak self] (sender) in
            guard let selff = self else { return }
            switch selff.historyType {
            case .wallet:
                if let wallet_histories = selff.walletModule.wallet_histories{
                    selff.walletModule.wallet_histories?[section].isSelected = !(wallet_histories[section].isSelected)
                }
            case .investBuy:
                if let invest_histories = selff.walletModule.invest_histories{
                    selff.walletModule.invest_histories?[section].isSelected = !(invest_histories[section].isSelected)
                }
            default:
                if let sell_histories = selff.walletModule.sell_histories{
                    selff.walletModule.sell_histories?[section].isSelected = !(sell_histories[section].isSelected)
                }
            }
            tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .fade)
        }
        switch historyType {
        case .wallet:
            if let wallet_histories = self.walletModule.wallet_histories{
                self.rotateLeft(dropdownView: view.dropdownBtn,left : (wallet_histories[section].isSelected) ? -1 : 0)
            }
        case .investBuy:
            if let invest_histories = self.walletModule.invest_histories{
                self.rotateLeft(dropdownView: view.dropdownBtn,left : (invest_histories[section].isSelected) ? -1 : 0)
            }
        default:
            if let sell_histories = self.walletModule.sell_histories{
                self.rotateLeft(dropdownView: view.dropdownBtn,left : (sell_histories[section].isSelected) ? -1 : 0)
            }
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK:- Gesture Delegates
//========================
extension MyWalletSheetVC : UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        //Identify gesture recognizer and return true else false.
        if (!mainTableView.isDragging && !mainTableView.isDecelerating) {
            return gestureRecognizer.isEqual(self.swipeDown) ? true : false
        }
        return false
    }
}


//MARK: - PresenterOutputProtocol
//===========================
extension MyWalletSheetVC: PresenterOutputProtocol {
    
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        self.loader.isHidden = true
        switch api {
        case Base.wallet_sell_hisory.rawValue:
            let walletData = dataDict as? WalletEntity
            if let data = walletData?.balance {
                print(data)
            }
        case Base.wallet_buy_Invest_hisory.rawValue:
            let walletData = dataDict as? WalletEntity
            if let data = walletData?.balance {
                print(data)
            }
        default:
            break
        }
    }
    
    func showError(error: CustomError) {
        self.loader.isHidden = true
        ToastManager.show(title:  nullStringToEmpty(string: error.localizedDescription.trimString()), state: .error)
    }
}



//MARK:- Tableview Empty dataset delegates
//========================================
extension MyWalletSheetVC : DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return  #imageLiteral(resourceName: "icNoData")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string:"", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray,NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16.0)])
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return  NSAttributedString(string:"Looks Nothing Found", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray,NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16.0)])
    }
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}


//MARK:- UISearchBarDelegate
//========================================
extension MyWalletSheetVC: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        self.view.endEditing(true)
//        self.searchProducts(searchValue: self.searchText)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        if let text = searchBar.text,!text.byRemovingLeadingTrailingWhiteSpaces.isEmpty{
        }else{
        }
        searchBar.resignFirstResponder()
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
//        self.searchProducts(searchValue: "")
        self.view.endEditing(true)
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        if let text = searchBar.text,!text.byRemovingLeadingTrailingWhiteSpaces.isEmpty{
        }else{
        }
        searchBar.resignFirstResponder()
    }
}

