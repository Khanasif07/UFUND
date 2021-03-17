//
//  CategoryTokensDetailVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 09/03/21.
//  Copyright © 2021 CSS. All rights reserved.
//
import UIKit
import ObjectMapper

class CategoryTokensDetailVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var btnStackView: UIView!
    @IBOutlet weak var allTokensBtn: UIButton!
    @IBOutlet weak var newTokensBtn: UIButton!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var searchViewHConst: NSLayoutConstraint!
    @IBOutlet weak var searchTxtField: UISearchBar!
    
    // MARK: - Variables
    //===========================
    var searchTask: DispatchWorkItem?
    var productType: TokenizedAssetsType = .NewAssets
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
                self.allTokensBtn.setTitleColor(.white, for: .normal)
                self.newTokensBtn.setTitleColor(.darkGray, for: .normal)
                self.allTokensBtn.backgroundColor = #colorLiteral(red: 1, green: 0.1215686275, blue: 0.1764705882, alpha: 1)
                self.newTokensBtn.setBackGroundColor(color: .clear)
            } else {
                self.allTokensBtn.setTitleColor(.darkGray, for: .normal)
                self.newTokensBtn.setTitleColor(.white, for: .normal)
                self.allTokensBtn.setBackGroundColor(color: .clear)
                self.newTokensBtn.backgroundColor = #colorLiteral(red: 1, green: 0.1215686275, blue: 0.1764705882, alpha: 1)
            }
        }
    }
    var selectedTypes : (([String],Bool)) = ([],false)
    var selectedByRewards: (([String],Bool)) = ([],false)
    var selectedMinPrice: (CGFloat,Bool) = (0.0,false)
    var selectedMaxPrice: (CGFloat,Bool) = (0.0,false)
    var selectedStart_from : (String,Bool) = ("",false)
    var selectedStart_to : (String,Bool) = ("",false)
    var selectedClose_from : (String,Bool) = ("",false)
    var selectedClose_to : (String,Bool) = ("",false)
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bottomView.addShadowToTopOrBottom(location: .top, color: UIColor.black16)
        btnStackView.setCornerRadius(cornerR: btnStackView.frame.height / 2.0)
        newTokensBtn.setCornerRadius(cornerR: newTokensBtn.frame.height / 2.0)
        allTokensBtn.setCornerRadius(cornerR: allTokensBtn.frame.height / 2.0)
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
        let ob = AssetsFilterVC.instantiate(fromAppStoryboard: .Filter)
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
extension CategoryTokensDetailVC {
    
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
        self.newProductsVC.categoryType = .TokenzedAssets
        self.addChild(self.newProductsVC)
        
        //instantiate the CategoryAllProductsVC
        self.allProductsVC = CategoryAllProductsVC.instantiate(fromAppStoryboard: .Products)
        self.allProductsVC.view.frame.origin = CGPoint(x: UIScreen.main.bounds.width, y: 0)
        self.mainScrollView.frame = self.allProductsVC.view.frame
        self.mainScrollView.addSubview(self.allProductsVC.view)
        self.allProductsVC.categoryModel = categoryModel
        self.allProductsVC.categoryType = .TokenzedAssets
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
    
    private func getNewProductsData(page: Int = 1, search: String){
        self.loader.isHidden = false
        self.productType = .NewAssets
        var params :[String:Any] = [ProductCreate.keys.category: "\(categoryModel?.id ?? 0)",ProductCreate.keys.type: productType == .AllAssets ? 0 : 1,ProductCreate.keys.search: search]
        if !self.sortType.isEmpty{
            params[ProductCreate.keys.sort_order] =  (sortType == Constants.string.sort_by_name_AZ) ? "ASC" : "DESC"
            params[ProductCreate.keys.sort_by] = "product_title"
        }
        self.presenter?.HITAPI(api: Base.tokenized_asset.rawValue, params: params, methodType: .GET, modelClass: ProductsModelEntity.self, token: true)
    }
    
