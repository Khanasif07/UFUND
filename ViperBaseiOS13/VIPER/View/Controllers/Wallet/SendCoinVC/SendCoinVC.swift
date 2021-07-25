//
//  SendCoinVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 18/05/21.
//  Copyright © 2021 CSS. All rights reserved.
//


import UIKit
import ObjectMapper

class SendCoinVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var addressTxtField: AppTextField!
    @IBOutlet weak var numberToknsTxtField: AppTextField!
    @IBOutlet weak var tokenTxtField: AppTextField!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var headerBottomContainerView: UIView!
    @IBOutlet weak var headerContainerView: UIView!
    @IBOutlet weak var balanceLbl: UILabel!
    @IBOutlet weak var coinValueLbl: UILabel!
    @IBOutlet weak var coinTypeLbl: UILabel!
    @IBOutlet weak var headerImgView: UIImageView!
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    
    // MARK: - Variables
    //===========================
    let userType = UserDefaults.standard.value(forKey: UserDefaultsKey.key.isFromInvestor) as? String
    var sections : [SendCoinCell] = [.tokensListing,.TransactionHistory]
    var walletBalance = WalletBalance()
    var tokenListing = [SendTokenTypeModel]()
    var sortTypeAppliedCategory = SendTokenTypeModel()
    private lazy var loader  : UIView = {
          return createActivityIndicator(self.view)
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
    
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.mainTableView.layoutIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.mainTableView.reloadData()
    }
       
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerContainerView.addShadowRounded(cornerRadius: 10, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 5)
         headerBottomContainerView.addShadowRounded(cornerRadius: 10, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 5)
        self.sendBtn.layer.cornerRadius = 4.0
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func sendBtnTapped(_ sender: UIButton) {
        guard let tokenName = self.tokenTxtField.text, !tokenName.isEmpty else {
        ToastManager.show(title: Constants.string.enterTokenName, state: .warning)
             return
         }
         guard let numberOfToken =  self.numberToknsTxtField.text, !numberOfToken.isEmpty else{
               ToastManager.show(title: Constants.string.enterBrand, state: .warning)
             return
         }
         guard let address =  self.addressTxtField.text, !address.isEmpty else{
               ToastManager.show(title: Constants.string.enterProducts, state: .warning)
             return
         }
        self.hitSendTokenAPI()
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.popOrDismiss(animation: true)
    }
    
}

// MARK: - Extension For Functions
//===========================
extension SendCoinVC {
    
    private func initialSetup() {
        self.setUpFont()
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.registerCell(with: SendCoinsTableCell.self)
        self.mainTableView.registerHeaderFooter(with: SideMenuHeaderView.self)
        self.mainTableView.tableHeaderView = headerView
        self.mainTableView.tableFooterView?.height = isDeviceIPad ? 175.0 : 125.0
        self.hitWalletBalanceAPI()
        self.hitGetUserTokenAPI()
    }
    
