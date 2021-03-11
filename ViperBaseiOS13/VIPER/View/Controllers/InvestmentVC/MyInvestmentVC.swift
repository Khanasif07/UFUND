//
//  MyInvestmentVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 10/03/21.
//  Copyright © 2021 CSS. All rights reserved.
//
import UIKit
import ObjectMapper
import DZNEmptyDataSet

enum MyInvestmentType: String {
    case MyProductInvestment
    case MyTokenInvestment
}
class MyInvestmentVC: UIViewController {
   
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var searchViewHConst: NSLayoutConstraint!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var mainCollView: UICollectionView!
    
    // MARK: - Variables
    //===========================
    var sortType : String = ""
    var searchTask: DispatchWorkItem?
    var investmentType: MyInvestmentType = .MyProductInvestment
    var searchText : String = ""
    var productTitle: String = ""
    var isSearchEnable: Bool = false
    var searchInvesterProductList : [ProductModel]?
    var investerProductList : [ProductModel]?{
        didSet{
            self.mainCollView.reloadData()
        }
    }
    private lazy var loader  : UIView = {
           return createActivityIndicator(self.view)
       }()
    let userType = UserDefaults.standard.value(forKey: UserDefaultsKey.key.isFromInvestor) as? String
    var selectedCategory : (([CategoryModel],Bool)) = ([],false)
    var selectedInvestorStart_from : (String,Bool) = ("",false)
    var selectedInvestorStart_to : (String,Bool) = ("",false)
    var selectedInvestorClose_from : (String,Bool) = ("",false)
    var selectedInvestorClose_to : (String,Bool) = ("",false)
    var selectedInvestorMature_from : (String,Bool) = ("",false)
    var selectedInvestorMature_to : (String,Bool) = ("",false)
    var selectedInvestorYield_from : (CGFloat,Bool) = (0.0,false)
    var selectedInvestorYield_to : (CGFloat,Bool) = (0.0,false)
    var selectedMinPrice: (CGFloat,Bool) = (0.0,false)
    var selectedMaxPrice: (CGFloat,Bool) = (0.0,false)
    var selectedMinimumEarning : (CGFloat,Bool) = (0.0,false)
    var selectedMaximumEarning : (CGFloat,Bool) = (0.0,false)
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bottomView.addShadowToTopOrBottom(location: .top,color: UIColor.black16)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 0.3, animations: {
            self.searchViewHConst.constant = 0.0
            self.view.layoutIfNeeded()
        })
    }
    
    deinit {
        ProductFilterVM.shared.resetToAllFilter()
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.popOrDismiss(animation: true)
    }
    
    @IBAction func sortBtnAction(_ sender: UIButton) {
        guard let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.ProductSortVC) as? ProductSortVC else { return }
        vc.delegate = self
        vc.sortArray = [(Constants.string.sort_by_name_AZ,false),(Constants.string.sort_by_name_ZA,false)]
        vc.sortTypeApplied = self.sortType
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func filterBtnAction(_ sender: UIButton) {
        self.showFilterVC(self)
    }
}

// MARK: - Extension For Functions
//===========================
extension MyInvestmentVC {
    private func initialSetup(){
        ProductFilterVM.shared.resetToAllFilter()
        self.titleLbl.text = productTitle
        self.mainCollView.registerCell(with: AllProductsCollCell.self)
        self.mainCollView.delegate = self
        self.mainCollView.dataSource = self
        self.mainCollView.emptyDataSetDelegate = self
        self.mainCollView.emptyDataSetSource = self
        let layout1 = UICollectionViewFlowLayout()
        layout1.scrollDirection = .vertical
        mainCollView.collectionViewLayout = layout1
        layout1.minimumInteritemSpacing = 0
        layout1.minimumLineSpacing = 0
        self.getProductList()
    }
    
    //MARK:- PRDUCTS LIST API CALL
    private func getProductList(page:Int = 1,search: String = "",loader:Bool = false) {
        switch (userType,false) {
        case (UserType.investor.rawValue,false):
            let params : [String:Any] = [ProductCreate.keys.page: page,ProductCreate.keys.new_products: investmentType == .MyTokenInvestment ? 0 : 1,ProductCreate.keys.search: search]
             self.presenter?.HITAPI(api: Base.myInvestment.rawValue, params: params, methodType: .GET, modelClass: ProductsModelEntity.self, token: true)
        default:
            break
        }
        self.loader.isHidden = loader
    }
    
    func showFilterVC(_ vc: UIViewController, index: Int = 0) {
        let ob = InvestmentFilterVC.instantiate(fromAppStoryboard: .Filter)
        ob.delegate = vc as? InvestmentFilterVCDelegate
        vc.present(ob, animated: true, completion: nil)
    }
    
    private func searchProducts(searchValue: String,page:Int = 1,loader: Bool = false){
        self.searchTask?.cancel()
        let task = DispatchWorkItem { [weak self] in
            self?.getProductList(page: page, search: searchValue,loader: loader)
        }
        self.searchTask = task
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.75, execute: task)
    }
    
    private func getProgressPercentage(productModel: ProductModel?) -> Double{
        let investValue =   (productModel?.investment_product_total ?? 0.0 )
        let totalValue =  (productModel?.total_product_value ?? 0.0)
        return (investValue / totalValue) * 100
    }
}