    private func getAllProductsData(){
        self.productType = .AllAssets
        var params :[String:Any] = [ProductCreate.keys.category: "\(categoryModel?.id ?? 0)",ProductCreate.keys.type: productType == .AllAssets ? 0 : 1,ProductCreate.keys.search: searchText]
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
        self.presenter?.HITAPI(api: Base.tokenized_asset.rawValue, params: params, methodType: .GET, modelClass: ProductsModelEntity.self, token: true)
    }
    
    private func searchProducts(searchValue: String,page:Int = 1){
        self.searchTask?.cancel()
        let task = DispatchWorkItem { [weak self] in
            self?.getNewProductsData(page: page, search: searchValue)
        }
        self.searchTask = task
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.75, execute: task)
    }
    
    private  func getApiData(){
        self.getNewProductsData(search: searchText)
    }
    
}

// MARK: - Sorting  Logic Implemented
//===========================
extension CategoryTokensDetailVC: ProductSortVCDelegate  {
    func sortingApplied(sortType: String) {
        self.sortType = sortType
        switch sortType {
        case Constants.string.sort_by_name_AZ:
            self.loader.isHidden = false
            self.productType = .NewAssets
            let params :[String:Any] = [ProductCreate.keys.category: "\(categoryModel?.id ?? 0)",ProductCreate.keys.new_products:  productType == .AllAssets ? 0 : 1,ProductCreate.keys.sort_order:"ASC",ProductCreate.keys.sort_by:"product_title"]
            self.presenter?.HITAPI(api: Base.tokenized_asset.rawValue, params: params, methodType: .GET, modelClass: ProductsModelEntity.self, token: true)
        case Constants.string.sort_by_name_ZA:
            self.loader.isHidden = false
            self.productType = .NewAssets
            let params :[String:Any] = [ProductCreate.keys.category: "\(categoryModel?.id ?? 0)",ProductCreate.keys.new_products:  productType == .AllAssets ? 0 : 1,ProductCreate.keys.sort_order:"DESC",ProductCreate.keys.sort_by:"product_title"]
            self.presenter?.HITAPI(api: Base.tokenized_asset.rawValue, params: params, methodType: .GET, modelClass: ProductsModelEntity.self, token: true)
        default:
            print("Noting")
        }
    }
}


