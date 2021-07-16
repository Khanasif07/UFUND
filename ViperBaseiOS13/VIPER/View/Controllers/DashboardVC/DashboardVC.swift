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
    let userType = UserDefaults.standard.value(forKey: UserDefaultsKey.key.isFromInvestor) as? String
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
    }
    
    private func hitInvestorDashboardAPI(){
        self.loader.isHidden = false
        self.presenter?.HITAPI(api: Base.investor_dashboard.rawValue, params: nil, methodType: .GET, modelClass: InvestorDashboardEntity.self, token: true)
        
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
        return 1
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
            cell.dollarInvestmentValue.text = "$ " + "\(self.investorDashboardData?.my_investements ?? 0)"
            cell.partiesPercentage = [1.0,0.0]
            return cell
        case .DashboardSubmittedProductsCell:
            let cell = tableView.dequeueCell(with: DashboardSubmittedProductsCell.self, indexPath: indexPath)
            cell.setupDescriptionForProducts()
            cell.partiesPercentage = [self.campaignerDashboardData?.product?.pending ?? 0,self.campaignerDashboardData?.product?.approved ?? 0,self.campaignerDashboardData?.product?.reject ?? 0,self.campaignerDashboardData?.product?.sold ?? 0]
            cell.submittedProductLbl.text = "Submitted Products"
            cell.submittedProductValue.textColor = #colorLiteral(red: 0.3176470588, green: 0.3450980392, blue: 0.7333333333, alpha: 1)
            cell.productImgView.image = #imageLiteral(resourceName: "icProductWithBg")
            cell.bottomStackView.isHidden = (self.campaignerDashboardData?.submited_products ?? 0 == 0)
            cell.chartStackView.isHidden = (self.campaignerDashboardData?.submited_products ?? 0 == 0)
            cell.submittedProductValue.text = "\(self.campaignerDashboardData?.submited_products ?? 0)"
            return cell
        case .DashboardSubmittedAsssetsCell:
            let cell = tableView.dequeueCell(with: DashboardSubmittedProductsCell.self, indexPath: indexPath)
            cell.setupDescriptionForAssets()
            cell.partiesPercentage = [self.campaignerDashboardData?.asset?.pending ?? 0,self.campaignerDashboardData?.asset?.approved ?? 0,self.campaignerDashboardData?.asset?.reject ?? 0,self.campaignerDashboardData?.asset?.sold ?? 0]
            cell.productImgView.image = #imageLiteral(resourceName: "icTokenizedAssetBg")
            cell.submittedProductLbl.text = "Submitted Assets"
            cell.submittedProductValue.textColor = #colorLiteral(red: 0.9568627451, green: 0.6235294118, blue: 0.03921568627, alpha: 1)
            cell.bottomStackView.isHidden = (self.campaignerDashboardData?.submited_assets ?? 0 == 0)
            cell.chartStackView.isHidden = (self.campaignerDashboardData?.submited_assets ?? 0 == 0)
            cell.submittedProductValue.text = "\(self.campaignerDashboardData?.submited_assets ?? 0)"
            return cell
        case .DashboardSellHistory:
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch cellTypes[section]  {
        case .DashboardSellHistory:
             let view  = tableView.dequeueHeaderFooter(with: DashboardSellHistroryView.self)
             return view
        default:
             return UITableViewHeaderFooterView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch cellTypes[section]  {
        case .DashboardSellHistory:
            return 155.0
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
            return isDeviceIPad ? 450.0 : 376.5
        default:
            return UITableView.automaticDimension
        }
        
    }
}

// MARK: - Sorting  Logic Implemented
//===========================
extension DashboardVC: ProductSortVCDelegate  {
    func sortingApplied(sortType: String) {
        if let cell = self.mainTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? DashboardBarChartCell{
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
            }
            self.mainTableView.reloadData()
        case Base.campaigner_dashboard.rawValue:
            self.loader.isHidden = true
            let investorDashboardEntity = dataDict as? CampaignerDashboardEntity
            if let productData = investorDashboardEntity?.data {
                self.campaignerDashboardData = productData
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
            break
        }
    }
    
    func showError(error: CustomError) {
        self.loader.isHidden = true
        ToastManager.show(title:  nullStringToEmpty(string: error.localizedDescription.trimString()), state: .error)
    }
}

