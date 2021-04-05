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
    var sortTypeForMonthly: String = Constants.string.daily
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
            self.cellTypes = [.DashboardSubmittedProductsCell,.DashboardSubmittedAsssetsCell]
            self.hitCampaignerDashboardAPI()
        }
    }
    
    private func tableViewSetUp(){
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
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
    
}

// MARK: - Extension For TableView
//===========================
extension DashboardVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellTypes.endIndex
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch cellTypes[indexPath.row] {
        case .DashboardTabsTableCell:
            let cell = tableView.dequeueCell(with: DashboardTabsTableCell.self, indexPath: indexPath)
            cell.isFromCampainer = userType == UserType.investor.rawValue ? false : true
            cell.investorDashboardData = investorDashboardData
            cell.tabsCollView.layoutIfNeeded()
            return cell
        case .DashboardBarChartCell:
            let cell = tableView.dequeueCell(with: DashboardBarChartCell.self, indexPath: indexPath)
            cell.firstBarValue = self.investorDashboardGraphData?.series?.first?.data ?? []
            cell.vertXValues = self.investorDashboardGraphData?.lable!.map { String($0) } ?? []
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
            return cell
        case .DashboardSubmittedProductsCell:
            let cell = tableView.dequeueCell(with: DashboardSubmittedProductsCell.self, indexPath: indexPath)
            cell.partiesPercentage = [self.campaignerDashboardData?.product?.pending ?? 0,self.campaignerDashboardData?.product?.approved ?? 0,self.campaignerDashboardData?.product?.reject ?? 0,self.campaignerDashboardData?.product?.sold ?? 0]
            cell.submittedProductLbl.text = "Submitted Products"
            cell.productImgView.image = #imageLiteral(resourceName: "icProductWithBg")
            cell.submittedProductValue.text = "\(self.campaignerDashboardData?.submited_products ?? 0)"
            return cell
        case .DashboardSubmittedAsssetsCell:
            let cell = tableView.dequeueCell(with: DashboardSubmittedProductsCell.self, indexPath: indexPath)
            cell.partiesPercentage = [self.campaignerDashboardData?.asset?.pending ?? 0,self.campaignerDashboardData?.asset?.approved ?? 0,self.campaignerDashboardData?.asset?.reject ?? 0,self.campaignerDashboardData?.asset?.sold ?? 0]
            cell.productImgView.image = #imageLiteral(resourceName: "icTokenizedAssetBg")
            cell.submittedProductLbl.text = "Submitted Assets"
            cell.submittedProductValue.text = "\(self.campaignerDashboardData?.submited_assets ?? 0)"
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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

