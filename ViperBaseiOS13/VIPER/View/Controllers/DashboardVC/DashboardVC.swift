//
//  DashboardVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 23/03/21.
//  Copyright © 2021 CSS. All rights reserved.
//
import Charts
import UIKit
import ObjectMapper

class DashboardVC: UIViewController {
    
    enum DashboardCellType: String{
        case DashboardTabsTableCell
        case DashboardBarChartCell
        case DashboardInvestmentCell
        case DashboardSubmittedProductsCell
        case DashboardSubmittedAsssetsCell
        case DashboardSellHistory
        case DashboardSellHistoryListing
    }
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    
    // MARK: - Variables
    //===========================
    var cellTypes : [DashboardCellType] = [.DashboardTabsTableCell,.DashboardBarChartCell,.DashboardInvestmentCell]
    var investorDashboardData : DashboardEntity?
    var investorDashboardGraphData : DashboardEntity?
    var campaignerDashboardData : DashboardEntity?
    var isBuyHistoryTabSelected: Bool = false
    var sortTypeForMonthly: String = Constants.string.yearly
    var sortTypeForHistory : String = Constants.string.buyHistory
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
    
    // MARK: - IBActions
    //===========================
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.popOrDismiss(animation: true)
    }
    
    
}

// MARK: - Extension For Functions
//===========================
extension DashboardVC {
    
    private func initialSetup() {
        self.dashboardTypeSetUp()
        self.tableViewSetUp()
    }
    
    private func dashboardTypeSetUp(){
        if userType == UserType.investor.rawValue{
            self.cellTypes = [.DashboardTabsTableCell,.DashboardBarChartCell,.DashboardInvestmentCell]
            self.hitInvestorDashboardAPI()
            let type: Any = (sortTypeForHistory == Constants.string.buyHistory) ? "BUY" : (sortTypeForHistory == Constants.string.buyHistory) ? "INVEST" : 3
            let filterType: Any = (sortTypeForMonthly == Constants.string.daily) ? 1 : (sortTypeForHistory == Constants.string.weekly) ? 2 : (sortTypeForHistory == Constants.string.monthly) ? 3 : 4
            self.hitInvestorDashboardGraphsAPI(params: [ProductCreate.keys.type: type,ProductCreate.keys.filter_type: filterType])
        } else {
            self.cellTypes = [.DashboardSubmittedProductsCell,.DashboardSubmittedAsssetsCell,.DashboardSellHistory]
            self.hitCampaignerDashboardAPI()
//            self.hitWalletCountAPI()
        }
    }
    
    private func tableViewSetUp(){
        self.titleLbl.font = isDeviceIPad ? .setCustomFont(name: .bold, size: .x20) : .setCustomFont(name: .bold, size: .x16)
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.registerHeaderFooter(with: DashboardSellHistroryView.self)
        self.mainTableView.registerCell(with: DashboardTabsTableCell.self)
        self.mainTableView.registerCell(with: DashboardBarChartCell.self)
        self.mainTableView.registerCell(with: DashboardInvestmentCell.self)
        self.mainTableView.registerCell(with: DashboardSubmittedProductsCell.self)
        self.mainTableView.registerCell(with: MyWalletTableCell.self)
        self.mainTableView.registerHeaderFooter(with: MyWalletSectionView.self)
    }
    
    private func hitInvestorDashboardAPI(){
        self.loader.isHidden = false
        self.presenter?.HITAPI(api: Base.investor_dashboard.rawValue, params: nil, methodType: .GET, modelClass: InvestorDashboardEntity.self, token: true)
        
    }
    
    private func hitWalletCountAPI(loader:Bool = false){
        self.loader.isHidden = loader
        self.presenter?.HITAPI(api: Base.investor_wallet_counts.rawValue, params: nil, methodType: .GET, modelClass: WalletModuleEntity.self, token: true)
    }
    
    private func hitInvestorDashboardGraphsAPI(params : [String:Any] = [ProductCreate.keys.type: "BUY",ProductCreate.keys.filter_type: 4]){
        self.loader.isHidden = false
        self.presenter?.HITAPI(api: Base.investor_dashboard_graph.rawValue, params: params, methodType: .GET, modelClass: InvestorDashboardEntity.self, token: true)
        
    }
    
