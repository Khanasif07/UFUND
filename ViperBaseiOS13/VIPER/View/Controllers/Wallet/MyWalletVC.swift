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
    var selectedCurrencyType = "ETC"
    let bottomSheetVC = MyWalletSheetVC()
    var  buttonView = UIButton()
    private lazy var loader  : UIView = {
        return createActivityIndicator(self.view)
    }()
       
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
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func overAllUserInvestmentBtnAction(_ sender: UIButton) {
        let vc = AllProductsVC.instantiate(fromAppStoryboard: .Products)
        vc.productTitle = Constants.string.overall_user_investment.localize()
        vc.productType = .AllProducts
        self.navigationController?.pushViewController(vc, animated: true)
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
        self.setUpBorder()
        self.setFont()
        self.hitWalletAPI()
    }
    
    private func setUpBorder(){
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
        } else {
            currencyTextField.rightView = nil
            currencyTextField.inputView = nil
            currencyTextField.text = " Dollar (USD)"
            currencyTextField.isUserInteractionEnabled = false
        }
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
    
    private func hitWalletAPI(){
        self.loader.isHidden = false
        self.presenter?.HITAPI(api: Base.investor_wallet_counts.rawValue, params: nil, methodType: .GET, modelClass: WalletModuleEntity.self, token: true)
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
        vc.sortArray = [("ETC",false),("BITCOIN",false)]
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
                self.userInvestmentValueLbl.text = "$ " + "\(data.overall_invest ?? 0)"
                self.totalProductsValueLbl.text = "\(data.total_products ?? 0)"
                self.totalAssetsValueLbl.text = "\(data.total_tokens ?? 0)"
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


//MARK:- Sorting
//==============
extension MyWalletVC: ProductSortVCDelegate{
    
    func sortingApplied(sortType: String){
        self.selectedCurrencyType = sortType
        currencyTextField.text =  self.selectedCurrencyType
    }
}
