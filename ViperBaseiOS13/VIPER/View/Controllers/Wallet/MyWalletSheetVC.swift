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
    //MARK:- OUTLETS
    //==============
    @IBOutlet weak var investBuyHistoryBtn: UIButton!
    @IBOutlet weak var walletHistoryBtn: UIButton!
    @IBOutlet weak var mainCotainerView: UIView!
    @IBOutlet weak var bottomLayoutConstraint : NSLayoutConstraint!
    @IBOutlet weak var mainTableView: UITableView!
    
    //MARK:- VARIABLE
    //================
     let userType = UserDefaults.standard.value(forKey: UserDefaultsKey.key.isFromInvestor) as? String
    private lazy var loader  : UIView = {
           return createActivityIndicator(self.view)
       }()
     var menuContent = [(Constants.string.myProfile.localize(),[]),(Constants.string.categories.localize(),[]),(Constants.string.Products.localize(),[]),(Constants.string.TokenizedAssets.localize(),[]),(Constants.string.allMyInvestment.localize(),[]),(Constants.string.wallet.localize(),[]),(Constants.string.changePassword.localize(),[]),(Constants.string.logout.localize(),[])]
    lazy var swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(closePullUp))
    var fullView: CGFloat {
        return (isDeviceIPad ? 90.0 : 70.0)
    }
    var textContainerHeight : CGFloat? {
        didSet{
            self.mainTableView.reloadData()
        }
    }
    var partialView: CGFloat {
//        return UIScreen.main.bounds.height - (UIApplication.shared.statusBarFrame.height) - (textContainerHeight ?? 0.0)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func walletHistoryBtnAction(_ sender: UIButton) {
        self.walletHistoryBtn.setTitleColor(.red, for: .normal)
        self.investBuyHistoryBtn.setTitleColor(#colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1), for: .normal)
    }
    
    @IBAction func investBuyHistoryBtnAciton(_ sender: UIButton) {
        self.walletHistoryBtn.setTitleColor(#colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1), for: .normal)
        self.investBuyHistoryBtn.setTitleColor(.red, for: .normal)
    }
    
    @IBAction func rightButton(_ sender: AnyObject) {
        print("clicked")
    }
    
    @IBAction func close(_ sender: AnyObject) {
        UIView.animate(withDuration: 0.3, animations: {
            let frame = self.view.frame
            self.view.frame = CGRect(x: 0, y: self.partialView, width: frame.width, height: frame.height)
        })
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
            walletHistoryBtn.setTitle(Constants.string.walletHistory.localize(), for: .normal)
            investBuyHistoryBtn.setTitle(Constants.string.investBuyHistory.localize(), for: .normal)
        } else {
            walletHistoryBtn.setTitle(Constants.string.walletHistory.localize(), for: .normal)
            investBuyHistoryBtn.setTitle(Constants.string.transHistory.localize(), for: .normal)
        }
        [investBuyHistoryBtn,walletHistoryBtn].forEach { (lbl) in
            lbl?.titleLabel?.font  = isDeviceIPad ? .setCustomFont(name: .medium, size: .x18) : .setCustomFont(name: .medium, size: .x14)
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
          
}

//MARK:- UITableViewDelegate
//========================
extension MyWalletSheetVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.menuContent[section].1.endIndex
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: MyWalletTableCell.self, indexPath: indexPath)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.menuContent.endIndex
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueHeaderFooter(with: MyWalletSectionView.self)
        view.sectionTappedAction = { [weak self] (sender) in
            guard let selff = self else { return }
            if selff.menuContent[section].1.endIndex == 0 {
                selff.menuContent[section].1 = ["1","2","3","4","5","6"]
            } else {
                 selff.menuContent[section].1 = []
            }
            tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .fade)
        }
        self.rotateLeft(dropdownView: view.dropdownBtn,left : (self.menuContent[section].1.isEmpty ) ? 0 : -1)
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