    private func hitCampaignerDashboardAPI(){
        self.loader.isHidden = false
        self.presenter?.HITAPI(api: Base.campaigner_dashboard.rawValue, params: nil, methodType: .GET, modelClass: CampaignerDashboardEntity.self, token: true)
        
    }
    
    private func  tabsRedirection(_ indexPath: IndexPath){
        switch indexPath.row {
        case 0:
            guard let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.CategoriesVC) as? CategoriesVC else { return }
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let selectedVC = CategoriesProductsDetailVC.instantiate(fromAppStoryboard: .Main)
            selectedVC.categoryTitle = Constants.string.Products.localize()
            selectedVC.isFilterWithoutCategory = false
            self.navigationController?.pushViewController(selectedVC, animated: true)
        case 2:
            let selectedVC = CategoryTokensDetailVC.instantiate(fromAppStoryboard: .Products)
            selectedVC.categoryTitle = Constants.string.TokenizedAssets.localize()
             selectedVC.isFilterWithoutCategory = false
            self.navigationController?.pushViewController(selectedVC, animated: true)
        case 3:
            let vc = ProductTokenInvestmentVC.instantiate(fromAppStoryboard: .Products)
            self.navigationController?.pushViewController(vc, animated: true)
        case 5:
            let vc = MyWalletVC.instantiate(fromAppStoryboard: .Wallet)
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            print("Nothing")
        }
    }
    
}

// MARK: - Extension For TableView
//===========================
extension DashboardVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.cellTypes.endIndex
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.cellTypes[section] {
        case .DashboardSellHistoryListing:
            return (self.campaignerDashboardData?.sell_histories?[section - 3].isSelected ?? false) ? 5 : 0
        case .DashboardSellHistory:
            return 0
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch cellTypes[indexPath.section] {
        case .DashboardTabsTableCell:
            let cell = tableView.dequeueCell(with: DashboardTabsTableCell.self, indexPath: indexPath)
            cell.tabsTapped = {   [weak self]  (selectedIndex) in
                guard let selff = self else {return}
                selff.tabsRedirection(selectedIndex)
            }
            cell.isFromCampainer = userType == UserType.investor.rawValue ? false : true
            cell.investorDashboardData = investorDashboardData
            cell.tabsCollView.layoutIfNeeded()
            return cell
        case .DashboardBarChartCell:
            let cell = tableView.dequeueCell(with: DashboardBarChartCell.self, indexPath: indexPath)
//            cell.firstBarValue = self.investorDashboardGraphData?.series?.first?.data ?? []
            cell.vertXValues = self.investorDashboardGraphData?.lable!.map { String($0) } ?? []
            cell.buyHistoryTxtField.text = self.sortTypeForHistory
            cell.buyMonthlyTxtField.text = self.sortTypeForMonthly
            cell.buyMonthlyBtnTapped = { [weak self] (sender) in
                guard let sself = self else {return }
                guard let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.ProductSortVC) as? ProductSortVC else { return }
                vc.delegate = sself
                vc.sortArray = [(Constants.string.daily,false),(Constants.string.monthly,false),(Constants.string.weekly,false),(Constants.string.yearly,false)]
                sself.isBuyHistoryTabSelected = false
                vc.sortTypeApplied = sself.sortTypeForMonthly
                sself.present(vc, animated: true, completion: nil)
            }
            cell.buyHistoryBtnTapped = { [weak self] (sender) in
                guard let sself = self else {return }
                guard let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.ProductSortVC) as? ProductSortVC else { return }
                vc.delegate = sself
                vc.sortArray = [(Constants.string.buyHistory,false),(Constants.string.investHistory,false),(Constants.string.investHistoryPerCrypto,false)]
                sself.isBuyHistoryTabSelected = true
                vc.sortTypeApplied = sself.sortTypeForHistory
                sself.present(vc, animated: true, completion: nil)
            }
            return cell
        case .DashboardInvestmentCell:
            let cell = tableView.dequeueCell(with: DashboardInvestmentCell.self, indexPath: indexPath)
            cell.dollarInvestmentValue.text = "$ " + "\(self.investorDashboardData?.investments?.usd ?? "")"
            cell.btcInvestmentValue.text = "$ " + "\(self.investorDashboardData?.investments?.btc ?? "" )"
            cell.ethInvestmentValue.text = "$ " + "\(self.investorDashboardData?.investments?.eth ?? "")"
            let usdData = self.investorDashboardData?.investments?.usd ?? "0.0"
            let btcData = self.investorDashboardData?.investments?.btc ?? "0.0"
            let ethData = self.investorDashboardData?.investments?.eth ?? "0.0"
            cell.partiesPercentage = [Double(usdData) ?? 0.0,Double(btcData) ?? 0.0,Double(ethData) ?? 0.0]
            return cell
        case .DashboardSubmittedProductsCell:
            let cell = tableView.dequeueCell(with: DashboardSubmittedProductsCell.self, indexPath: indexPath)
            cell.valueBtnTapped = { [weak self] (sender) in
                guard let sself = self else {return }
                switch sender.tag {
                case 1:
                    let vc = AllProductsVC.instantiate(fromAppStoryboard: .Products)
                    vc.productTitle = Constants.string.liveProduct.localize()
                    vc.campaignerProductType = .Approve
                    vc.productType = .AllProducts
                    sself.navigationController?.pushViewController(vc, animated: true)
                case 2:
                    let vc = AllProductsVC.instantiate(fromAppStoryboard: .Products)
                    vc.productTitle = Constants.string.pendingProduct.localize()
                    vc.campaignerProductType = .PendingProduct
                    vc.productType = .AllProducts
                    sself.navigationController?.pushViewController(vc, animated: true)
                case 3:
                    let vc = AllProductsVC.instantiate(fromAppStoryboard: .Products)
                    vc.productTitle = Constants.string.rejectedProduct.localize()
                    vc.campaignerProductType = .RejectedProduct
                    vc.productType = .AllProducts
                    sself.navigationController?.pushViewController(vc, animated: true)
                default:
                    let vc = AllProductsVC.instantiate(fromAppStoryboard: .Products)
                    vc.productTitle = Constants.string.soldProduct.localize()
                    vc.campaignerProductType = .SoldProduct
                    vc.productType = .AllProducts
                    sself.navigationController?.pushViewController(vc, animated: true)
                }
            }
            cell.setupDescriptionForProducts(product: self.campaignerDashboardData?.product ?? ProductTypes())
            cell.partiesPercentage = [self.campaignerDashboardData?.product?.approved ?? 0,self.campaignerDashboardData?.product?.pending ?? 0,self.campaignerDashboardData?.product?.reject ?? 0,self.campaignerDashboardData?.product?.sold ?? 0]
            cell.submittedProductLbl.text = "Submitted Products"
            cell.submittedProductValue.textColor = #colorLiteral(red: 0.3176470588, green: 0.3450980392, blue: 0.7333333333, alpha: 1)
            cell.productImgView.image = #imageLiteral(resourceName: "icProductWithBg")
