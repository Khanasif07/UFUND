//
//  AllProductsVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 15/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit
import ObjectMapper
import DZNEmptyDataSet

enum ProductType: String {
    case AllProducts
    case NewProducts
}

enum CategoryType: String{
    case Products
    case TokenzedAssets
}
   
   

class AllProductsVC: UIViewController {
   
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var searchViewHConst: NSLayoutConstraint!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var mainCollView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Variables
    //===========================
    var sortType : String = ""
    var searchTask: DispatchWorkItem?
    var productType: ProductType = .AllProducts
    var searchText : String = ""
    var productTitle: String = "All Products"
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
    var selectedCurrency : (([CurrencyModel],Bool)) = ([],false)
    var selectedStatus: (([String],Bool)) = ([],false)
    var selectedMinPrice: (CGFloat,Bool) = (0.0,false)
    var selectedMaxPrice: (CGFloat,Bool) = (0.0,false)
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
    @IBAction func searchBtnAction(_ sender: UIButton) {
        searchBar.becomeFirstResponder()
        UIView.animate(withDuration: 0.3, animations: {
            self.searchViewHConst.constant = 51.0
            self.view.layoutIfNeeded()
        })
    }
    
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
extension AllProductsVC {
    
    private func initialSetup(){
        ProductFilterVM.shared.resetToAllFilter()
        self.searchBar.delegate = self
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
    private func getProductList(page:Int = 1,search: String = "") {
        switch (userType,false) {
        case (UserType.campaigner.rawValue,false):
            self.presenter?.HITAPI(api: Base.myProductList.rawValue, params: nil, methodType: .GET, modelClass: ProductModel.self, token: true)
        case (UserType.investor.rawValue,false):
            let params : [String:Any] = [ProductCreate.keys.page: page,ProductCreate.keys.new_products: productType == .AllProducts ? 0 : 1,ProductCreate.keys.search: search]
             self.presenter?.HITAPI(api: Base.investerProductsDefault.rawValue, params: params, methodType: .GET, modelClass: ProductsModelEntity.self, token: true)
        case (UserType.investor.rawValue,true):
            self.presenter?.HITAPI(api: Base.investerProducts.rawValue, params: nil, methodType: .GET, modelClass: ProductModel.self, token: true)
        default:
            break
        }
        self.loader.isHidden = false
    }
    
    func showFilterVC(_ vc: UIViewController, index: Int = 0) {
        //        if let _ = UIApplication.topViewController() {
        let ob = ProductFilterVC.instantiate(fromAppStoryboard: .Filter)
        ob.delegate = vc as? ProductFilterVCDelegate
        vc.present(ob, animated: true, completion: nil)
        //                ob.selectedIndex = index
        //            vc.add(childViewController: ob)
        //        self.addChild(ob)
        //        let frame = self.view.bounds
        //        ob.view.frame = frame
        //        self.view.addSubview(ob.view)
        
        //               childViewController.didMove(toParent: self)
        //        }
    }
    
    private func searchProducts(searchValue: String,page:Int = 1){
        self.searchTask?.cancel()
        let task = DispatchWorkItem { [weak self] in
            self?.getProductList(page: page, search: searchValue)
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
extension AllProductsVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
   
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
        let ob = ProductDetailVC.instantiate(fromAppStoryboard: .Products)
        ob.productModel = isSearchEnable ?   (self.searchInvesterProductList?[indexPath.row])   : (self.investerProductList?[indexPath.row])
        self.navigationController?.pushViewController(ob, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if true {
            guard nextPageAvailable, !isRequestinApi else { return }
        } else {
            guard !isRequestinApi else { return }
        }
        isRequestinApi = true
        self.searchProducts(searchValue: self.searchText,page: self.currentPage)
    }
}


//MARK:- Tableview Empty dataset delegates
//========================================
extension AllProductsVC : DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
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
extension AllProductsVC: ProductSortVCDelegate  {
    func sortingApplied(sortType: String) {
        self.sortType = sortType
        switch sortType {
        case Constants.string.sort_by_name_AZ:
            let params :[String:Any] = [ProductCreate.keys.new_products:  productType == .AllProducts ? 0 : 1,ProductCreate.keys.sort_order:"ASC",ProductCreate.keys.sort_by:"product_title",ProductCreate.keys.search: self.searchText]
            self.presenter?.HITAPI(api: Base.investerProductsDefault.rawValue, params: params, methodType: .GET, modelClass: ProductsModelEntity.self, token: true)
        case Constants.string.sort_by_name_ZA:
            let params :[String:Any] = [ProductCreate.keys.new_products:  productType == .AllProducts ? 0 : 1,ProductCreate.keys.sort_order:"DESC",ProductCreate.keys.sort_by:"product_title",ProductCreate.keys.search: self.searchText]
            self.presenter?.HITAPI(api: Base.investerProductsDefault.rawValue, params: params, methodType: .GET, modelClass: ProductsModelEntity.self, token: true)
        default:
            print("Noting")
        }
    }
}


extension AllProductsVC : PresenterOutputProtocol {
    
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


//MARK:- UISearchBarDelegate
//========================================
extension AllProductsVC: UISearchBarDelegate{
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


// MARK: - Hotel filter Delegate methods

extension AllProductsVC: ProductFilterVCDelegate {
    func filterDataWithoutFilter(_ category: ([CategoryModel], Bool), _ currency: ([CurrencyModel], Bool), _ status: ([String], Bool), _ min: (CGFloat, Bool), _ max: (CGFloat, Bool)) {
        ProductFilterVM.shared.selectedCategoryListing = self.selectedCategory.0
        ProductFilterVM.shared.selectedCurrencyListing = self.selectedCurrency.0
        ProductFilterVM.shared.status = self.selectedStatus.0
        ProductFilterVM.shared.minimumPrice = self.selectedMinPrice.0
        ProductFilterVM.shared.maximumPrice = self.selectedMaxPrice.0
    }
    
    func filterApplied(_ category: ([CategoryModel], Bool), _ currency: ([CurrencyModel], Bool), _ status: ([String], Bool), _ min: (CGFloat, Bool), _ max: (CGFloat, Bool)) {
        //
        if category.1 {
            ProductFilterVM.shared.selectedCategoryListing = category.0
            self.selectedCategory = category
        }else {
            ProductFilterVM.shared.selectedCategoryListing = []
            self.selectedCategory = ([],false)
        }
        if currency.1 {
            ProductFilterVM.shared.selectedCurrencyListing = currency.0
            self.selectedCurrency = currency
        }else{
            ProductFilterVM.shared.selectedCurrencyListing = []
            self.selectedCurrency = ([],false)
        }
        if status.1 {
            ProductFilterVM.shared.status = status.0
            self.selectedStatus = status
        } else {
            ProductFilterVM.shared.status = []
            self.selectedStatus = ([],false)
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
        //
        var params :[String:Any] = [ProductCreate.keys.page: 1,ProductCreate.keys.search: searchText]
        if ProductFilterVM.shared.selectedCategoryListing.endIndex > 0{
            let category =  ProductFilterVM.shared.selectedCategoryListing.map { (model) -> String in
                return String(model.id ?? 0)
            }.joined(separator: ",")
            params[ProductCreate.keys.category] = category
        }
        if ProductFilterVM.shared.selectedCurrencyListing.endIndex > 0{
            let currency =  ProductFilterVM.shared.selectedCurrencyListing.map { (model) -> String in
                return String(model.id ?? 0)
            }.joined(separator: ",")
            params[ProductCreate.keys.currency] = currency
        }
        if ProductFilterVM.shared.minimumPrice != 0{
            params[ProductCreate.keys.min] = ProductFilterVM.shared.minimumPrice
        }
        if ProductFilterVM.shared.maximumPrice != 0{
            params[ProductCreate.keys.max] = ProductFilterVM.shared.maximumPrice
            params[ProductCreate.keys.min] = ProductFilterVM.shared.minimumPrice
        }
        if ProductFilterVM.shared.status.endIndex > 0{
            if ProductFilterVM.shared.status.contains(Status.All.title){
            }
            if ProductFilterVM.shared.status.contains(Status.Live.title){
                params[ProductCreate.keys.status] = Status.Live.rawValue
            }
            if ProductFilterVM.shared.status.contains(Status.Matured.title){
                params[ProductCreate.keys.status] = Status.Matured.rawValue
            }
        }
        params[ProductCreate.keys.new_products] = productType == .AllProducts ? 0 : 1
        self.presenter?.HITAPI(api: Base.investerProductsDefault.rawValue, params: params, methodType: .GET, modelClass: ProductsModelEntity.self, token: true)
    }
}