//MARK: - Collection view delegate
extension MyInvestmentVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
   
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isSearchEnable ?   (self.searchInvesterProductList?.endIndex ?? 0)   : (self.investerProductList?.endIndex ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(with: AllProductsCollCell.self, indexPath: indexPath)
        cell.productNameLbl.text =  isSearchEnable ? (self.searchInvesterProductList?[indexPath.row].product_title ?? "") : (self.investerProductList?[indexPath.row].product_title ?? "")
        let imgEntity =  isSearchEnable ? (self.searchInvesterProductList?[indexPath.row].product_image ?? "") : (self.investerProductList?[indexPath.row].product_image ?? "")
        let url = URL(string: baseUrl + "/" +  nullStringToEmpty(string: imgEntity))
        cell.productImgView.sd_setImage(with: url , placeholderImage: nil)
        cell.productTypeLbl.text = isSearchEnable ? (self.searchInvesterProductList?[indexPath.row].category?.category_name ?? "") : (self.investerProductList?[indexPath.row].category?.category_name ?? "")
        cell.priceLbl.text = "$" + (isSearchEnable ? "\((self.searchInvesterProductList?[indexPath.row].total_product_value ?? 0))" : "\((self.investerProductList?[indexPath.row].total_product_value ?? 0))")
        cell.liveView.isHidden = isSearchEnable ?   (self.searchInvesterProductList?[indexPath.row].status != 1)   : (self.investerProductList?[indexPath.row].status != 1)
        cell.investmentLbl.text = "\(self.getProgressPercentage(productModel: isSearchEnable ?   (self.searchInvesterProductList?[indexPath.row])   : (self.investerProductList?[indexPath.row])).round(to: 1))" + "%"
        cell.backgroundColor = .clear
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 2), height: 35 * collectionView.frame.height / 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ob = MyInvestmentsDetailVC.instantiate(fromAppStoryboard: .Products)
        ob.productModel = isSearchEnable ?   (self.searchInvesterProductList?[indexPath.row])   : (self.investerProductList?[indexPath.row])
        ob.investmentType = investmentType
        self.navigationController?.pushViewController(ob, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if true {
            guard nextPageAvailable, !isRequestinApi else { return }
        } else {
            guard !isRequestinApi else { return }
        }
        isRequestinApi = true
        self.searchProducts(searchValue: self.searchText,page: self.currentPage,loader: true)
    }
}


//MARK:- Tableview Empty dataset delegates
//========================================
extension MyInvestmentVC : DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
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


// MARK: - Sorting  Logic Implemented
//===========================
extension MyInvestmentVC: ProductSortVCDelegate  {
    func sortingApplied(sortType: String) {
        self.sortType = sortType
        switch sortType {
        case Constants.string.sort_by_name_AZ:
            let params :[String:Any] = [ProductCreate.keys.new_products:  investmentType == .MyTokenInvestment ? 0 : 1,ProductCreate.keys.sort_order:"ASC",ProductCreate.keys.sort_by:"product_title",ProductCreate.keys.search: self.searchText,ProductCreate.keys.page: 1]
            self.presenter?.HITAPI(api: Base.myInvestment.rawValue, params: params, methodType: .GET, modelClass: ProductsModelEntity.self, token: true)
        case Constants.string.sort_by_name_ZA:
            let params :[String:Any] = [ProductCreate.keys.new_products:  investmentType == .MyTokenInvestment ? 0 : 1,ProductCreate.keys.sort_order:"DESC",ProductCreate.keys.sort_by:"product_title",ProductCreate.keys.search: self.searchText,ProductCreate.keys.page: 1]
            self.presenter?.HITAPI(api: Base.myInvestment.rawValue, params: params, methodType: .GET, modelClass: ProductsModelEntity.self, token: true)
        default:
            print("Noting")
        }
    }
}


extension MyInvestmentVC : PresenterOutputProtocol {
    
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        self.loader.isHidden = true
        let productModelEntity = dataDict as? ProductsModelEntity
        self.currentPage = productModelEntity?.data?.current_page ?? 0
        self.lastPage = productModelEntity?.data?.last_page ?? 0
        isRequestinApi = false
        nextPageAvailable = self.lastPage > self.currentPage
        if let productDict = productModelEntity?.data?.data {
            if self.currentPage == 1 {
                self.investerProductList = productDict
            } else {
                self.investerProductList?.append(contentsOf: productDict)
            }
        }
        self.currentPage += 1
    }
    
    func showSuccessWithParams(statusCode:Int,params: [String : Any], api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        print(api)
        print(statusCode)
    }
    
    func showError(error: CustomError) {
        self.loader.isHidden = true
        ToastManager.show(title:  nullStringToEmpty(string: error.localizedDescription.trimString()), state: .success)
        
    }
 
}