//    MARK:- ScrollView delegate
//    ==========================
extension CategoryTokensDetailVC: UIScrollViewDelegate{
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
extension CategoryTokensDetailVC: UISearchBarDelegate{
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
extension CategoryTokensDetailVC : PresenterOutputProtocol{
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        self.loader.isHidden = true
        let productModelEntity = dataDict as? ProductsModelEntity
        if self.productType == .NewAssets {
            if let productDict = productModelEntity?.data?.data {
                newProductsVC.newProductListing = productDict
                self.getAllProductsData()
            }
        }
        if self.productType == .AllAssets {
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

extension CategoryTokensDetailVC: AssetsFilterVCDelegate {
    
    func filterDataWithoutFilter(_ category: ([CategoryModel], Bool), _ types: ([String], Bool), _ byRewards: ([String], Bool), _ min: (CGFloat, Bool), _ max: (CGFloat, Bool), _ start_from: (String, Bool), _ start_to: (String, Bool), _ close_from: (String, Bool), _ close_to: (String, Bool)) {
        ProductFilterVM.shared.types = self.selectedTypes.0
        ProductFilterVM.shared.byRewards = self.selectedByRewards.0
        ProductFilterVM.shared.minimumPrice = self.selectedMinPrice.0
        ProductFilterVM.shared.maximumPrice = self.selectedMaxPrice.0
        ProductFilterVM.shared.start_from = self.selectedStart_from.0
        ProductFilterVM.shared.start_to = self.selectedStart_to.0
        ProductFilterVM.shared.close_from = self.selectedClose_from.0
        ProductFilterVM.shared.close_to = self.selectedClose_to.0
    }
    
    func filterApplied(_ category: ([CategoryModel], Bool), _ types: ([String], Bool), _ byRewards: ([String], Bool), _ min: (CGFloat, Bool), _ max: (CGFloat, Bool), _ start_from: (String, Bool), _ start_to: (String, Bool), _ close_from: (String, Bool), _ close_to: (String, Bool)) {
        self.loader.isHidden = false
        //
        if types.1 {
            ProductFilterVM.shared.types = types.0
            self.selectedTypes = types
        }else{
            ProductFilterVM.shared.types = []
            self.selectedTypes = ([],false)
        }
        if byRewards.1 {
            ProductFilterVM.shared.byRewards = byRewards.0
            self.selectedByRewards = byRewards
        } else {
            ProductFilterVM.shared.byRewards = []
            self.selectedByRewards = ([],false)
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
        ProductFilterVM.shared.start_from = start_from.1 ? start_from.0 : ""
        ProductFilterVM.shared.start_to = start_to.1 ? start_to.0 : ""
        ProductFilterVM.shared.close_from = close_from.1 ? close_from.0 : ""
        ProductFilterVM.shared.close_to = close_to.1 ? close_to.0 : ""
        if !start_from.1{self.selectedStart_from = ("",false) }
        if !start_to.1{self.selectedStart_to = ("",false) }
        if !close_from.1{self.selectedClose_from = ("",false) }
        if !close_to.1{self.selectedClose_to = ("",false) }
        //
        self.productType = .NewAssets
        var params :[String:Any] = [ProductCreate.keys.page: 1,ProductCreate.keys.search: searchText]
        if ProductFilterVM.shared.selectedCategoryListing.endIndex > 0{
            let category =  ProductFilterVM.shared.selectedCategoryListing.map { (model) -> String in
                return String(model.id ?? 0)
            }.joined(separator: ",")
            params[ProductCreate.keys.category] = category
        }
        if ProductFilterVM.shared.minimumPrice != 0{
            params[ProductCreate.keys.min] = ProductFilterVM.shared.minimumPrice
        }
        if ProductFilterVM.shared.maximumPrice != 0{
            params[ProductCreate.keys.max] = ProductFilterVM.shared.maximumPrice
        }
        if ProductFilterVM.shared.types.endIndex > 0{
            if ProductFilterVM.shared.types.contains(AssetsType.All.title){
            }
            else if ProductFilterVM.shared.types.contains(AssetsType.Token.title){
                params[ProductCreate.keys.token_type] = AssetsType.Token.rawValue
            }
            else if ProductFilterVM.shared.types.contains(AssetsType.Assets.title){
                params[ProductCreate.keys.token_type] = AssetsType.Assets.rawValue
            }
        }
        if ProductFilterVM.shared.byRewards.endIndex > 0{
            if !ProductFilterVM.shared.types.contains(AssetsByReward.All.title){
                let byRewards =  ProductFilterVM.shared.byRewards.map { (model) -> String in
                    return model
                }.joined(separator: ",")
                params[ProductCreate.keys.reward_by] = byRewards
            }
        }
        if !ProductFilterVM.shared.start_from.isEmpty{ params[ProductCreate.keys.start_from] = ProductFilterVM.shared.start_from }
        if !ProductFilterVM.shared.start_to.isEmpty{ params[ProductCreate.keys.start_to] = ProductFilterVM.shared.start_to }
        if !ProductFilterVM.shared.close_from.isEmpty{ params[ProductCreate.keys.close_from] = ProductFilterVM.shared.close_from }
        if !ProductFilterVM.shared.close_to.isEmpty{ params[ProductCreate.keys.close_to] = ProductFilterVM.shared.close_to }
        params[ProductCreate.keys.type] = productType == .AllAssets ? 0 : 1
        self.presenter?.HITAPI(api: Base.tokenized_asset.rawValue, params: params, methodType: .GET, modelClass: ProductsModelEntity.self, token: true)
    }
}

