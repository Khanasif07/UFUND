//
//  MyWalletSheetVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 15/03/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit
//import DZNEmptyDataSet
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
    @IBOutlet weak var searchView: UIStackView!
    @IBOutlet weak var searchViewHCst: NSLayoutConstraint!
    
    //MARK:- VARIABLE
    //================
    var searchTask: DispatchWorkItem?
    var searchText = ""
    var walletModule = WalletModule(){
        didSet{
            mainTableView.reloadData()
        }
    }
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
    //Filter
    var selectedCategory : (([CategoryModel],Bool)) = ([],false)
    var selectedInvestorStart_from : (String,Bool) = ("",false)
    var selectedInvestorStart_to : (String,Bool) = ("",false)
    var selectedInvestorMature_from : (String,Bool) = ("",false)
    var selectedInvestorMature_to : (String,Bool) = ("",false)
    //Pagination
    var hideLoader: Bool = false
    var nextPageAvailable = true
    var isRequestinApi = false
    var showPaginationLoader: Bool {
        return  hideLoader ? false : nextPageAvailable
    }
    var currentPage: Int = 0
    var lastPage: Int  = 0
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
        self.mainTableView.reloadData()
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
        filterVC.delegate = self
        self.present(filterVC, animated: true, completion: nil)
    }
    
    
    @IBAction func walletHistoryBtnAction(_ sender: UIButton) {
        self.historyType = .wallet
        if userType ==  UserType.investor.rawValue{
            if historyType == .wallet {
                searchViewHCst.constant = 0.0
                searchView.isHidden = true
                filterBtn.isHidden = true
            }else {
                searchViewHCst.constant = 44.0
                searchView.isHidden = false
                filterBtn.isHidden = false
            }
        }
        self.walletHistoryBtn.setTitleColor(.red, for: .normal)
        self.investBuyHistoryBtn.setTitleColor(#colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1), for: .normal)
        self.mainTableView.reloadData()
    }
    
    @IBAction func investBuyHistoryBtnAciton(_ sender: UIButton) {
        self.historyType = .investBuy
        if userType ==  UserType.investor.rawValue{
            if historyType == .wallet {
                searchViewHCst.constant = 0.0
                searchView.isHidden = true
                filterBtn.isHidden = true
            }else {
                searchViewHCst.constant = 44.0
                searchView.isHidden = false
                filterBtn.isHidden = false
            }
        }
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
    
    private func hitBuyInvestHistoryAPI(params: [String:Any]){
        self.searchTask?.cancel()
        let task = DispatchWorkItem { [weak self] in
            self?.loader.isHidden = false
            self?.presenter?.HITAPI(api: Base.invester_buy_Invest_hisory.rawValue, params: params, methodType: .GET, modelClass: BuyInvestHistoryEntity.self, token: true)
        }
        self.searchTask = task
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.75, execute: task)

    }
}

//MARK:- Private functions
//========================
extension MyWalletSheetVC {
    