//            cell.bottomStackView.isHidden = (self.campaignerDashboardData?.submited_products ?? 0 == 0)
            cell.chartStackView.isHidden = (self.campaignerDashboardData?.submited_products ?? 0 == 0)
            cell.submittedProductValue.text = "\(self.campaignerDashboardData?.submited_products ?? 0)"
            return cell
        case .DashboardSubmittedAsssetsCell:
            let cell = tableView.dequeueCell(with: DashboardSubmittedProductsCell.self, indexPath: indexPath)
            cell.valueBtnTapped = { [weak self] (sender) in
                guard let sself = self else {return }
                switch sender.tag {
                case 1:
                    let vc = TokenizedAssetsVC.instantiate(fromAppStoryboard: .Products)
                    vc.productTitle = Constants.string.allTokens.localize()
                    vc.campaignerAssetType = .Approve
                    sself.navigationController?.pushViewController(vc, animated: true)
                case 2:
                    let vc = TokenizedAssetsVC.instantiate(fromAppStoryboard: .Products)
                    vc.productTitle = Constants.string.allTokens.localize()
                    vc.campaignerAssetType = .PendingAssets
                    sself.navigationController?.pushViewController(vc, animated: true)
                case 3:
                    let vc = TokenizedAssetsVC.instantiate(fromAppStoryboard: .Products)
                    vc.productTitle = Constants.string.allTokens.localize()
                    vc.campaignerAssetType = .RejectedAssets
                    sself.navigationController?.pushViewController(vc, animated: true)
                default:
                    let vc = TokenizedAssetsVC.instantiate(fromAppStoryboard: .Products)
                    vc.productTitle = Constants.string.allTokens.localize()
                    vc.campaignerAssetType = .SoldAssets
                    sself.navigationController?.pushViewController(vc, animated: true)
                }
            }
            cell.setupDescriptionForAssets(asset: self.campaignerDashboardData?.asset ?? AssetTypes())
            cell.partiesPercentage = [self.campaignerDashboardData?.asset?.approved ?? 0,self.campaignerDashboardData?.asset?.pending ?? 0,self.campaignerDashboardData?.asset?.reject ?? 0,self.campaignerDashboardData?.asset?.sold ?? 0]
            cell.productImgView.image = #imageLiteral(resourceName: "icTokenizedAssetBg")
            cell.submittedProductLbl.text = "Submitted Assets"
            cell.submittedProductValue.textColor = #colorLiteral(red: 0.9568627451, green: 0.6235294118, blue: 0.03921568627, alpha: 1)
