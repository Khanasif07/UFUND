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
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var searchViewHConst: NSLayoutConstraint!
    @IBOutlet weak var sortBtn: UIButton!
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
    var selectedByRewards : (([String],Bool)) = ([],false)
    var selectedAssetsListing : (([AssetTokenTypeModel],Bool)) = ([],false)
    var selectedTokenListing : (([AssetTokenTypeModel],Bool)) = ([],false)
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
        vc.sortTypeApplied = self.sortType
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func searchBtnTapped(_ sender: UIButton) {
        searchBar.becomeFirstResponder()
        UIView.animate(withDuration: 0.3, animations: {
            self.searchViewHConst.constant = 51.0
            self.view.layoutIfNeeded()
        })
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
        self.titleLbl.font =  isDeviceIPad ? .setCustomFont(name: .bold, size: .x20) : .setCustomFont(name: .bold, size: .x16)
        self.sortBtn.titleLabel?.font = isDeviceIPad ? .setCustomFont(name: .semiBold, size: .x16) : .setCustomFont(name: .semiBold, size: .x12)
        self.filterBtn.titleLabel?.font = isDeviceIPad ? .setCustomFont(name: .semiBold, size: .x16) : .setCustomFont(name: .semiBold, size: .x12)
        self.searchBar.delegate = self
        if #available(iOS 13.0, *) {
            self.searchBar.backgroundColor = #colorLiteral(red: 1, green: 0.3843137255, blue: 0.4235294118, alpha: 1)
            searchBar.tintColor = .white
            searchBar.setIconColor(.white)
            searchBar.setPlaceholderColor(.white)
            self.searchBar.searchTextField.font = .setCustomFont(name: .medium, size: isDeviceIPad ? .x18 : .x14)
            self.searchBar.searchTextField.textColor = .lightGray
        } else {
            // Fallback on earlier versions
        }
        self.collectionSetUp()
        self.getProductList()
    }
    
    private func collectionSetUp(){
        self.mainCollView.registerCell(with: AllProductsCollCell.self)
        self.mainCollView.registerCell(with: NewProductsCollCell.self)
        self.mainCollView.delegate = self
        self.mainCollView.dataSource = self
        self.mainCollView.emptyDataSetDelegate = self
        self.mainCollView.emptyDataSetSource = self
        let layout1 = UICollectionViewFlowLayout()
        layout1.scrollDirection = .vertical
        mainCollView.collectionViewLayout = layout1
        layout1.minimumInteritemSpacing = 0
        layout1.minimumLineSpacing = 0
    }
    
    //MARK:- PRDUCTS LIST API CALL
    private func getProductList(page:Int = 1,loader:Bool = false,searchValue:String = "") {
        switch (userType,false) {
        case (UserType.investor.rawValue,false):
            var params : [String:Any] =  ProductFilterVM.shared.paramsDictForInvestment
            params[ProductCreate.keys.page] =  page
            params[ProductCreate.keys.search] =  searchValue
            switch sortType {
            case Constants.string.sort_by_name_AZ:
                params[ProductCreate.keys.sort_order] = "ASC"
                params[ProductCreate.keys.sort_by] = "product_title"
            case  Constants.string.sort_by_name_ZA:
                params[ProductCreate.keys.sort_order] = "DESC"
                params[ProductCreate.keys.sort_by] = "product_title"
            case  Constants.string.sort_by_latest:
                params[ProductCreate.keys.sort_order] = "ASC"
                params[ProductCreate.keys.sort_by]  = "created_at"
            case  Constants.string.sort_by_oldest:
                params[ProductCreate.keys.sort_order] = "DESC"
                params[ProductCreate.keys.sort_by]  = "created_at"
            default:
                print("Add Nothing")
            }
            if investmentType == .MyProductInvestment {
                self.presenter?.HITAPI(api: Base.myProductInvestment.rawValue, params: params, methodType: .GET, modelClass: ProductsModelEntity.self, token: true)
            } else {
                self.presenter?.HITAPI(api: Base.myTokenInvestment.rawValue, params: params, methodType: .GET, modelClass: ProductsModelEntity.self, token: true)
            }
        default:
            break
        }
        self.loader.isHidden = loader
    }
    
    func showFilterVC(_ vc: UIViewController, index: Int = 0) {
        let ob = InvestmentFilterVC.instantiate(fromAppStoryboard: .Filter)
        ob.delegate = vc as? InvestmentFilterVCDelegate
        ob.investmentType = investmentType
        vc.present(ob, animated: true, completion: nil)
    }
    
    private func searchProducts(page:Int = 1,loader: Bool = false,searchValue: String){
        self.searchTask?.cancel()
        let task = DispatchWorkItem { [weak self] in
            self?.getProductList(page: page,loader: loader,searchValue: self?.searchText ?? "")
        }
        self.searchTask = task
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.75, execute: task)
    }
    
    private func getProgressPercentage(productModel: ProductModel?) -> Double{
//        let investValue =   (productModel?.investment_product_total ?? 0.0 )
//        let totalValue =  (productModel?.total_product_value ?? 0.0)
//        return (investValue / totalValue) * 100
        let pending_invest_per =  (productModel?.pending_invest_per ?? 0 )
        return 100.0 - Double(pending_invest_per)
        //pending_invest_per
    }
}