    private func setUpFont(){
        self.titleLbl.font = isDeviceIPad ? .setCustomFont(name: .bold, size: .x20) : .setCustomFont(name: .bold, size: .x16)
        self.sendBtn.titleLabel?.font =  isDeviceIPad ? .setCustomFont(name: .semiBold, size: .x18) : .setCustomFont(name: .semiBold, size: .x14)
        [addressTxtField,tokenTxtField,numberToknsTxtField].forEach { (textFIeld) in
            textFIeld?.delegate = self
            textFIeld?.font =  isDeviceIPad ? .setCustomFont(name: .medium, size: .x16) : .setCustomFont(name: .regular, size: .x12)
            textFIeld?.applyEffectToView()
        }
        numberToknsTxtField.keyboardType = .numberPad
        let buttonView = UIButton()
        buttonView.isUserInteractionEnabled = false
        buttonView.imageEdgeInsets = UIEdgeInsets(top: 0, left: -7.5, bottom: 0, right: +7.5)
        tokenTxtField.setButtonToRightView(btn: buttonView, selectedImage: #imageLiteral(resourceName: "dropDownButton"), normalImage: #imageLiteral(resourceName: "dropDownButton"), size: CGSize(width: 20, height: 20))
    }
    
    private func hitWalletBalanceAPI(){
        self.presenter?.HITAPI(api: Base.wallet.rawValue, params: nil , methodType: .GET, modelClass: WalletEntity.self, token: true)
    }
    
    private func hitGetUserTokenAPI(){
        self.loader.isHidden = false
        self.presenter?.HITAPI(api: Base.get_user_token.rawValue, params: nil, methodType: .GET, modelClass: SendTokenTypeModelEntity.self, token: true)
    }
    
    private func hitSendTokenAPI(){
          self.loader.isHidden = false
        let params  = [ProductCreate.keys.tokenId: self.sortTypeAppliedCategory.id ?? 0,ProductCreate.keys.amount: self.numberToknsTxtField.text ?? "",ProductCreate.keys.to_eth_address: self.addressTxtField.text ?? ""] as [String : Any]
          self.presenter?.HITAPI(api: Base.sendCoin.rawValue, params: params, methodType: .POST, modelClass: SendTokenTypeModelEntity.self, token: true)
      }
    
}

// MARK: - Extension For TableView
//===========================
extension SendCoinVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case .tokensListing:
            let cell = tableView.dequeueCell(with: SendCoinsTableCell.self, indexPath: indexPath)
//            cell.tabsTapped = {   [weak self]  (selectedIndex) in
//                guard let selff = self else {return}
//                selff.tabsRedirection(selectedIndex)
//            }
            cell.seeAllBtn.isHidden = !(self.tokenListing.endIndex >= 6)
            cell.isFromCampainer = userType == UserType.investor.rawValue ? false : true
            cell.tokenListing = self.tokenListing
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.endIndex
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].sectionCount
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch sections[section] {
        case .TransactionHistory:
            let view = tableView.dequeueHeaderFooter(with: SideMenuHeaderView.self)
            view.backgroundColor = .clear
            view.imageView.alpha = 0.0
            view.dropdownView?.isHidden = true
            view.titleLbl.text = "Transaction history"
            view.titleLbl.font = .setCustomFont(name: .medium, size: .x14)
            view.titleLbl.textColor = .black
            return view
        default:
            return UITableViewHeaderFooterView()
        }
      
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch sections[section] {
        case .TransactionHistory:
            return 50.0
        default:
            return 0.0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            if isDeviceIPad {
                return (self.tokenListing.isEmpty) ? 64.0 : (CGFloat(325 * self.tokenListing.endIndex))
            } else {
                return (self.tokenListing.isEmpty) ? 64.0 : (CGFloat(215 * self.tokenListing.endIndex))
            }
        default:
             return UITableView.automaticDimension
        }
    }
}


//MARK: - PresenterOutputProtocol
//===========================
extension SendCoinVC: PresenterOutputProtocol {
    
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        switch api {
        case Base.wallet.rawValue:
            self.loader.isHidden = true
            let walletData = dataDict as? WalletEntity
            if let data = walletData?.balance {
                self.walletBalance = data
                self.coinValueLbl.text = "\(data.eth ?? 0.0 )" + "ETH"
            }
            self.mainTableView.reloadData()
        case Base.get_user_token.rawValue:
            self.loader.isHidden = true
            let sendTokenModelEntity = dataDict as? SendTokenTypeModelEntity
            self.currentPage = sendTokenModelEntity?.data?.current_page ?? 0
            self.lastPage = sendTokenModelEntity?.data?.last_page ?? 0
            isRequestinApi = false
            nextPageAvailable = self.lastPage > self.currentPage
            if let productDict = sendTokenModelEntity?.data?.data {
                if self.currentPage == 1 {
                    self.tokenListing = productDict
                } else {
                    self.tokenListing.append(contentsOf: productDict)
                }
            }
            self.currentPage += 1
            self.mainTableView.reloadData()
        default:
            self.loader.isHidden = true
            break
        }
    }
    
    func showError(error: CustomError) {
        self.loader.isHidden = true
        ToastManager.show(title:  nullStringToEmpty(string: error.localizedDescription.trimString()), state: .error)
    }
}

// MARK: - Extension For TextField Delegate
//====================================
extension SendCoinVC : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        let text = textField.text?.byRemovingLeadingTrailingWhiteSpaces ?? ""
        switch textField {
        case tokenTxtField:
            textField.text = text
        case addressTxtField:
             textField.text = text
        case numberToknsTxtField:
             textField.text = text
        default:
            print("Do Nothing")
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        _ = textField.text?.byRemovingLeadingTrailingWhiteSpaces ?? ""
        switch textField {
        case tokenTxtField:
            self.view.endEditing(true)
            guard let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.ProductSortVC) as? ProductSortVC else { return }
            vc.delegate = self
            vc.usingForSort = .sendToken
            vc.sortDataSendTokenArray = self.tokenListing
            vc.selectedSendTokentMethod = self.sortTypeAppliedCategory
            self.present(vc, animated: true, completion: nil)
        default:
            print("Do Nothing")
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let _ = textField.text ?? ""
//        guard let stringRange = Range(range, in: currentText) else { return false }
        switch textField {
        case tokenTxtField:
            return true
        default:
            return true
        }
    }
        
}
//MARK:- Sorting
//==============
extension SendCoinVC: ProductSortVCDelegate{
    func sortingAppliedInSendTokenType(sortType: SendTokenTypeModel) {
        self.sortTypeAppliedCategory = sortType
        self.tokenTxtField.text =  sortType.tokenname
        self.mainTableView.reloadData()
    }
}