//            cell.bottomStackView.isHidden = (self.campaignerDashboardData?.submited_assets ?? 0 == 0)
            cell.chartStackView.isHidden = (self.campaignerDashboardData?.submited_assets ?? 0 == 0)
            cell.submittedProductValue.text = "\(self.campaignerDashboardData?.submited_assets ?? 0)"
            return cell
        case .DashboardSellHistory:
            return UITableViewCell()
        case .DashboardSellHistoryListing:
              let cell = tableView.dequeueCell(with: MyWalletTableCell.self, indexPath: indexPath)
              if let sell_histories = self.campaignerDashboardData?.sell_histories{
               let sell_historiesData = [("Payment Method",sell_histories[indexPath.section - 3].type ?? ""),("Amount",String(sell_histories[indexPath.section - 3].amount ?? 0.0)),("Date",String(sell_histories[indexPath.section - 3].created_at ?? "")),("VIA",sell_histories[indexPath.section - 3].via ?? ""),("Status",sell_histories[indexPath.section - 3].status ?? "")]
                switch sell_historiesData[indexPath.row].0 {
                case "Date":
                    let date = (sell_historiesData[indexPath.row].1).toDate(dateFormat: Date.DateFormat.yyyyMMddHHmmss.rawValue) ?? Date()
                    cell.titleLbl.text = sell_historiesData[indexPath.row].0
                    cell.descLbl.text = date.convertToDefaultString()
                    cell.descLbl.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                case "Status":
                    cell.titleLbl.text = sell_historiesData[indexPath.row].0
                    cell.descLbl.text = sell_historiesData[indexPath.row].1.uppercased()
                    cell.descLbl.textColor =   #colorLiteral(red: 0.09411764706, green: 0.7411764706, blue: 0.4705882353, alpha: 1)
                default:
                    cell.titleLbl.text = sell_historiesData[indexPath.row].0
                    cell.descLbl.text = sell_historiesData[indexPath.row].1
                    cell.descLbl.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                }
              }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch cellTypes[section]  {
        case .DashboardSellHistory:
             let view  = tableView.dequeueHeaderFooter(with: DashboardSellHistroryView.self)
             view.dollarValueLbl.text = campaignerDashboardData?.total_amount ?? ""
             view.btcValueLbl.text = campaignerDashboardData?.btc_amount ?? ""
             view.ethValueLbl.text = campaignerDashboardData?.eth_amount ?? ""
             return view
        case .DashboardSellHistoryListing:
            let view = tableView.dequeueHeaderFooter(with: MyWalletSectionView.self)
            view.populateDataForSell(model: self.campaignerDashboardData?.sell_histories?[section - 3] ??  History())
            view.sectionTappedAction = { [weak self] (sender) in
                guard let selff = self else { return }
                if let sell_histories = selff.campaignerDashboardData?.sell_histories{
                    selff.campaignerDashboardData?.sell_histories?[section - 3].isSelected = !(sell_histories[section - 3].isSelected)
                }
                tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .fade)
            }
            return view
        default:
             return UITableViewHeaderFooterView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch cellTypes[section]  {
        case .DashboardSellHistory:
            return 200.0
        case .DashboardSellHistoryListing:
            return 48.0
        default:
            return 0.0
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch cellTypes[indexPath.section]{
        case .DashboardBarChartCell:
            return isDeviceIPad ? 450.0 : 350.0
        case .DashboardSubmittedProductsCell,.DashboardSubmittedAsssetsCell:
            return isDeviceIPad ? UITableView.automaticDimension : UITableView.automaticDimension
        case .DashboardInvestmentCell:
            return isDeviceIPad ? UITableView.automaticDimension : UITableView.automaticDimension
        case .DashboardSellHistoryListing:
            return 34.0
        default:
            return UITableView.automaticDimension
        }
        
    }
}

