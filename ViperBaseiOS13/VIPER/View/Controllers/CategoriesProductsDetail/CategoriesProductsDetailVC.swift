//
//  CategoriesDetailVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 15/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//
import UIKit
import ObjectMapper

class CategoriesProductsDetailVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var btnStackView: UIView!
    @IBOutlet weak var allProductsBtn: UIButton!
    @IBOutlet weak var newProductsBtn: UIButton!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var searchViewHConst: NSLayoutConstraint!
    @IBOutlet weak var searchTxtField: UISearchBar!
    
    // MARK: - Variables
    //===========================
    var searchTask: DispatchWorkItem?
    var productType: ProductType = .NewProducts
    var categoryTitle:  String  = ""
    var sortType : String = ""
    var searchText: String  = ""
    var categoryModel : CategoryModel?
    var newProductsVC : CategoryNewProductsVC!
    var allProductsVC : CategoryAllProductsVC!
    lazy var loader  : UIView = {
        return createActivityIndicator(self.view)
    }()
    var isAllProductsSelected = true {
        didSet {
            if isAllProductsSelected {
                self.allProductsBtn.setTitleColor(.white, for: .normal)
                self.newProductsBtn.setTitleColor(.darkGray, for: .normal)
                self.allProductsBtn.backgroundColor = #colorLiteral(red: 1, green: 0.1215686275, blue: 0.1764705882, alpha: 1)
                self.newProductsBtn.setBackGroundColor(color: .clear)
            } else {
                self.allProductsBtn.setTitleColor(.darkGray, for: .normal)
                self.newProductsBtn.setTitleColor(.white, for: .normal)
                self.allProductsBtn.setBackGroundColor(color: .clear)
                self.newProductsBtn.backgroundColor = #colorLiteral(red: 1, green: 0.1215686275, blue: 0.1764705882, alpha: 1)
            }
        }
    }
    var selectedCurrency : (([CurrencyModel],Bool)) = ([],false)
    var selectedStatus: (([String],Bool)) = ([],false)
    var selectedMinPrice: (CGFloat,Bool) = (0.0,false)
    var selectedMaxPrice: (CGFloat,Bool) = (0.0,false)
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bottomView.addShadowToTopOrBottom(location: .top, color: UIColor.black16)
        btnStackView.setCornerRadius(cornerR: btnStackView.frame.height / 2.0)
        newProductsBtn.setCornerRadius(cornerR: newProductsBtn.frame.height / 2.0)
        allProductsBtn.setCornerRadius(cornerR: allProductsBtn.frame.height / 2.0)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        ProductFilterVM.shared.resetToAllFilter()
        super.viewDidLoad()
        self.initialSetup()
    }
    
    // MARK: - IBActions
    //===========================
     @IBAction func newProductBtnTapped(_ sender: UIButton) {
            self.view.endEditing(true)
            self.mainScrollView.setContentOffset(CGPoint.zero, animated: true)
            self.view.layoutIfNeeded()
        }
        
        @IBAction func allProductBtnTapped(_ sender: Any) {
            self.view.endEditing(true)
            self.mainScrollView.setContentOffset(CGPoint(x: UIScreen.main.bounds.width,y: 0), animated: true)
            self.view.layoutIfNeeded()
        }
    
        @IBAction func backBtnTapped(_ sender: UIButton) {
            self.popOrDismiss(animation: true)
        }
        
        @IBAction func sortBtnAction(_ sender: UIButton) {
            guard let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.ProductSortVC) as? ProductSortVC else { return }
            vc.sortArray = [(Constants.string.sort_by_name_AZ,false),(Constants.string.sort_by_name_ZA,false)]
            vc.sortTypeApplied = self.sortType
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        }
    
    @IBAction func filterBtnAction(_ sender: UIButton) {
        let ob = ProductFilterVC.instantiate(fromAppStoryboard: .Filter)
        ob.isFilterWithoutCategory = true
        ob.delegate = self
        self.present(ob, animated: true, completion: nil)
    }
    
        
    @IBAction func searchBtnAction(_ sender: UIButton) {
        searchTxtField.becomeFirstResponder()
        UIView.animate(withDuration: 0.3, animations: {
            self.searchViewHConst.constant = 51.0
            self.view.layoutIfNeeded()
        })
    }
}


