//
//  CategoriesDetailVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 15/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//
import UIKit
import ObjectMapper

class CategoriesDetailVC: UIViewController {
    
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
            vc.sortArray = [("Sort by Name (A-Z)",false),("Sort by Name (Z-A)",false)]
            vc.sortTypeApplied = self.sortType
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
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
extension CategoriesDetailVC {
    
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
        self.newProductsVC.productType = .NewProducts
        self.addChild(self.newProductsVC)
        
        //instantiate the CategoryAllProductsVC
        self.allProductsVC = CategoryAllProductsVC.instantiate(fromAppStoryboard: .Products)
        self.allProductsVC.view.frame.origin = CGPoint(x: UIScreen.main.bounds.width, y: 0)
        self.mainScrollView.frame = self.allProductsVC.view.frame
        self.mainScrollView.addSubview(self.allProductsVC.view)
        self.allProductsVC.categoryModel = categoryModel
        self.allProductsVC.productType = .AllProducts
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
    
    private func getNewProductsData(){
        self.loader.isHidden = false
        self.productType = .NewProducts
        var params :[String:Any] = ["category": "\(categoryModel?.id ?? 0)","new_products": 1]
        if !self.sortType.isEmpty{
            params["sort_order"] =  (sortType == "Sort by Name (A-Z)") ? "ASC" : "DESC"
            params["sort_by"] = "product_title"
        }
        self.presenter?.HITAPI(api: Base.investerProductsDefault.rawValue, params: params, methodType: .GET, modelClass: ProductsModelEntity.self, token: true)
    }
    
    private func getAllProductsData(){
        self.productType = .AllProducts
        var params :[String:Any] = ["category": "\(categoryModel?.id ?? 0)","new_products":  0]
        if !self.sortType.isEmpty{
            params["sort_order"] = (sortType == "Sort by Name (A-Z)") ? "ASC" : "DESC"
            params["sort_by"] = "product_title"
        }
        self.presenter?.HITAPI(api: Base.investerProductsDefault.rawValue, params: params, methodType: .GET, modelClass: ProductsModelEntity.self, token: true)
    }
    
   private  func getApiData(){
        self.getNewProductsData()
    }
    
}

// MARK: - Sorting  Logic Implemented
//===========================
extension CategoriesDetailVC: ProductSortVCDelegate  {
    func sortingApplied(sortType: String) {
        self.sortType = sortType
        switch sortType {
        case "Sort by Name (A-Z)":
            self.loader.isHidden = false
            self.productType = .NewProducts
            let params :[String:Any] = ["category": "\(categoryModel?.id ?? 0)","new_products":  productType == .AllProducts ? 0 : 1,"sort_order":"ASC","sort_by":"product_title"]
            self.presenter?.HITAPI(api: Base.investerProductsDefault.rawValue, params: params, methodType: .GET, modelClass: ProductsModelEntity.self, token: true)
        case "Sort by Name (Z-A)":
            self.loader.isHidden = false
            self.productType = .NewProducts
            let params :[String:Any] = ["category": "\(categoryModel?.id ?? 0)","new_products":  productType == .AllProducts ? 0 : 1,"sort_order":"DESC","sort_by":"product_title"]
            self.presenter?.HITAPI(api: Base.investerProductsDefault.rawValue, params: params, methodType: .GET, modelClass: ProductsModelEntity.self, token: true)
        default:
            print("Noting")
        }
    }
}


//    MARK:- ScrollView delegate
//    ==========================
extension CategoriesDetailVC: UIScrollViewDelegate{
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
extension CategoriesDetailVC: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
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
extension CategoriesDetailVC : PresenterOutputProtocol{
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