// MARK: - Sorting  Logic Implemented
//===========================
extension DashboardVC: ProductSortVCDelegate  {
    func sortingApplied(sortType: String) {
        if let cell = self.mainTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? DashboardBarChartCell{
            if  self.isBuyHistoryTabSelected {
                 self.sortTypeForHistory = sortType
                 cell.buyHistoryTxtField.text = self.sortTypeForHistory
                 let type: Any = (sortTypeForHistory == Constants.string.buyHistory) ? "BUY" : (sortTypeForHistory == Constants.string.buyHistory) ? "INVEST" : 3
                let filterType: Any = (sortTypeForMonthly == Constants.string.daily) ? 1 : (sortTypeForHistory == Constants.string.weekly) ? 2 : (sortTypeForHistory == Constants.string.monthly) ? 3 : 4
                 self.hitInvestorDashboardGraphsAPI(params: [ProductCreate.keys.type: type,ProductCreate.keys.filter_type: filterType])
            } else {
                self.sortTypeForMonthly = sortType
                cell.buyMonthlyTxtField.text = self.sortTypeForMonthly
                let type: Any = (sortTypeForHistory == Constants.string.buyHistory) ? "BUY" : (sortTypeForHistory == Constants.string.buyHistory) ? "INVEST" : 3
                let filterType: Any = (sortTypeForMonthly == Constants.string.daily) ? 1 : (sortTypeForHistory == Constants.string.weekly) ? 2 : (sortTypeForHistory == Constants.string.monthly) ? 3 : 4
                self.hitInvestorDashboardGraphsAPI(params: [ProductCreate.keys.type: type,ProductCreate.keys.filter_type: filterType])
            }
        }
    }
}


//MARK: - PresenterOutputProtocol
//===========================
extension DashboardVC: PresenterOutputProtocol {
    
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        switch api {
        case Base.investor_dashboard.rawValue:
            self.loader.isHidden = true
            let investorDashboardEntity = dataDict as? InvestorDashboardEntity
            if let productData = investorDashboardEntity?.data {
                self.investorDashboardData = productData
                let usdData = productData.total_earning?.usd ?? "0.0"
                let btcData = productData.total_earning?.btc ?? "0.0"
                let ethData = productData.total_earning?.eth ?? "0.0"
                let totalEarning = (Double(usdData) ?? 0.0) + (Double(btcData) ?? 0.0) + (Double(ethData) ?? 0.0)
                print(totalEarning)
            }
            self.mainTableView.reloadData()
        case Base.campaigner_dashboard.rawValue:
            self.loader.isHidden = true
            let investorDashboardEntity = dataDict as? CampaignerDashboardEntity
            if let productData = investorDashboardEntity?.data {
                self.campaignerDashboardData = productData
                if (self.campaignerDashboardData?.sell_histories?.endIndex ?? 0) > 0{
                    self.cellTypes = [.DashboardSubmittedProductsCell,.DashboardSubmittedAsssetsCell,.DashboardSellHistory,.DashboardSellHistoryListing]
                }
            }
            self.mainTableView.reloadData()
        case Base.investor_dashboard_graph.rawValue:
            self.loader.isHidden = true
            let investorDashboardEntity = dataDict as? InvestorDashboardEntity
            if let productData = investorDashboardEntity?.data {
                self.investorDashboardGraphData = productData
            }
            self.mainTableView.reloadData()
        default:
            let walletData = dataDict as? WalletModuleEntity
            if let data = walletData?.data {
                print(data)
//                self.walletModule = data
//                self.bottomSheetVC.walletModule = self.walletModule
//                self.userInvestmentValueLbl.text = "$ " + "\(data.overall_invest ?? 0)"
//                self.totalProductsValueLbl.text = "\(data.total_products ?? 0)"
//                self.totalAssetsValueLbl.text = "\(data.total_tokens ?? 0)"
            }
            self.mainTableView.reloadData()
            break
        }
    }
    
    func showError(error: CustomError) {
        self.loader.isHidden = true
        ToastManager.show(title:  nullStringToEmpty(string: error.localizedDescription.trimString()), state: .error)
    }
}