// MARK: - Extension For Function
//=========================
extension CategoriesProductsDetailVC {
    
    private func initialSetup(){
        self.setUpFont()
        self.setUpSearchBar()
        self.configureScrollView()
        self.instantiateViewController()
        self.isAllProductsSelected = false
        self.navigationController?.navigationBar.isHidden = true
        self.getApiData()
    }
    
    private func configureScrollView(){
        self.mainScrollView.contentSize = CGSize(width: 2 * UIScreen.main.bounds.width, height: 1)
        self.mainScrollView.delegate = self
        self.mainScrollView.isPagingEnabled = true
    }
    
    private func instantiateViewController() {
        //instantiate the CategoryNewProductsVC
        self.newProductsVC = CategoryNewProductsVC.instantiate(fromAppStoryboard: .Products)
        self.newProductsVC.view.frame.origin = CGPoint.zero
        self.mainScrollView.frame = self.newProductsVC.view.frame
        self.mainScrollView.addSubview(self.newProductsVC.view)
        self.newProductsVC.categoryModel = categoryModel
        self.newProductsVC.categoryModelId = categoryModel?.id ?? 0
        self.newProductsVC.categoryType = .Products
        self.addChild(self.newProductsVC)
        
        //instantiate the CategoryAllProductsVC
        self.allProductsVC = CategoryAllProductsVC.instantiate(fromAppStoryboard: .Products)
        self.allProductsVC.view.frame.origin = CGPoint(x: UIScreen.main.bounds.width, y: 0)
        self.mainScrollView.frame = self.allProductsVC.view.frame
        self.mainScrollView.addSubview(self.allProductsVC.view)
        self.allProductsVC.categoryModel = categoryModel
        self.allProductsVC.categoryType = .Products
        self.addChild(self.allProductsVC)
    }
    
    private func setUpFont(){
        self.titleLbl.text = categoryTitle
        self.btnStackView.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.9176470588, blue: 0.9176470588, alpha: 0.7010701185)
        self.btnStackView.borderLineWidth = 1.5
        self.btnStackView.borderColor = #colorLiteral(red: 0.6196078431, green: 0.6196078431, blue: 0.6196078431, alpha: 0.1007089439)
    }
    
    private func setUpSearchBar(){
        self.searchTxtField.delegate = self
        self.searchTxtField.searchTextField.textColor = .white
        searchViewHConst.constant = 0.0
        self.view.layoutIfNeeded()
    }
    
    private func getNewProductsData(page:Int = 1,search: String){
        self.loader.isHidden = false
        self.productType = .NewProducts
        var params :[String:Any] = [ProductCreate.keys.category: "\(categoryModel?.id ?? 0)",ProductCreate.keys.new_products: 1,ProductCreate.keys.search: search]
        if !self.sortType.isEmpty{
            params[ProductCreate.keys.sort_order] =  (sortType == Constants.string.sort_by_name_AZ) ? "ASC" : "DESC"
            params[ProductCreate.keys.sort_by] = "product_title"
        }
        self.presenter?.HITAPI(api: Base.investerProductsDefault.rawValue, params: params, methodType: .GET, modelClass: ProductsModelEntity.self, token: true)
    }
    
    private func getAllProductsData(){
        self.productType = .AllProducts
        var params :[String:Any] = [ProductCreate.keys.category: "\(categoryModel?.id ?? 0)",ProductCreate.keys.new_products:  0,ProductCreate.keys.search: searchText]
        if !self.sortType.isEmpty{
            params[ProductCreate.keys.sort_order] = (sortType == Constants.string.sort_by_name_AZ) ? "ASC" : "DESC"
            params[ProductCreate.keys.sort_by] = "product_title"
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
    
   private  func getApiData(){
    self.getNewProductsData(search: searchText)
    }
    
    private func searchProducts(searchValue: String,page:Int = 1){
        self.searchTask?.cancel()
        let task = DispatchWorkItem { [weak self] in
            self?.getNewProductsData(page: page, search: searchValue)
        }
        self.searchTask = task
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.75, execute: task)
    }
       
    
}

