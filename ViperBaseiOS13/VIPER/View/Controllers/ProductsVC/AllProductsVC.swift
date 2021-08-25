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
    
    enum  CampaignerProductType{
        case AllProduct
        case LiveProduct
        case RejectedProduct
        case SoldProduct
        case PendingProduct
        
        var titleValue:String {
            switch self {
            case .AllProduct:
                return ""
                case .LiveProduct:
                return "live"
                case .RejectedProduct:
                return "reject"
                case .PendingProduct:
                return "pending"
            default:
                return "sold"
            }
        }
    }
   
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var searchViewHConst: NSLayoutConstraint!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var mainCollView: UICollectionView!
    @IBOutlet weak var sortBtn: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var filterBtn: UIButton!
    
    // MARK: - Variables
    //===========================
    var sortType : String = ""
    var searchTask: DispatchWorkItem?
    var campaignerProductType: CampaignerProductType = .AllProduct
    var productType: ProductType = .AllProducts
    var searchText : String = ""
    var productTitle: String = "All Products"
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
    var selectedCurrency : (([AssetTokenTypeModel],Bool)) = ([],false)
    var selectedMinPrice: (CGFloat,Bool) = (0.0,false)
    var selectedMaxPrice: (CGFloat,Bool) = (0.0,false)
    var selectedInvestorStart_from : (String,Bool) = ("",false)
    var selectedInvestorStart_to : (String,Bool) = ("",false)
    var selectedInvestorClose_from : (String,Bool) = ("",false)
    var selectedInvestorClose_to : (String,Bool) = ("",false)
    var selectedInvestorMature_from : (String,Bool) = ("",false)
    var selectedInvestorMature_to : (String,Bool) = ("",false)
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
        self.collectionViewSetUp()
        self.setUpFont()
        self.setSearchBar()
        self.getProductList()
    }
    
    private func setUpFont(){
        self.titleLbl.text = productTitle
        self.sortBtn.titleLabel?.font = isDeviceIPad ? .setCustomFont(name: .semiBold, size: .x16) : .setCustomFont(name: .semiBold, size: .x12)
        self.filterBtn.titleLabel?.font = isDeviceIPad ? .setCustomFont(name: .semiBold, size: .x16) : .setCustomFont(name: .semiBold, size: .x12)
        self.titleLbl.font =  isDeviceIPad ? .setCustomFont(name: .bold, size: .x20) : .setCustomFont(name: .bold, size: .x16)
    }
    
    private func setSearchBar(){
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
    }
    
    private func collectionViewSetUp(){
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
    }
    
    //MARK:- PRDUCTS LIST API CALL
    private func getProductList(page:Int = 1,search: String = "") {
        switch (userType,false) {
        case (UserType.campaigner.rawValue,false):
            var params = ProductFilterVM.shared.paramsDictForProducts
            params[ProductCreate.keys.page] = page
            params[ProductCreate.keys.search] = search
            params[ProductCreate.keys.status]  =  campaignerProductType.titleValue
            if !self.sortType.isEmpty{
                params[ProductCreate.keys.sort_order] = sortType ==  Constants.string.sort_by_name_AZ ? "ASC" : "DESC"
                params[ProductCreate.keys.sort_by] = "product_title"
            }
            self.presenter?.HITAPI(api: Base.campaignerProductsDefault.rawValue, params: params, methodType: .GET, modelClass: ProductsModelEntity.self, token: true)
        case (UserType.investor.rawValue,false):
            var params = ProductFilterVM.shared.paramsDictForProducts
            params[ProductCreate.keys.page] = page
            params[ProductCreate.keys.search] = search
            params[ProductCreate.keys.new_products]  =   productType == .AllProducts ? 0 : 1
            if !self.sortType.isEmpty{
                params[ProductCreate.keys.sort_order] = sortType ==  Constants.string.sort_by_name_AZ ? "ASC" : "DESC"
                params[ProductCreate.keys.sort_by] = "product_title"
            }
            self.presenter?.HITAPI(api: Base.investerProductsDefault.rawValue, params: params, methodType: .GET, modelClass: ProductsModelEntity.self, token: true)
        default:
            break
        }
        self.loader.isHidden = false
    }
    
    func showFilterVC(_ vc: UIViewController, index: Int = 0) {
        let ob = ProductFilterVC.instantiate(fromAppStoryboard: .Filter)
        ob.delegate = vc as? ProductFilterVCDelegate
        ob.productType = productType
        vc.present(ob, animated: true, completion: nil)
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
        return  (self.investerProductList?.endIndex ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(with: AllProductsCollCell.self, indexPath: indexPath)
        cell.productNameLbl.text =   (self.investerProductList?[indexPath.row].product_title ?? "")
        let imgEntity =   (self.investerProductList?[indexPath.row].product_image ?? "")
        let url = URL(string: nullStringToEmpty(string: imgEntity))
        cell.productImgView.sd_setImage(with: url , placeholderImage: #imageLiteral(resourceName: "imgPlaceHolder"))
        cell.productTypeLbl.text = (self.investerProductList?[indexPath.row].category?.category_name ?? "")
        cell.priceLbl.text = "$" +  "\((self.investerProductList?[indexPath.row].total_product_value ?? 0))"
        cell.investmentPerValueLbl.text = "\(self.investerProductList?[indexPath.row].invest_profit_per ?? 0)"
        cell.liveView.isHidden =  (self.investerProductList?[indexPath.row].status == nil)
        cell.investmentLbl.text = "\(self.getProgressPercentage(productModel: (self.investerProductList?[indexPath.row])).round(to: 1))" + "%"
        cell.statusLbl.text = (self.investerProductList?[indexPath.row].product_status == 1) ? "Live" : (self.investerProductList?[indexPath.row].status == 2) ? "Closed" : "Matured"
        cell.liveView.backgroundColor = (self.investerProductList?[indexPath.row].product_status == 1) ? #colorLiteral(red: 0.1411764706, green: 0.6352941176, blue: 0.6666666667, alpha: 1) : (self.investerProductList?[indexPath.row].status == 2) ? #colorLiteral(red: 0.09019607843, green: 0.6705882353, blue: 0.3568627451, alpha: 1) : #colorLiteral(red: 0.09019607843, green: 0.6705882353, blue: 0.3568627451, alpha: 1)
        cell.statusRadioImgView.image = (self.investerProductList?[indexPath.row].product_status == 1) ? #imageLiteral(resourceName: "icRadioSelected") : (self.investerProductList?[indexPath.row].product_status == 2) ? #imageLiteral(resourceName: "radioCheckSelected") : #imageLiteral(resourceName: "radioCheckSelected")
        cell.backgroundColor = .clear
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 2), height: 45.0 * collectionView.frame.height / 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ob = ProductDetailVC.instantiate(fromAppStoryboard: .Products)
        ob.productModel =  (self.investerProductList?[indexPath.row])
        self.navigationController?.pushViewController(ob, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !isRequestinApi {
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
        var params = ProductFilterVM.shared.paramsDictForProducts
        params[ProductCreate.keys.page] = 1
        params[ProductCreate.keys.search] = searchText
        switch sortType {
        case Constants.string.sort_by_name_AZ:
            params[ProductCreate.keys.sort_order] = "ASC"
            params[ProductCreate.keys.sort_by] = "product_title"
            switch (userType,false) {
            case (UserType.campaigner.rawValue,false):
                params[ProductCreate.keys.status]  =  campaignerProductType.titleValue
                self.presenter?.HITAPI(api: Base.campaignerProductsDefault.rawValue, params: params, methodType: .GET, modelClass: ProductsModelEntity.self, token: true)
            case (UserType.investor.rawValue,false):
                params[ProductCreate.keys.new_products]  =   productType == .AllProducts ? 0 : 1
                self.presenter?.HITAPI(api: Base.investerProductsDefault.rawValue, params: params, methodType: .GET, modelClass: ProductsModelEntity.self, token: true)
            default:
                break
            }
        case  Constants.string.sort_by_latest:
            params[ProductCreate.keys.sort_order] = "ASC"
            params[ProductCreate.keys.sort_by]  = "created_at"
            switch (userType,false) {
            case (UserType.campaigner.rawValue,false):
                params[ProductCreate.keys.status]  =  campaignerProductType.titleValue
                self.presenter?.HITAPI(api: Base.campaignerProductsDefault.rawValue, params: params, methodType: .GET, modelClass: ProductsModelEntity.self, token: true)
            case (UserType.investor.rawValue,false):
                params[ProductCreate.keys.new_products]  =   productType == .AllProducts ? 0 : 1
                self.presenter?.HITAPI(api: Base.investerProductsDefault.rawValue, params: params, methodType: .GET, modelClass: ProductsModelEntity.self, token: true)
            default:
                break
            }
        case  Constants.string.sort_by_oldest:
            params[ProductCreate.keys.sort_order] = "DESC"
            params[ProductCreate.keys.sort_by]  = "created_at"
            switch (userType,false) {
            case (UserType.campaigner.rawValue,false):
                params[ProductCreate.keys.status]  =  campaignerProductType.titleValue
                self.presenter?.HITAPI(api: Base.campaignerProductsDefault.rawValue, params: params, methodType: .GET, modelClass: ProductsModelEntity.self, token: true)
            case (UserType.investor.rawValue,false):
                params[ProductCreate.keys.new_products]  =   productType == .AllProducts ? 0 : 1
                self.presenter?.HITAPI(api: Base.investerProductsDefault.rawValue, params: params, methodType: .GET, modelClass: ProductsModelEntity.self, token: true)
            default:
                break
            }
        case Constants.string.sort_by_name_ZA:
            params[ProductCreate.keys.sort_order] = "DESC"
            params[ProductCreate.keys.sort_by] = "product_title"
            switch (userType,false) {
            case (UserType.campaigner.rawValue,false):
                params[ProductCreate.keys.status]  =  campaignerProductType.titleValue
                self.presenter?.HITAPI(api: Base.campaignerProductsDefault.rawValue, params: params, methodType: .GET, modelClass: ProductsModelEntity.self, token: true)
            case (UserType.investor.rawValue,false):
                params[ProductCreate.keys.new_products]  =   productType == .AllProducts ? 0 : 1
                self.presenter?.HITAPI(api: Base.investerProductsDefault.rawValue, params: params, methodType: .GET, modelClass: ProductsModelEntity.self, token: true)
            default:
                break
            }
        default:
            print("Do Nothing")
        }
    }
}


extension AllProductsVC : PresenterOutputProtocol {
    
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        self.loader.isHidden = true
        switch api {
        case Base.campaignerProductsDefault.rawValue:
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
        case Base.investerProductsDefault.rawValue:
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
        default:
            print("Do Nothing")
        }
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
    func filterDataWithoutFilter(_ category: ([CategoryModel], Bool), _ status: ([String], Bool), _ min: (CGFloat, Bool), _ max: (CGFloat, Bool), _ start_from: (String, Bool), _ start_to: (String, Bool), _ close_from: (String, Bool), _ close_to: (String, Bool), _ maturity_from: (String, Bool), _ maturity_to: (String, Bool)) {
        ProductFilterVM.shared.selectedCategoryListing = self.selectedCategory.0
        ProductFilterVM.shared.minimumPrice = self.selectedMinPrice.0
        ProductFilterVM.shared.maximumPrice = self.selectedMaxPrice.0
        ProductFilterVM.shared.start_from = self.selectedInvestorStart_from.0
        ProductFilterVM.shared.start_to = self.selectedInvestorStart_to.0
        ProductFilterVM.shared.close_from =  self.selectedInvestorClose_from.0
        ProductFilterVM.shared.close_to = self.selectedInvestorClose_to.0
        ProductFilterVM.shared.investmentMaturity_from = self.selectedInvestorMature_from.0
        ProductFilterVM.shared.investmentMaturity_to = self.selectedInvestorMature_to.0
    }
    
    func filterApplied(_ category: ([CategoryModel], Bool), _ status: ([String], Bool), _ min: (CGFloat, Bool), _ max: (CGFloat, Bool), _ start_from: (String, Bool), _ start_to: (String, Bool), _ close_from: (String, Bool), _ close_to: (String, Bool), _ maturity_from: (String, Bool), _ maturity_to: (String, Bool)) {
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
        ProductFilterVM.shared.investmentMaturity_from = maturity_from.1 ? maturity_from.0 : ""
        ProductFilterVM.shared.investmentMaturity_to = maturity_to.1 ? maturity_to.0 : ""
        ProductFilterVM.shared.start_from = start_from.1 ? start_from.0 : ""
        ProductFilterVM.shared.start_to = start_to.1 ? start_to.0 : ""
        ProductFilterVM.shared.close_from = close_from.1 ? close_from.0 : ""
        ProductFilterVM.shared.close_to = close_to.1 ? close_to.0 : ""
        if !start_from.1{self.selectedInvestorStart_from = ("",false) }
        if !start_to.1{self.selectedInvestorStart_to = ("",false) }
        if !close_from.1{self.selectedInvestorClose_from = ("",false) }
        if !close_to.1{self.selectedInvestorClose_to = ("",false) }
        if !maturity_from.1{self.selectedInvestorMature_from = ("",false) }
        if !maturity_to.1{self.selectedInvestorMature_to = ("",false) }
        //
        var params  = ProductFilterVM.shared.paramsDictForProducts
        params[ProductCreate.keys.page] =  1
        params[ProductCreate.keys.search] = self.searchText
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
        switch (userType,false) {
        case (UserType.campaigner.rawValue,false):
            params[ProductCreate.keys.status] = campaignerProductType.titleValue
            self.presenter?.HITAPI(api: Base.campaignerProductsDefault.rawValue, params: params, methodType: .GET, modelClass: ProductsModelEntity.self, token: true)
        case (UserType.investor.rawValue,false):
             params[ProductCreate.keys.new_products] = productType == .AllProducts ? 0 : 1
             self.presenter?.HITAPI(api: Base.investerProductsDefault.rawValue, params: params, methodType: .GET, modelClass: ProductsModelEntity.self, token: true)
        default:
            break
        }
        self.loader.isHidden = false
    }
}



extension UISearchBar {
    func setIconColor(_ color: UIColor = .white) {
        for subView in self.subviews {
            for subSubView in subView.subviews {
                let view = subSubView as? UITextInputTraits
                if view != nil {
                    let textField = view as? UITextField
                    let glassIconView = textField?.leftView as? UIImageView
                    glassIconView?.image = glassIconView?.image?.withRenderingMode(.alwaysTemplate)
                    glassIconView?.tintColor = color
                    break
                }
            }
        }
    }
}

extension UISearchBar {
    func setPlaceholderColor(_ color: UIColor = .white) {
        let textField = self.value(forKey: "searchField") as? UITextField
        let placeholder = textField!.value(forKey: "placeholderLabel") as? UILabel
        placeholder?.textColor = color
    }
}
