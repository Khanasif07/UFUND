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
    @IBOutlet weak var addressTxtField: UITextField!
    @IBOutlet weak var numberToknsTxtField: UITextField!
    @IBOutlet weak var tokenTxtField: UITextField!
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
    private lazy var loader  : UIView = {
          return createActivityIndicator(self.view)
      }()
    
    
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
        self.headerContainerView.roundCorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 10)
        self.headerBottomContainerView.roundCorners([.layerMinXMaxYCorner, .layerMaxXMaxYCorner], radius: 10)
        self.sendBtn.layer.cornerRadius = 4.0
    }
    
    // MARK: - IBActions
    //===========================
    
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
        self.mainTableView.tableHeaderView = headerView
        self.mainTableView.tableFooterView?.height = isDeviceIPad ? 175.0 : 125.0
        self.hitWalletBalanceAPI()
        self.hitGetUserTokenAPI()
    }
    
    private func setUpFont(){
        self.titleLbl.font = isDeviceIPad ? .setCustomFont(name: .bold, size: .x20) : .setCustomFont(name: .bold, size: .x16)
        self.sendBtn.titleLabel?.font =  isDeviceIPad ? .setCustomFont(name: .semiBold, size: .x18) : .setCustomFont(name: .semiBold, size: .x14)
        [addressTxtField,tokenTxtField,numberToknsTxtField].forEach { (textFIeld) in
            textFIeld?.font =  isDeviceIPad ? .setCustomFont(name: .medium, size: .x16) : .setCustomFont(name: .regular, size: .x12)
            textFIeld?.applyEffectToView()
        }
    }
    
    private func hitWalletBalanceAPI(){
        self.presenter?.HITAPI(api: Base.wallet.rawValue, params: nil , methodType: .GET, modelClass: WalletEntity.self, token: true)
    }
    
    private func hitGetUserTokenAPI(){
        self.loader.isHidden = false
        self.presenter?.HITAPI(api: Base.get_user_token.rawValue, params: nil, methodType: .GET, modelClass: InvestorDashboardEntity.self, token: true)
        
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
            cell.isFromCampainer = userType == UserType.investor.rawValue ? false : true
            cell.investorDashboardData = DashboardEntity()
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
        return UITableViewHeaderFooterView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
                self.balanceLbl.text = "\(data.eth ?? 0.0 )" + "ETH"
            }
            self.mainTableView.reloadData()
        case Base.get_user_token.rawValue:
            self.loader.isHidden = true
            let investorDashboardEntity = dataDict as? CampaignerDashboardEntity
            if (investorDashboardEntity?.data) != nil {
//                self.campaignerDashboardData = productData
            }
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