// MARK: - Sorting  Logic Implemented
//===========================
extension CategoriesProductsDetailVC: ProductSortVCDelegate  {
    func sortingApplied(sortType: String) {
        self.sortType = sortType
        switch sortType {
        case Constants.string.sort_by_name_AZ:
            self.loader.isHidden = false
            self.productType = .NewProducts
            let params :[String:Any] = [ProductCreate.keys.category: "\(categoryModel?.id ?? 0)",ProductCreate.keys.new_products:  productType == .AllProducts ? 0 : 1,ProductCreate.keys.sort_order:"ASC",ProductCreate.keys.sort_by:"product_title"]
            self.presenter?.HITAPI(api: Base.investerProductsDefault.rawValue, params: params, methodType: .GET, modelClass: ProductsModelEntity.self, token: true)
        case Constants.string.sort_by_name_ZA:
            self.loader.isHidden = false
            self.productType = .NewProducts
            let params :[String:Any] = [ProductCreate.keys.category: "\(categoryModel?.id ?? 0)",ProductCreate.keys.new_products:  productType == .AllProducts ? 0 : 1,ProductCreate.keys.sort_order:"DESC",ProductCreate.keys.sort_by:"product_title"]
            self.presenter?.HITAPI(api: Base.investerProductsDefault.rawValue, params: params, methodType: .GET, modelClass: ProductsModelEntity.self, token: true)
        default:
            print("Noting")
        }
    }
}


//    MARK:- ScrollView delegate
//    ==========================
extension CategoriesProductsDetailVC: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.mainScrollView.contentOffset.x <= UIScreen.main.bounds.width / 2 {
            isAllProductsSelected = false
        }
        else {
            isAllProductsSelected = true
        }
    }
}


//MARK:- UISearchBarDelegate
//========================================
extension CategoriesProductsDetailVC: UISearchBarDelegate{
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


// MARK: - Api Success failure
//===========================
extension CategoriesProductsDetailVC : PresenterOutputProtocol{
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        self.loader.isHidden = true
        let productModelEntity = dataDict as? ProductsModelEntity
        if self.productType == .NewProducts {
            if let productDict = productModelEntity?.data?.data {
               newProductsVC.newProductListing = productDict
                self.getAllProductsData()
            }
        }
        if self.productType == .AllProducts {
            if let productDict = productModelEntity?.data?.data {
                allProductsVC.allProductListing = productDict
            }
        }
    }

    func showError(error: CustomError) {
        self.loader.isHidden = true
        ToastManager.show(title:  nullStringToEmpty(string: error.localizedDescription.trimString()), state: .error)
    }
}

// MARK: - Hotel filter Delegate methods

extension CategoriesProductsDetailVC: ProductFilterVCDelegate {
    func filterDataWithoutFilter(_ category: ([CategoryModel], Bool), _ currency: ([CurrencyModel], Bool), _ status: ([String], Bool), _ min: (CGFloat, Bool), _ max: (CGFloat, Bool)) {
        ProductFilterVM.shared.status = self.selectedStatus.0
        ProductFilterVM.shared.minimumPrice = self.selectedMinPrice.0
        ProductFilterVM.shared.maximumPrice = self.selectedMaxPrice.0
    }
    
    func filterApplied(_ category: ([CategoryModel], Bool), _ currency: ([CurrencyModel], Bool), _ status: ([String], Bool), _ min: (CGFloat, Bool), _ max: (CGFloat, Bool)) {
        self.loader.isHidden = false
        //
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
        self.productType = .NewProducts
        var params :[String:Any] = [ProductCreate.keys.page: 1,ProductCreate.keys.search: searchText,ProductCreate.keys.category: "\(categoryModel?.id ?? 0)"]
        if !self.sortType.isEmpty{
            params[ProductCreate.keys.sort_order] =  (sortType == Constants.string.sort_by_name_AZ) ? "ASC" : "DESC"
            params[ProductCreate.keys.sort_by] = "product_title"
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