//MARK: - Collection view delegate
extension MyInvestmentVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
   
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  (self.investerProductList?.endIndex ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch investmentType {
        case .MyProductInvestment:
            let cell = collectionView.dequeueCell(with: AllProductsCollCell.self, indexPath: indexPath)
            cell.productNameLbl.text =  (self.investerProductList?[indexPath.row].product_title ?? "")
            let imgEntity =   (self.investerProductList?[indexPath.row].product_image ?? "")
//            let url = URL(string: baseUrl + "/" +  nullStringToEmpty(string: imgEntity))
            let url = URL(string: nullStringToEmpty(string: imgEntity))
            cell.productImgView.sd_setImage(with: url , placeholderImage: nil)
            cell.productTypeLbl.text =  (self.investerProductList?[indexPath.row].category?.category_name ?? "")
            cell.priceLbl.text = "$" +  "\((self.investerProductList?[indexPath.row].total_product_value ?? 0))"
            cell.statusLbl.text = (self.investerProductList?[indexPath.row].product_status == 1) ? "Live" : (self.investerProductList?[indexPath.row].status == 2) ? "Closed" : "Matured"
            cell.liveView.isHidden =  (self.investerProductList?[indexPath.row].status == nil)
            cell.investmentLbl.text = "\(self.getProgressPercentage(productModel: (self.investerProductList?[indexPath.row])).round(to: 1))" + "%"
            cell.liveView.backgroundColor = (self.investerProductList?[indexPath.row].product_status == 1) ? #colorLiteral(red: 0.1411764706, green: 0.6352941176, blue: 0.6666666667, alpha: 1) : (self.investerProductList?[indexPath.row].status == 2) ? #colorLiteral(red: 0.09019607843, green: 0.6705882353, blue: 0.3568627451, alpha: 1) : #colorLiteral(red: 0.09019607843, green: 0.6705882353, blue: 0.3568627451, alpha: 1)
            cell.statusRadioImgView.image = (self.investerProductList?[indexPath.row].product_status == 1) ? #imageLiteral(resourceName: "icRadioSelected") : (self.investerProductList?[indexPath.row].status == 2) ? #imageLiteral(resourceName: "radioCheckSelected") : #imageLiteral(resourceName: "radioCheckSelected")
            cell.investmentPerValueLbl.text = "\(self.investerProductList?[indexPath.row].invest_profit_per ?? 0)"
            cell.backgroundColor = .clear
            return cell
        default:
            let cell = collectionView.dequeueCell(with: NewProductsCollCell.self, indexPath: indexPath)
            cell.productNameLbl.text =   (self.investerProductList?[indexPath.row].tokenname ?? "")
            let imgEntity =   (self.investerProductList?[indexPath.row].token_image ?? "")
//            let url = URL(string: baseUrl + "/" +  nullStringToEmpty(string: imgEntity))
            let url = URL(string: nullStringToEmpty(string: imgEntity))
            cell.productImgView.sd_setImage(with: url , placeholderImage: nil)
            cell.categoryLbl.text =  (self.investerProductList?[indexPath.row].tokenrequest?.asset?.category?.category_name ?? "")
            cell.priceLbl.text = "$" + ( "\((self.investerProductList?[indexPath.row].tokenvalue ?? 0.0))")
            cell.liveView.isHidden =  (self.investerProductList?[indexPath.row].status == nil)
            cell.statusLbl.text = (self.investerProductList?[indexPath.row].token_status == 1) ? "Live" : "Live"
            cell.liveView.backgroundColor = (self.investerProductList?[indexPath.row].token_status == 1) ? #colorLiteral(red: 0.1411764706, green: 0.6352941176, blue: 0.6666666667, alpha: 1) : #colorLiteral(red: 0.09019607843, green: 0.6705882353, blue: 0.3568627451, alpha: 1)
            cell.statusRadioImgView.image = (self.investerProductList?[indexPath.row].product_status == 1) ? #imageLiteral(resourceName: "icRadioSelected") : (self.investerProductList?[indexPath.row].status == 2) ? #imageLiteral(resourceName: "icRadioSelected") : #imageLiteral(resourceName: "icRadioSelected")
            return cell
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 2), height: 35 * collectionView.frame.height / 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ob = MyInvestmentsDetailVC.instantiate(fromAppStoryboard: .Products)
        ob.productModel =  (self.investerProductList?[indexPath.row])
        ob.investmentType = investmentType
        self.navigationController?.pushViewController(ob, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !isRequestinApi {
            guard nextPageAvailable, !isRequestinApi else { return }
        } else {
            guard !isRequestinApi else { return }
        }
        isRequestinApi = true
        self.searchProducts(page: self.currentPage,loader: true, searchValue: self.searchText)
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
        var params :[String:Any] =  ProductFilterVM.shared.paramsDictForInvestment
        params[ProductCreate.keys.page] = 1
        params[ProductCreate.keys.search] = self.searchText
        self.sortType = sortType
        switch sortType {
        case Constants.string.sort_by_name_AZ:
            params[ProductCreate.keys.sort_by]  = "product_title"
            params[ProductCreate.keys.sort_order] = "ASC"
        case Constants.string.sort_by_name_ZA:
            params[ProductCreate.keys.sort_by]  = "product_title"
            params[ProductCreate.keys.sort_order] = "DESC"
        case  Constants.string.sort_by_latest:
            params[ProductCreate.keys.sort_order] = "ASC"
            params[ProductCreate.keys.sort_by]  = "created_at"
        case  Constants.string.sort_by_oldest:
            params[ProductCreate.keys.sort_order] = "DESC"
            params[ProductCreate.keys.sort_by]  = "created_at"
        default:
            print("Add nothing")
        }
        if investmentType == .MyProductInvestment {
            self.presenter?.HITAPI(api: Base.myProductInvestment.rawValue, params: params, methodType: .GET, modelClass: ProductsModelEntity.self, token: true)
        } else {
            self.presenter?.HITAPI(api: Base.myTokenInvestment.rawValue, params: params, methodType: .GET, modelClass: ProductsModelEntity.self, token: true)
        }
        self.loader.isHidden = false
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

// MARK: - Product filter Delegate methods

extension MyInvestmentVC: InvestmentFilterVCDelegate {
    
    func filterDataWithoutFilter(_ category: ([CategoryModel], Bool), _ start_from: (String, Bool), _ start_to: (String, Bool), _ min: (CGFloat, Bool), _ max: (CGFloat, Bool), _ close_from: (String, Bool), _ close_to: (String, Bool), _ maturity_from: (String, Bool), _ maturity_to: (String, Bool), _ min_earning: (CGFloat, Bool), _ max_eraning: (CGFloat, Bool), _ byRewards: ([String], Bool), _ asset_types: ([AssetTokenTypeModel], Bool), _ token_types: ([AssetTokenTypeModel], Bool)) {
        ProductFilterVM.shared.selectedCategoryListing = self.selectedCategory.0
        ProductFilterVM.shared.selectedTokenListing = self.selectedTokenListing.0
        ProductFilterVM.shared.selectedAssetsListing = self.selectedAssetsListing.0
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
        ProductFilterVM.shared.byRewards = self.selectedByRewards.0
    }
    
    func filterApplied(_ category: ([CategoryModel], Bool), _ start_from: (String, Bool), _ start_to: (String, Bool), _ min: (CGFloat, Bool), _ max: (CGFloat, Bool), _ close_from: (String, Bool), _ close_to: (String, Bool), _ maturity_from: (String, Bool), _ maturity_to: (String, Bool),_ min_earning: (CGFloat, Bool), _ max_earning: (CGFloat, Bool), _ byRewards: ([String], Bool), _ asset_types: ([AssetTokenTypeModel], Bool), _ token_types: ([AssetTokenTypeModel], Bool)) {
        //
        if category.1 {
            ProductFilterVM.shared.selectedCategoryListing = category.0
            self.selectedCategory = category
        }else {
            ProductFilterVM.shared.selectedCategoryListing = []
            self.selectedCategory = ([],false)
        }
        if asset_types.1 {
            ProductFilterVM.shared.selectedAssetsListing = asset_types.0
            self.selectedAssetsListing = asset_types
        }else{
            ProductFilterVM.shared.selectedAssetsListing = []
            self.selectedAssetsListing = ([],false)
        }
        if token_types.1 {
            ProductFilterVM.shared.selectedTokenListing = token_types.0
            self.selectedTokenListing = token_types
        }else{
            ProductFilterVM.shared.selectedTokenListing = []
            self.selectedTokenListing = ([],false)
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
        if byRewards.1 {
            ProductFilterVM.shared.byRewards = byRewards.0
            self.selectedByRewards = byRewards
        } else {
            ProductFilterVM.shared.byRewards = []
            self.selectedByRewards = ([],false)
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
        switch sortType {
        case Constants.string.sort_by_name_AZ:
            params[ProductCreate.keys.sort_order] = "ASC"
            params[ProductCreate.keys.sort_by] = "product_title"
        case  Constants.string.sort_by_name_ZA:
            params[ProductCreate.keys.sort_order] = "DESC"
            params[ProductCreate.keys.sort_by] = "product_title"
        case  Constants.string.sort_by_latest:
            params[ProductCreate.keys.sort_order] = "ASC"
            params[ProductCreate.keys.sort_by]  = "created_at"
        case  Constants.string.sort_by_oldest:
            params[ProductCreate.keys.sort_order] = "DESC"
            params[ProductCreate.keys.sort_by]  = "created_at"
        default:
            print("Add Nothing")
        }
        params[ProductCreate.keys.search] = self.searchText
        if investmentType == .MyProductInvestment {
            self.presenter?.HITAPI(api: Base.myProductInvestment.rawValue, params: params, methodType: .GET, modelClass: ProductsModelEntity.self, token: true)
        } else {
            self.presenter?.HITAPI(api: Base.myTokenInvestment.rawValue, params: params, methodType: .GET, modelClass: ProductsModelEntity.self, token: true)
        }
        self.loader.isHidden = false
    }
}


//MARK:- UISearchBarDelegate
//========================================
extension MyInvestmentVC: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        self.searchProducts(searchValue: self.searchText)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        if let text = searchBar.text,!text.byRemovingLeadingTrailingWhiteSpaces.isEmpty{
            UIView.animate(withDuration: 0.3, animations: {
                self.searchViewHConst.constant = 51.0
                self.view.layoutIfNeeded()
            })
        }else{
            UIView.animate(withDuration: 0.3, animations: {
                self.searchViewHConst.constant = 0
                self.view.layoutIfNeeded()
            })
        }
        searchBar.resignFirstResponder()
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        self.searchProducts(searchValue: "")
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        if let text = searchBar.text,!text.byRemovingLeadingTrailingWhiteSpaces.isEmpty{
            UIView.animate(withDuration: 0.3, animations: {
                self.searchViewHConst.constant = 51.0
                self.view.layoutIfNeeded()
            })
        }else{
            UIView.animate(withDuration: 0.3, animations: {
                self.searchViewHConst.constant = 0
                self.view.layoutIfNeeded()
            })
        }
        searchBar.resignFirstResponder()
    }
}


//MARK:- UISearchBar
//========================================
public extension UISearchBar {

    func setTextColor(color: UIColor) {
        let svs = subviews.flatMap { $0.subviews }
        guard let tf = (svs.filter { $0 is UITextField }).first as? UITextField else { return }
        tf.textColor = color
    }
}
