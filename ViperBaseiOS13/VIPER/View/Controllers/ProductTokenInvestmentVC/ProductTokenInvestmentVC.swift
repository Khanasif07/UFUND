//
//  ProductTokenInvestmentVC.swift
//  
//
//  Created by Admin on 26/04/21.
//

import UIKit
import ObjectMapper

class ProductTokenInvestmentVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchBarHC: NSLayoutConstraint!
    @IBOutlet weak var btnContainerView: UIView!
    @IBOutlet weak var sortBtn: UIButton!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var bottomBtnView: UIView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var productBtn: UIButton!
    @IBOutlet weak var tokenBtn: UIButton!
    
    // MARK: - Variables
    //===========================
    var tokenVC : CategoryAllProductsVC!
    var productVC : CategoryAllProductsVC!
    var sortType : String = ""
    var searchText : String = ""
    var searchTask: DispatchWorkItem?
    var investmentType: MyInvestmentType = .MyProductInvestment
    var isPruductSelected = true {
        didSet {
            if isPruductSelected {
                self.productBtn.setTitleColor(.white, for: .normal)
                self.tokenBtn.setTitleColor(.darkGray, for: .normal)
                self.productBtn.backgroundColor = #colorLiteral(red: 1, green: 0.1215686275, blue: 0.1764705882, alpha: 1)
                self.tokenBtn.setBackGroundColor(color: .clear)
            } else {
                self.productBtn.setTitleColor(.darkGray, for: .normal)
                self.tokenBtn.setTitleColor(.white, for: .normal)
                self.productBtn.setBackGroundColor(color: .clear)
                self.tokenBtn.backgroundColor = #colorLiteral(red: 1, green: 0.1215686275, blue: 0.1764705882, alpha: 1)
            }
        }
    }
    lazy var loader  : UIView = {
          return createActivityIndicator(self.view)
      }()
    //Pagination For Product
    var hideLoader: Bool = false
    var nextPageAvailable = true
    var isRequestinApi = false
    var showPaginationLoader: Bool {
        return  hideLoader ? false : nextPageAvailable
    }
    var currentPage: Int = 0
    var lastPage: Int  = 0
    
    //Pagination For Token
    var hideLoaderFrToken: Bool = false
    var nextPageAvailableFrToken = true
    var isRequestinApiFrToken = false
    var showPaginationLoaderfrToken: Bool {
        return  hideLoaderFrToken ? false : nextPageAvailableFrToken
    }
    var currentPageFrToken: Int = 0
    var lastPageFrToken: Int  = 0
    // filter variable
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 0.3, animations: {
            self.searchBarHC.constant = 0.0
            self.view.layoutIfNeeded()
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bottomBtnView.addShadowToTopOrBottom(location: .top, color: UIColor.black16)
        btnContainerView.setCornerRadius(cornerR: btnContainerView.frame.height / 2.0)
        tokenBtn.setCornerRadius(cornerR: tokenBtn.frame.height / 2.0)
        productBtn.setCornerRadius(cornerR: productBtn.frame.height / 2.0)
    }
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func searchBtnAction(_ sender: UIButton) {
        searchBar.becomeFirstResponder()
        UIView.animate(withDuration: 0.3, animations: {
            self.searchBarHC.constant = 51.0
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
    
    @IBAction func myProductTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        investmentType = .MyProductInvestment
        self.mainScrollView.setContentOffset(CGPoint.zero, animated: true)
        self.view.layoutIfNeeded()
    }
    
    @IBAction func myTokenTappedAction(_ sender: UIButton) {
        self.view.endEditing(true)
        investmentType = .MyTokenInvestment
        if currentPageFrToken == 0{
            self.getProductList()
        }
        self.mainScrollView.setContentOffset(CGPoint(x: UIScreen.main.bounds.width,y: 0), animated: true)
        self.view.layoutIfNeeded()
    }
    
}

// MARK: - Extension For Functions
//===========================
extension ProductTokenInvestmentVC {
    
    private func initialSetup(){
        ProductFilterVM.shared.resetToAllFilter()
        self.configureScrollView()
        self.instantiateViewController()
        self.isPruductSelected = true
        self.searchBar.delegate = self
        self.getProductList()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func configureScrollView(){
        self.isPruductSelected = false
        self.mainScrollView.contentSize = CGSize(width: 2 * UIScreen.main.bounds.width, height: 1)
        self.mainScrollView.delegate = self
        self.mainScrollView.isPagingEnabled = true
    }
    
    private func instantiateViewController() {
        //instantiate the CategoriesProductsVC
        self.productVC = CategoryAllProductsVC.instantiate(fromAppStoryboard: .Products)
        self.productVC.isUsedForMyInvestment = true
        self.productVC.view.frame.origin = CGPoint.zero
        self.productVC.categoryType = .Products
        self.mainScrollView.frame = self.productVC.view.frame
        self.mainScrollView.addSubview(self.productVC.view)
        self.addChild(self.productVC)
        
        //instantiate the CategoriesTokenVC
        self.tokenVC = CategoryAllProductsVC.instantiate(fromAppStoryboard: .Products)
        self.tokenVC.isUsedForMyInvestment = true
        self.tokenVC.view.frame.origin = CGPoint(x: UIScreen.main.bounds.width, y: 0)
        self.mainScrollView.frame = self.tokenVC.view.frame
        self.tokenVC.categoryType = .TokenzedAssets
        self.mainScrollView.addSubview(self.tokenVC.view)
        self.addChild(self.tokenVC)
        
    }
    
    func showFilterVC(_ vc: UIViewController, index: Int = 0) {
           let ob = InvestmentFilterVC.instantiate(fromAppStoryboard: .Filter)
           ob.delegate = vc as? InvestmentFilterVCDelegate
           ob.investmentType = investmentType
           vc.present(ob, animated: true, completion: nil)
       }
    
    //MARK:- PRDUCTS LIST API CALL
    public func getProductList(page:Int = 1,loader:Bool = false,searchValue:String = "") {
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
    
    private func searchProducts(searchValue: String,page:Int = 1){
        self.searchTask?.cancel()
        let task = DispatchWorkItem { [weak self] in
            self?.getProductList(page: page, searchValue: searchValue)
        }
        self.searchTask = task
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.75, execute: task)
    }
}

//    MARK:- ScrollView delegate
//    ==========================
extension ProductTokenInvestmentVC: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.mainScrollView.contentOffset.x <= self.mainScrollView.frame.width / 2 {
            isPruductSelected = true
        }
        else {
            isPruductSelected = false
        }
    }
}

