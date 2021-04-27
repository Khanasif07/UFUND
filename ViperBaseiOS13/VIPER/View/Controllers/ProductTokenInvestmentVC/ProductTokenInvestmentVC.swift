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
    let userType = UserDefaults.standard.value(forKey: UserDefaultsKey.key.isFromInvestor) as? String
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
        self.productVC.view.frame.origin = CGPoint.zero
        self.productVC.categoryType = .Products
        self.mainScrollView.frame = self.productVC.view.frame
        self.mainScrollView.addSubview(self.productVC.view)
        self.addChild(self.productVC)
        
        //instantiate the CategoriesTokenVC
        self.tokenVC = CategoryAllProductsVC.instantiate(fromAppStoryboard: .Products)
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

