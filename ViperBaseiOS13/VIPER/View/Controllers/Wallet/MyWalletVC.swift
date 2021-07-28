//
//  MyWalletVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 15/03/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit
import iOSDropDown
import ObjectMapper

class MyWalletVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var currencyImgView: UIImageView!
    @IBOutlet weak var overAllUserInvestmentBtn: UIButton!
    @IBOutlet weak var withdrawlBtnLbl: UILabel!
    @IBOutlet weak var depositBtnLbl: UILabel!
    @IBOutlet weak var yourWalletBalanceTitleLbl: UILabel!
    @IBOutlet weak var totalTokensTitleLbl: UILabel!
    @IBOutlet weak var totalProductsTitlelbl: UILabel!
    @IBOutlet weak var overUserInvestLbl: UILabel!
    @IBOutlet weak var currencyTextField: UITextField!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var dropdownView: UIView!
    @IBOutlet weak var currencyControl: UISegmentedControl!
    @IBOutlet weak var middleView: UIStackView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var userInvestmentImgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var userInvestmentValueLbl: UILabel!
    @IBOutlet weak var totalProductsValueLbl: UILabel!
    @IBOutlet weak var totalAssetsValueLbl: UILabel!
    @IBOutlet weak var withdrawlView: UIView!
    @IBOutlet weak var totalAssetsImgView: UIImageView!
    @IBOutlet weak var totalProductImgView: UIImageView!
    @IBOutlet weak var depositView: UIView!
    @IBOutlet weak var yourWalletBalanceLbl: UILabel!
    @IBOutlet weak var walletBalanceView: UIView!
    // MARK: - Variables
    //===========================
    var walletBalance = WalletBalance()
    var walletModule = WalletModule()
    let userType = UserDefaults.standard.value(forKey: UserDefaultsKey.key.isFromInvestor) as? String
    var depositUrl : String = ""
    var selectedCurrencyType = "ETH"
    let bottomSheetVC = MyWalletSheetVC()
    var  buttonView = UIButton()
    private lazy var loader  : UIView = {
        return createActivityIndicator(self.bottomSheetVC.view)
    }()
    
    //Pagination
    var hideLoader: Bool = false
    var nextPageAvailable = true
    var isRequestinApi = false
    var showPaginationLoader: Bool {
        return  hideLoader ? false : nextPageAvailable
    }
    var currentPage: Int = 0
    var lastPage: Int  = 0
    
    //Pagination
    var hideLoader1: Bool = false
    var nextPageAvailable1 = true
    var isRequestinApi1 = false
    var showPaginationLoader1: Bool {
        return  hideLoader ? false : nextPageAvailable
    }
    var currentPage1: Int = 0
    var lastPage1: Int  = 0
       
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self.view)
        if self.bottomSheetVC.view.frame.contains(touchLocation) {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        bottomSheetVC.closePullUp()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addBottomSheetView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        depositView.addShadowRounded(cornerRadius: 5, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 5)
        withdrawlView.addShadowRounded(cornerRadius: 5, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 5)
        walletBalanceView.addShadowRounded(cornerRadius: 5, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 5)
        topView.addShadowRounded(cornerRadius: 5, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 5)
        middleView.subviews.forEach { (innerView) in
            innerView.addShadowRounded(cornerRadius: 5, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 5)
        bottomSheetVC.view.dropShadow(cornerRadius: 10, color: UIColor.black16, offset: CGSize(width: 0, height: -3), opacity: 0.16, shadowRadius: 8)
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func withdrawlBtnAction(_ sender: UIButton) {
        let vc = MyWalletWithdrawlVC.instantiate(fromAppStoryboard: .Wallet)
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func depositBtnAction(_ sender: UIButton) {
        let vc = MyWalletDepositVC.instantiate(fromAppStoryboard: .Wallet)
        vc.depositUrl = self.depositUrl
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func overAllUserInvestmentBtnAction(_ sender: UIButton) {
        if userType == UserType.investor.rawValue {
        let vc = AllProductsVC.instantiate(fromAppStoryboard: .Products)
        vc.productTitle = Constants.string.overall_user_investment.localize()
        vc.productType = .AllProducts
        self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func totalProductsBtnAction(_ sender: UIButton) {
        let vc = AllProductsVC.instantiate(fromAppStoryboard: .Products)
        vc.productTitle = Constants.string.totalProducts.localize()
        vc.productType = .AllProducts
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func totalAssetsBtnAction(_ sender: UIButton) {
        let vc = AllProductsVC.instantiate(fromAppStoryboard: .Products)
        vc.productTitle = Constants.string.myToken_and_assets.localize()
        vc.productType = .AllProducts
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.popOrDismiss(animation: true)
    }
    
    
}

// MARK: - Extension For Functions
//===========================
extension MyWalletVC {
    
    private func initialSetup() {
        NotificationCenter.default.addObserver(self, selector: #selector(purchaseDidFinish), name: .PaymentSucessfullyDone, object: nil)
        self.setUpBorder()
        self.setFont()
        self.hitWalletCountAPI()
        self.hitBuyInvestHistoryAPI()
        self.hitWalletBalanceAPI()
        self.getDepositUrl()
    }
    
    private func setUpBorder(){
        currencyImgView.image = #imageLiteral(resourceName: "eth")
        self.titleLbl.font = isDeviceIPad ? .setCustomFont(name: .bold, size: .x20) : .setCustomFont(name: .bold, size: .x16)
        DispatchQueue.main.async {
            [self.userInvestmentImgView,self.totalAssetsImgView,self.totalProductImgView].forEach { (imgView) in
                imgView?.layer.masksToBounds = true
                imgView?.layer.borderWidth = 8.0
                imgView?.layer.borderColor = UIColor.rgb(r: 237, g: 236, b: 255).cgColor
                imgView?.layer.cornerRadius = (imgView?.bounds.width ?? 0.0) / 2
            }
        }
        dropdownView?.layer.masksToBounds = true
        dropdownView?.layer.borderWidth = 2.0
        dropdownView?.layer.borderColor = UIColor.rgb(r: 237, g: 236, b: 255).cgColor
        dropdownView?.layer.cornerRadius = 4.0
        currencyControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        self.currencyTextField.delegate = self
        buttonView.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        currencyTextField.setButtonToRightView(btn: buttonView, selectedImage: #imageLiteral(resourceName: "icDropdown"), normalImage: #imageLiteral(resourceName: "icDropdown"), size: CGSize(width: 20, height: 20))
//        currencyTextField.setButtonToLeftView(btn: buttonView, selectedImage: #imageLiteral(resourceName: "btc"), normalImage: #imageLiteral(resourceName: "btc"), size: CGSize(width: 20, height: 20))
        currencyTextField.text = self.selectedCurrencyType
        self.overAllUserInvestmentBtn.isHidden  = userType == UserType.campaigner.rawValue
        self.topView.isHidden = userType == UserType.campaigner.rawValue
        self.totalProductsTitlelbl.text = userType == UserType.campaigner.rawValue ? "Total Add Products" : "Total Invested Products"
        self.totalTokensTitleLbl.text = userType == UserType.campaigner.rawValue ? "Total Add Tokenized Assets" : "Total Invested Tokenized Assets"
    }
    
    private func setFont(){
        [totalTokensTitleLbl,totalProductsTitlelbl,overUserInvestLbl].forEach { (lbl) in
            lbl.font  = isDeviceIPad ? .setCustomFont(name: .medium, size: .x16) : .setCustomFont(name: .medium, size: .x12)
        }
        yourWalletBalanceTitleLbl.font  = isDeviceIPad ? .setCustomFont(name: .regular, size: .x18) : .setCustomFont(name: .regular, size: .x14)
        currencyTextField.font  = isDeviceIPad ? .setCustomFont(name: .medium, size: .x16) : .setCustomFont(name: .medium, size: .x12)
        [withdrawlBtnLbl,depositBtnLbl].forEach { (lbl) in
            lbl.font  = isDeviceIPad ? .setCustomFont(name: .medium, size: .x18) : .setCustomFont(name: .medium, size: .x14)
        }
        [userInvestmentValueLbl,totalProductsValueLbl,totalAssetsValueLbl].forEach { (lbl) in
            lbl.font  = isDeviceIPad ? .setCustomFont(name: .bold, size: .x28) : .setCustomFont(name: .bold, size: .x24)
        }
        yourWalletBalanceLbl.font  = isDeviceIPad ? .setCustomFont(name: .semiBold, size: .x32) : .setCustomFont(name: .semiBold, size: .x28)
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            currencyTextField.setButtonToRightView(btn: buttonView, selectedImage: #imageLiteral(resourceName: "icDropdown"), normalImage: #imageLiteral(resourceName: "icDropdown"), size: CGSize(width: 20, height: 20))
            currencyTextField.text =  self.selectedCurrencyType
            currencyTextField.isUserInteractionEnabled = true
            currencyTextField.isHidden = false
            currencyImgView.isHidden = false
            if selectedCurrencyType == "ETH"{
                 self.yourWalletBalanceLbl.text = "\(walletBalance.eth ?? 0.0 )"
                 currencyImgView.image = #imageLiteral(resourceName: "eth")
            } else {
                 self.yourWalletBalanceLbl.text = "\(walletBalance.btc ?? 0.0 )"
                 currencyImgView.image = #imageLiteral(resourceName: "btc")
            }
        } else {
            currencyTextField.rightView = nil
            currencyTextField.inputView = nil
            currencyTextField.text = " Dollar (USD)"
            currencyImgView.isHidden = true
            currencyTextField.isUserInteractionEnabled = false
            self.yourWalletBalanceLbl.text = "$ " + "\(walletBalance.wallet ?? 0.0 )"
        }
    }
    
    @objc func purchaseDidFinish(){
        self.hitWalletCountAPI(loader:true)
    }
    
    func addBottomSheetView() {
        
        guard !self.children.contains(bottomSheetVC) else { return }
        self.addChild(bottomSheetVC)
        self.view.insertSubview(bottomSheetVC.view, belowSubview: self.topView)
        let height = view.frame.height
        let width  = view.frame.width
        bottomSheetVC.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)
        if UIScreen.main.bounds.size.height <= 812 {
            bottomSheetVC.bottomLayoutConstraint.constant = self.view.safeAreaInsets.bottom + (self.tabBarController?.tabBar.height ?? 0)
        }
        let adjustForTabbarInsets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 0, bottom: self.tabBarController?.tabBar.frame.height ?? 30, right: 0)
        bottomSheetVC.mainTableView.contentInset = adjustForTabbarInsets
        bottomSheetVC.mainTableView.scrollIndicatorInsets = adjustForTabbarInsets
        let globalPoint = bottomStackView.superview?.convert(bottomStackView.frame.origin, to: nil)
        bottomSheetVC.textContainerHeight = (globalPoint?.y ?? 0.0)
        self.view.layoutIfNeeded()
    }
    
    private func hitWalletCountAPI(loader:Bool = false){
        self.loader.isHidden = loader
        self.presenter?.HITAPI(api: Base.investor_wallet_counts.rawValue, params: nil, methodType: .GET, modelClass: WalletModuleEntity.self, token: true)
    }
    
    private func hitWalletBalanceAPI(){
        self.presenter?.HITAPI(api: Base.wallet.rawValue, params: nil , methodType: .GET, modelClass: WalletEntity.self, token: true)
    }
    private func getDepositUrl(){
        self.presenter?.HITAPI(api: Base.deposit_Url.rawValue, params: nil , methodType: .GET, modelClass: DepositUrlModel.self, token: true)
    }
    
    private func hitBuyInvestHistoryAPI(){
        self.loader.isHidden = false
        self.presenter?.HITAPI(api: Base.invester_buy_Invest_hisory.rawValue, params: nil, methodType: .GET, modelClass: BuyInvestHistoryEntity.self, token: true)
    }
    
}

// MARK: - Extension For TableView
//===========================
extension MyWalletVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

//MARK: - PresenterOutputProtocol
//===========================
extension MyWalletVC : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        _ = textField.text?.byRemovingLeadingTrailingWhiteSpaces ?? ""
        self.view.endEditing(true)
        guard let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.ProductSortVC) as? ProductSortVC else { return }
        vc.delegate = self
        vc.usingForSort = .filter
        vc.sortArray = [("ETH",false),("BTC",false)]
        vc.sortTypeApplied = self.selectedCurrencyType
        self.present(vc, animated: true, completion: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        view.endEditingForce()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditingForce()
        return true
    }
}


//MARK: - PresenterOutputProtocol
//===========================
extension MyWalletVC: PresenterOutputProtocol {
    
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        self.loader.isHidden = true
        switch api {
        case Base.investor_wallet_counts.rawValue:
            let walletData = dataDict as? WalletModuleEntity
            if let data = walletData?.data {
                self.walletModule = data
                self.bottomSheetVC.walletModule = self.walletModule
                self.userInvestmentValueLbl.text = "$ " + "\(data.overall_invest ?? 0)"
                self.totalProductsValueLbl.text = "\(data.total_products ?? 0)"
                self.totalAssetsValueLbl.text = "\(data.total_tokens ?? 0)"
                self.currentPage = data.wallet_histories?.current_page ?? 0
                self.lastPage = data.wallet_histories?.last_page ?? 0
                isRequestinApi = false
                nextPageAvailable = self.lastPage > self.currentPage
                if let productDict = data.wallet_histories?.data {
                    if self.currentPage == 1 {
                        self.walletModule.wallet_histories?.data = productDict
                    } else {
                        self.walletModule.wallet_histories?.data?.append(contentsOf: productDict)
                    }
                }
                self.currentPage += 1
            }
        case  Base.wallet.rawValue:
            let walletData = dataDict as? WalletEntity
            if let data = walletData?.balance {
                self.walletBalance = data
                self.yourWalletBalanceLbl.text = "\(data.eth ?? 0.0 )"
            }
        case Base.invester_buy_Invest_hisory.rawValue:
            let productModelEntity = dataDict as? BuyInvestHistoryEntity
            self.currentPage1 = productModelEntity?.data?.current_page ?? 0
            self.lastPage1 = productModelEntity?.data?.last_page ?? 0
            isRequestinApi1 = false
            nextPageAvailable1 = self.lastPage1 > self.currentPage1
            if let productDict = productModelEntity?.data?.data {
                if self.currentPage1 == 1 {
                    self.walletModule.invest_histories = productDict
                    self.bottomSheetVC.walletModule.invest_histories = productDict
                } else {
                    self.walletModule.invest_histories?.append(contentsOf: productDict)
                    self.bottomSheetVC.walletModule.invest_histories?.append(contentsOf: productDict)
                }
            }
            self.currentPage1 += 1
        case Base.deposit_Url.rawValue:
            let walletData = dataDict as? DepositUrlModel
            self.depositUrl = walletData?.url ?? ""
            print(walletData)
        case Base.invester_buy_Invest_hisory.rawValue:
            print("invester_buy_Invest_hisory")
        default:
            break
        }
    }
    
    func showError(error: CustomError) {
        self.loader.isHidden = true
        ToastManager.show(title:  nullStringToEmpty(string: error.localizedDescription.trimString()), state: .error)
    }
}


//MARK:- Sorting
//==============
extension MyWalletVC: ProductSortVCDelegate{
    
    func sortingApplied(sortType: String){
        self.selectedCurrencyType = sortType
        currencyTextField.text =  self.selectedCurrencyType
        if selectedCurrencyType == "ETH"{
            self.yourWalletBalanceLbl.text = "\(walletBalance.eth ?? 0.0 )"
            currencyImgView.image = #imageLiteral(resourceName: "eth")
        } else {
            self.yourWalletBalanceLbl.text = "\(walletBalance.btc ?? 0.0 )"
            currencyImgView.image = #imageLiteral(resourceName: "btc")
        }
    }
}