//    MARK:- PresenterOutputProtocol delegate
//    ==========================
extension ProductTokenInvestmentVC : PresenterOutputProtocol {
    
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        self.loader.isHidden = true
        switch api {
        case Base.myProductInvestment.rawValue:
            let productModelEntity = dataDict as? ProductsModelEntity
            self.currentPage = productModelEntity?.data?.current_page ?? 0
            self.lastPage = productModelEntity?.data?.last_page ?? 0
            isRequestinApi = false
            nextPageAvailable = self.lastPage > self.currentPage
            if let productDict = productModelEntity?.data?.data {
                if self.currentPage == 1 {
                    self.productVC.allProductListing = productDict
                } else {
                    self.productVC.allProductListing?.append(contentsOf: productDict)
                }
            }
            self.currentPage += 1
        case Base.myTokenInvestment.rawValue:
            let productModelEntity = dataDict as? ProductsModelEntity
            self.currentPageFrToken = productModelEntity?.data?.current_page ?? 0
            self.lastPageFrToken = productModelEntity?.data?.last_page ?? 0
            isRequestinApiFrToken = false
            nextPageAvailable = self.lastPageFrToken > self.currentPageFrToken
            if let productDict = productModelEntity?.data?.data {
                if self.currentPageFrToken == 1 {
                    self.tokenVC.allProductListing = productDict
                } else {
                    self.tokenVC.allProductListing?.append(contentsOf: productDict)
                }
            }
            self.currentPageFrToken += 1
        default:
            print("Nothing")
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
 

// MARK:- PresenterOutputProtocol delegate
// ==========================
extension ProductTokenInvestmentVC : ProductSortVCDelegate {
      func sortingApplied(sortType: String) {
          self.sortType = sortType
          var params = ProductFilterVM.shared.paramsDictForProducts
          params[ProductCreate.keys.page] = 1
          params[ProductCreate.keys.search] = searchText
          switch sortType {
          case Constants.string.sort_by_name_AZ:
              params[ProductCreate.keys.sort_order] = "ASC"
              params[ProductCreate.keys.sort_by] = "product_title"
          case  Constants.string.sort_by_latest:
              params[ProductCreate.keys.sort_order] = "ASC"
              params[ProductCreate.keys.sort_by]  = "created_at"
          case  Constants.string.sort_by_oldest:
              params[ProductCreate.keys.sort_order] = "DESC"
              params[ProductCreate.keys.sort_by]  = "created_at"
          case Constants.string.sort_by_name_ZA:
              params[ProductCreate.keys.sort_order] = "DESC"
              params[ProductCreate.keys.sort_by] = "product_title"
          default:
              print("Do Nothing")
          }
        switch (userType,false,investmentType) {
        case (UserType.investor.rawValue,false,.MyProductInvestment):
            self.presenter?.HITAPI(api: Base.myProductInvestment.rawValue, params: params, methodType: .GET, modelClass: ProductsModelEntity.self, token: true)
        case (UserType.investor.rawValue,false,.MyTokenInvestment):
            self.presenter?.HITAPI(api: Base.myTokenInvestment.rawValue, params: params, methodType: .GET, modelClass: ProductsModelEntity.self, token: true)
        default:
            break
        }
      }
  }


//MARK:- UISearchBarDelegate
//========================================
extension ProductTokenInvestmentVC: UISearchBarDelegate{
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
                self.searchBarHC.constant = 51.0
                self.view.layoutIfNeeded()
            })
        }else{
            UIView.animate(withDuration: 0.3, animations: {
                self.searchBarHC.constant = 0
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
                self.searchBarHC.constant = 51.0
                self.view.layoutIfNeeded()
            })
        }else{
            UIView.animate(withDuration: 0.3, animations: {
                self.searchBarHC.constant = 0
                self.view.layoutIfNeeded()
            })
        }
        searchBar.resignFirstResponder()
    }
}


// MARK: - Product InvestmentFilterVCDelegate  methods
extension ProductTokenInvestmentVC: InvestmentFilterVCDelegate {
    
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
        self.loader.isHidden = false
        if investmentType == .MyProductInvestment {
            self.presenter?.HITAPI(api: Base.myProductInvestment.rawValue, params: params, methodType: .GET, modelClass: ProductsModelEntity.self, token: true)
        } else {
            self.presenter?.HITAPI(api: Base.myTokenInvestment.rawValue, params: params, methodType: .GET, modelClass: ProductsModelEntity.self, token: true)
        }
    }
}
