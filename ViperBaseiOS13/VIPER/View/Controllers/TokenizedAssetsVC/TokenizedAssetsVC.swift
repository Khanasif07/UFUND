//
//  TokenizedAssetsVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 24/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit
import ObjectMapper
import DZNEmptyDataSet

enum TokenizedAssetsType: String {
    case AllAssets
    case NewAssets
}



class TokenizedAssetsVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var searchViewHConst: NSLayoutConstraint!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var mainCollView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    // MARK: - Variables
    //===========================
    var sortType: String  = ""
    var searchTask: DispatchWorkItem?
    var productType: TokenizedAssetsType = .AllAssets
    var searchText : String = ""
    var productTitle: String = "New Tokenized Assest"
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
    var selectedTypes : (([String],Bool)) = ([],false)
    var selectedByRewards: (([String],Bool)) = ([],false)
    var selectedMinPrice: (CGFloat,Bool) = (0.0,false)
    var selectedMaxPrice: (CGFloat,Bool) = (0.0,false)
    var selectedStart_from : (String,Bool) = ("",false)
    var selectedStart_to : (String,Bool) = ("",false)
    var selectedClose_from : (String,Bool) = ("",false)
    var selectedClose_to : (String,Bool) = ("",false)
    
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
        vc.sortArray = [("Sort by Name (A-Z)",false),("Sort by Name (Z-A)",false)]
        vc.sortTypeApplied = self.sortType
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func filterBtnAction(_ sender: UIButton) {
        self.showFilterVC(self)
    }
}

// MARK: - Extension For Functions
//===========================
extension TokenizedAssetsVC {
    
    private func initialSetup(){
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
        self.getTokenizedAssets()
    }
    
    //MARK:- PRDUCTS LIST API CALL
    private func getTokenizedAssets(page:Int = 1,search: String = "") {
        let params : [String:Any] = ["search": search]
        switch (userType,true) {
        case (UserType.investor.rawValue,true):
            self.presenter?.HITAPI(api: Base.tokenized_asset.rawValue, params: params, methodType: .GET, modelClass: ProductsModelEntity.self, token: true)
        default:
            break
        }
        self.loader.isHidden = false
    }
    
    func showFilterVC(_ vc: UIViewController, index: Int = 0) {
        let ob = AssetsFilterVC.instantiate(fromAppStoryboard: .Filter)
        ob.delegate = vc as? AssetsFilterVCDelegate
        vc.present(ob, animated: true, completion: nil)
    }
    
    private func searchTokenizedAssets(searchValue: String){
        self.searchTask?.cancel()
        let task = DispatchWorkItem { [weak self] in
            self?.getTokenizedAssets(page: 1, search: searchValue)
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
extension TokenizedAssetsVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.investerProductList?.endIndex ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(with: AllProductsCollCell.self, indexPath: indexPath)
        cell.productNameLbl.text =   (self.investerProductList?[indexPath.row].tokenname ?? "")
        let imgEntity =   (self.investerProductList?[indexPath.row].token_image ?? "")
        let url = URL(string: baseUrl + "/" +  nullStringToEmpty(string: imgEntity))
        cell.productImgView.sd_setImage(with: url , placeholderImage: nil)
        cell.productTypeLbl.text =  (self.investerProductList?[indexPath.row].tokenrequest?.asset?.category?.category_name ?? "")
        cell.priceLbl.text = "$" + ( "\((self.investerProductList?[indexPath.row].tokenvalue ?? 0))")
        cell.liveView.isHidden =  (self.investerProductList?[indexPath.row].status != 1)
        cell.investmentLbl.text = "\(self.getProgressPercentage(productModel: (self.investerProductList?[indexPath.row])).round(to: 1))" + "%"
        cell.backgroundColor = .clear
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 2), height: 35 * collectionView.frame.height / 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ob = AssetsDetailVC.instantiate(fromAppStoryboard: .Products)
        ob.productModel =  (self.investerProductList?[indexPath.row])
        self.navigationController?.pushViewController(ob, animated: true)
    }
}


//MARK:- Tableview Empty dataset delegates
//========================================
extension TokenizedAssetsVC : DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
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
extension TokenizedAssetsVC: ProductSortVCDelegate  {
    func sortingApplied(sortType: String) {
        self.sortType = sortType
        switch sortType {
        case "Sort by Name (A-Z)":
            let params :[String:Any] = ["new_products":  productType == .AllAssets ? 0 : 1,"sort_order":"ASC","sort_by":"product_title"]
            self.presenter?.HITAPI(api: Base.tokenized_asset.rawValue, params: params, methodType: .GET, modelClass: ProductsModelEntity.self, token: true)
        case "Sort by Name (Z-A)":
            let params :[String:Any] = ["new_products":  productType == .AllAssets ? 0 : 1,"sort_order":"DESC","sort_by":"product_title"]
            self.presenter?.HITAPI(api: Base.tokenized_asset.rawValue, params: params, methodType: .GET, modelClass: ProductsModelEntity.self, token: true)
        default:
            print("Noting")
        }
    }
}


extension TokenizedAssetsVC : PresenterOutputProtocol {
    
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        self.loader.isHidden = true
        let productModelEntity = dataDict as? ProductsModelEntity
        if let productDict = productModelEntity?.data?.data {
            self.investerProductList = productDict
            print(investerProductList ?? [])
        }
    }
    
    func showError(error: CustomError) {
        self.loader.isHidden = true
        ToastManager.show(title:  nullStringToEmpty(string: error.localizedDescription.trimString()), state: .success)
        
    }
    
}


//MARK:- UISearchBarDelegate
//========================================
extension TokenizedAssetsVC: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        self.searchTokenizedAssets(searchValue: searchText)
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
        self.searchTokenizedAssets(searchValue: "")
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

extension TokenizedAssetsVC: AssetsFilterVCDelegate {
    func filterApplied(_ category: ([CategoryModel], Bool), _ types: ([String], Bool), _ byRewards: ([String], Bool), _ min: (CGFloat, Bool), _ max: (CGFloat, Bool),_ start_from: (String, Bool), _ start_to: (String, Bool), _ close_from: (String, Bool), _ close_to: (String, Bool)) {
        //
        if category.1 {
            ProductFilterVM.shared.selectedCategoryListing = category.0
            self.selectedCategory = category
        }else {
            ProductFilterVM.shared.selectedCategoryListing = []
            self.selectedCategory = ([],false)
        }
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
    
    func filterDataWithoutFilter(_ category: ([CategoryModel], Bool), _ types: ([String], Bool), _ byRewards: ([String], Bool), _ min: (CGFloat, Bool), _ max: (CGFloat, Bool),_ start_from: (String, Bool), _ start_to: (String, Bool), _ close_from: (String, Bool), _ close_to: (String, Bool)) {
        ProductFilterVM.shared.selectedCategoryListing = self.selectedCategory.0
        ProductFilterVM.shared.types = self.selectedTypes.0
        ProductFilterVM.shared.byRewards = self.selectedByRewards.0
        ProductFilterVM.shared.minimumPrice = self.selectedMinPrice.0
        ProductFilterVM.shared.maximumPrice = self.selectedMaxPrice.0
        ProductFilterVM.shared.start_from = self.selectedStart_from.0
        ProductFilterVM.shared.start_to = self.selectedStart_to.0
        ProductFilterVM.shared.close_from = self.selectedClose_from.0
        ProductFilterVM.shared.close_to = self.selectedClose_to.0
    }
    
}