    private func initialSetup() {
        setupTableView()
        setUpFont()
        setSearchBar()
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
//        self.mainTableView.emptyDataSetDelegate = self
//        self.mainTableView.emptyDataSetSource = self
        self.mainTableView.registerCell(with: MyWalletTableCell.self)
        self.mainTableView.registerHeaderFooter(with: MyWalletSectionView.self)
        let footerView = UIView(frame: CGRect.init(x: 0.0, y: 0.0, width: self.view.frame.width, height: 100.0))
        footerView.backgroundColor = .white
        self.mainTableView.tableFooterView = footerView
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
            searchViewHCst.constant = 0.0
            searchView.isHidden = true
            filterBtn.isHidden = true
            walletHistoryBtn.setTitle(Constants.string.walletHistory.localize(), for: .normal)
            investBuyHistoryBtn.setTitle(Constants.string.investBuyHistory.localize(), for: .normal)
        } else {
            if historyType == .wallet {
                searchViewHCst.constant = 0.0
                searchView.isHidden = true
                filterBtn.isHidden = true
            }else {
                searchViewHCst.constant = 44.0
                searchView.isHidden = false
                filterBtn.isHidden = false
            }
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
//            self.searchBar.backgroundColor = #colorLiteral(red: 1, green: 0.3843137255, blue: 0.4235294118, alpha: 1)
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
            return (self.walletModule.wallet_histories?.data?[section].isSelected ?? false) ? 6 : 0
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
            if let invest_histories = self.walletModule.wallet_histories?.data{
                investBuyCellData = [("Transaction Id",invest_histories[indexPath.section].ufund_txn_id ?? ""),("Amount",String(invest_histories[indexPath.section].amount ?? 0.0)),("Currency Type",String(invest_histories[indexPath.section].payment_type ?? "")),("Date",invest_histories[indexPath.section].created_at ?? ""),("Transaction Type",invest_histories[indexPath.section].type ?? ""),("Status",invest_histories[indexPath.section].status ?? "")]
                switch investBuyCellData[indexPath.row].0 {
                case "Date":
                    let date = (investBuyCellData[indexPath.row].1).toDate(dateFormat: Date.DateFormat.yyyyMMddHHmmss.rawValue) ?? Date()
                    cell.titleLbl.text = investBuyCellData[indexPath.row].0
                    cell.descLbl.text = date.convertToDefaultString()
                    cell.descLbl.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                case "Status":
                    cell.titleLbl.text = investBuyCellData[indexPath.row].0
                    cell.descLbl.text = investBuyCellData[indexPath.row].1.uppercased()
                    cell.descLbl.textColor =   #colorLiteral(red: 0.09411764706, green: 0.7411764706, blue: 0.4705882353, alpha: 1)
                default:
                    cell.titleLbl.text = investBuyCellData[indexPath.row].0
                    cell.descLbl.text = investBuyCellData[indexPath.row].1
                    cell.descLbl.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                }
            }
        case .investBuy:
            if let invest_histories = self.walletModule.invest_histories{
                investBuyCellData = [("Payment Method",invest_histories[indexPath.section].type ?? ""),("Category",""),("Amount",String(invest_histories[indexPath.section].amount ?? 0.0)),("Currency",invest_histories[indexPath.section].payment_type ?? ""),("Invest. Date",invest_histories[indexPath.section].created_at ?? ""),("Maturity. Date",invest_histories[indexPath.section].created_at ?? ""),("Status",invest_histories[indexPath.section].status ?? "")]
                switch investBuyCellData[indexPath.row].0 {
                case "Invest. Date","Maturity. Date":
                    let date = (investBuyCellData[indexPath.row].1).toDate(dateFormat: Date.DateFormat.yyyyMMddHHmmss.rawValue) ?? Date()
                    cell.titleLbl.text = investBuyCellData[indexPath.row].0
                    cell.descLbl.text = date.convertToDefaultString()
                    cell.descLbl.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                case "Amount":
                    cell.titleLbl.text = investBuyCellData[indexPath.row].0
                    cell.descLbl.text = "$" + investBuyCellData[indexPath.row].1
                    cell.descLbl.textColor =   #colorLiteral(red: 0.09411764706, green: 0.7411764706, blue: 0.4705882353, alpha: 1)
                case "Status":
                    cell.titleLbl.text = investBuyCellData[indexPath.row].0
                    cell.descLbl.text = investBuyCellData[indexPath.row].1.uppercased()
                    cell.descLbl.textColor =   #colorLiteral(red: 0.9490196078, green: 0.7725490196, blue: 0.137254902, alpha: 1)
                default:
                    cell.titleLbl.text = investBuyCellData[indexPath.row].0
                    cell.descLbl.text = investBuyCellData[indexPath.row].1
                    cell.descLbl.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                }
            }
        default:
             cell.titleLbl.text = investBuyCellData[indexPath.row].0
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch historyType {
        case .wallet:
            return self.walletModule.wallet_histories?.data?.endIndex  ?? 0
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
            view.populateDataForWallet(model: self.walletModule.wallet_histories?.data?[section] ?? History())
            view.dateLbl.textColor =  #colorLiteral(red: 0.09411764706, green: 0.7411764706, blue: 0.4705882353, alpha: 1)
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
                    selff.walletModule.wallet_histories?.data?[section].isSelected = !(wallet_histories.data?[section].isSelected ?? false)
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
            if let wallet_histories = self.walletModule.wallet_histories?.data{
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
        return 34.0
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
        case Base.invester_buy_Invest_hisory.rawValue:
            let productModelEntity = dataDict as? BuyInvestHistoryEntity
            self.currentPage = productModelEntity?.data?.current_page ?? 0
            self.lastPage = productModelEntity?.data?.last_page ?? 0
            isRequestinApi = false
            nextPageAvailable = self.lastPage > self.currentPage
            if let productDict = productModelEntity?.data?.data {
                if self.currentPage == 1 {
                    self.walletModule.invest_histories = productDict
                } else {
                    self.walletModule.invest_histories?.append(contentsOf: productDict)
                }
            }
            self.currentPage += 1
            self.mainTableView.reloadData()
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
//extension MyWalletSheetVC : DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
//    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
//        return  #imageLiteral(resourceName: "icNoData")
//    }
//
//    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
//        return NSAttributedString(string:"", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray,NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16.0)])
//    }
//
//    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
//        return  NSAttributedString(string:"Looks Nothing Found", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray,NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16.0)])
//    }
//
//    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
//        return true
//    }
//
//    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
//        return true
//    }
//
//    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView!) -> Bool {
//        return true
//    }
//}


//MARK:- UISearchBarDelegate
//========================================
extension MyWalletSheetVC: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        self.hitBuyInvestHistoryAPI(params: [ProductCreate.keys.search: self.searchText])
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
        self.hitBuyInvestHistoryAPI(params: [:])
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


// MARK: - ProductFilterVCDelegate

extension MyWalletSheetVC: ProductFilterVCDelegate {
    func filterDataWithoutFilter(_ category: ([CategoryModel], Bool), _ status: ([String], Bool), _ min: (CGFloat, Bool), _ max: (CGFloat, Bool), _ start_from: (String, Bool), _ start_to: (String, Bool), _ close_from: (String, Bool), _ close_to: (String, Bool), _ maturity_from: (String, Bool), _ maturity_to: (String, Bool)) {
        ProductFilterVM.shared.selectedCategoryListing = self.selectedCategory.0
        ProductFilterVM.shared.start_from = self.selectedInvestorStart_from.0
        ProductFilterVM.shared.start_to = self.selectedInvestorStart_to.0
        ProductFilterVM.shared.investmentMaturity_from = self.selectedInvestorMature_from.0
        ProductFilterVM.shared.investmentMaturity_to = self.selectedInvestorMature_to.0
    }
    
    func filterApplied(_ category: ([CategoryModel], Bool), _ status: ([String], Bool), _ min: (CGFloat, Bool), _ max: (CGFloat, Bool), _ start_from: (String, Bool), _ start_to: (String, Bool), _ close_from: (String, Bool), _ close_to: (String, Bool), _ maturity_from: (String, Bool), _ maturity_to: (String, Bool)) {
        //
        if category.1 {
            ProductFilterVM.shared.selectedCategoryListing = category.0
            self.selectedCategory = category
        }else {
            ProductFilterVM.shared.selectedCategoryListing = []
            self.selectedCategory = ([],false)
        }
        ProductFilterVM.shared.investmentMaturity_from = maturity_from.1 ? maturity_from.0 : ""
        ProductFilterVM.shared.investmentMaturity_to = maturity_to.1 ? maturity_to.0 : ""
        ProductFilterVM.shared.start_from = start_from.1 ? start_from.0 : ""
        ProductFilterVM.shared.start_to = start_to.1 ? start_to.0 : ""
        if !start_from.1{self.selectedInvestorStart_from = ("",false) }
        if !start_to.1{self.selectedInvestorStart_to = ("",false) }
        if !maturity_from.1{self.selectedInvestorMature_from = ("",false) }
        if !maturity_to.1{self.selectedInvestorMature_to = ("",false) }
        //
        var params  = ProductFilterVM.shared.paramsDictForBuyHistory
        params[ProductCreate.keys.page] =  1
        params[ProductCreate.keys.search] = self.searchText
        self.hitBuyInvestHistoryAPI(params: params)
    }
}