// MARK: - Hotel filter Delegate methods

extension MyInvestmentVC: InvestmentFilterVCDelegate {
    func filterDataWithoutFilter(_ category: ([CategoryModel], Bool), _ start_from: (String, Bool), _ start_to: (String, Bool), _ min: (CGFloat, Bool), _ max: (CGFloat, Bool), _ close_from: (String, Bool), _ close_to: (String, Bool), _ maturity_from: (String, Bool), _ maturity_to: (String, Bool),_ min_earning: (CGFloat, Bool), _ max_earning: (CGFloat, Bool)) {
        ProductFilterVM.shared.selectedCategoryListing = self.selectedCategory.0
        ProductFilterVM.shared.minimumPrice = self.selectedMinPrice.0
        ProductFilterVM.shared.maximumPrice = self.selectedMaxPrice.0
        ProductFilterVM.shared.investmentStart_from = self.selectedInvestorStart_from.0
        ProductFilterVM.shared.investmentStart_to = self.selectedInvestorStart_to.0
        ProductFilterVM.shared.investmentClose_from =  self.selectedInvestorClose_from.0
        ProductFilterVM.shared.investmentClose_to = self.selectedInvestorClose_to.0
        ProductFilterVM.shared.investmentMaturity_from = self.selectedInvestorMature_from.0
        ProductFilterVM.shared.investmentMaturity_to = self.selectedInvestorMature_to.0
        ProductFilterVM.shared.minimumEarning = self.selectedMinimumEarning.0
        ProductFilterVM.shared.maximumEarning = self.selectedMaximumEarning.0
        ProductFilterVM.shared.minimumYield = self.selectedInvestorYield_from.0
        ProductFilterVM.shared.maximumYield = self.selectedInvestorYield_to.0
    }
    
    func filterApplied(_ category: ([CategoryModel], Bool), _ start_from: (String, Bool), _ start_to: (String, Bool), _ min: (CGFloat, Bool), _ max: (CGFloat, Bool), _ close_from: (String, Bool), _ close_to: (String, Bool), _ maturity_from: (String, Bool), _ maturity_to: (String, Bool),_ min_earning: (CGFloat, Bool), _ max_earning: (CGFloat, Bool)) {
        //
        if category.1 {
            ProductFilterVM.shared.selectedCategoryListing = category.0
            self.selectedCategory = category
        }else {
            ProductFilterVM.shared.selectedCategoryListing = []
            self.selectedCategory = ([],false)
        }
        if min.1 {
            ProductFilterVM.shared.minimumPrice = min.0
            self.selectedMinPrice = min
        } else {
            ProductFilterVM.shared.minimumPrice = 0.0
            self.selectedMinPrice = (0.0,false)
        }
        if max.1 {
            ProductFilterVM.shared.maximumPrice = max.0
            self.selectedMaxPrice = max
        } else {
            ProductFilterVM.shared.maximumPrice = 0.0
            self.selectedMaxPrice = (0.0,false)
        }
        if min_earning.1 {
            ProductFilterVM.shared.minimumEarning = min_earning.0
            self.selectedMinimumEarning = min_earning
        } else {
            ProductFilterVM.shared.minimumEarning = 0.0
            self.selectedMinimumEarning = (0.0,false)
        }
        if max_earning.1 {
            ProductFilterVM.shared.maximumEarning = max_earning.0
            self.selectedMaximumEarning = max_earning
        } else {
            ProductFilterVM.shared.maximumEarning = 0.0
            self.selectedMaximumEarning = (0.0,false)
        }
        ProductFilterVM.shared.investmentMaturity_from = maturity_from.1 ? maturity_from.0 : ""
        ProductFilterVM.shared.investmentMaturity_to = maturity_to.1 ? maturity_to.0 : ""
        ProductFilterVM.shared.investmentStart_from = start_from.1 ? start_from.0 : ""
        ProductFilterVM.shared.investmentStart_to = start_to.1 ? start_to.0 : ""
        ProductFilterVM.shared.investmentClose_from = close_from.1 ? close_from.0 : ""
        ProductFilterVM.shared.investmentClose_to = close_to.1 ? close_to.0 : ""
        if !start_from.1{self.selectedInvestorStart_from = ("",false) }
        if !start_to.1{self.selectedInvestorStart_to = ("",false) }
        if !close_from.1{self.selectedInvestorClose_from = ("",false) }
        if !close_to.1{self.selectedInvestorClose_to = ("",false) }
        if !maturity_from.1{self.selectedInvestorMature_from = ("",false) }
        if !maturity_to.1{self.selectedInvestorMature_to = ("",false) }
        //
        var params :[String:Any] = ProductFilterVM.shared.paramsDictForInvestment
        params[ProductCreate.keys.page] = 1
        params[ProductCreate.keys.new_products] = investmentType == .MyTokenInvestment ? 0 : 1
        self.presenter?.HITAPI(api: Base.myInvestment.rawValue, params: params, methodType: .GET, modelClass: ProductsModelEntity.self, token: true)
    }
}

