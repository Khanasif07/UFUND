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
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var btnStackView: UIView!
    @IBOutlet weak var allProductsBtn: UIButton!
    @IBOutlet weak var newProductsBtn: UIButton!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var searchViewHConst: NSLayoutConstraint!
    @IBOutlet weak var searchTxtField: UISearchBar!
    
    // MARK: - Variables
    //===========================
    var categoryTitle:  String  = ""
    var searchText: String  = ""
    var additionalModel : AdditionsModel?
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
        self.getCategoryDetailData()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func configureScrollView(){
        self.mainScrollView.contentSize = CGSize(width: 2 * UIScreen.main.bounds.width, height: 1)
        self.mainScrollView.delegate = self
        self.mainScrollView.isPagingEnabled = true
    }
    
    private func instantiateViewController() {
        //instantiate the CategoryAllProductsVC
        self.allProductsVC = CategoryAllProductsVC.instantiate(fromAppStoryboard: .Products)
        self.allProductsVC.view.frame.origin = CGPoint(x: UIScreen.main.bounds.width, y: 0)
        self.mainScrollView.frame = self.allProductsVC.view.frame
        self.mainScrollView.addSubview(self.allProductsVC.view)
        self.addChild(self.allProductsVC)
        
        //instantiate the CategoryNewProductsVC
        self.newProductsVC = CategoryNewProductsVC.instantiate(fromAppStoryboard: .Products)
        self.newProductsVC.view.frame.origin = CGPoint.zero
        self.mainScrollView.frame = self.newProductsVC.view.frame
        self.mainScrollView.addSubview(self.newProductsVC.view)
        self.addChild(self.newProductsVC)
    }
    
    private func setUpFont(){
        self.titleLbl.text = categoryTitle
        self.btnStackView.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.9176470588, blue: 0.9176470588, alpha: 0.7010701185)
        self.btnStackView.borderLineWidth = 1.5
        self.btnStackView.borderColor = #colorLiteral(red: 0.6196078431, green: 0.6196078431, blue: 0.6196078431, alpha: 0.1007089439)
    }
    
    private func getCategoryDetailData(){
        self.loader.isHidden = false
        self.presenter?.HITAPI(api: Base.investorAllProducts.rawValue, params: nil, methodType: .GET, modelClass: ProductModelEntity.self, token: true)
    }
    
    private func setUpSearchBar(){
        self.searchTxtField.delegate = self
        self.searchTxtField.searchTextField.textColor = .white
        searchViewHConst.constant = 0.0
        self.view.layoutIfNeeded()
    }
    
}

// MARK: - Api Success failure
//===========================
extension CategoriesDetailVC : PresenterOutputProtocol{
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        self.loader.isHidden = true
        if let addionalModel = dataDict as? ProductModelEntity{
            newProductsVC.newProductListing = addionalModel.data
            allProductsVC.allProductListing = addionalModel.data
        }
    }
    
    func showError(error: CustomError) {
        self.loader.isHidden = true
        ToastManager.show(title:  nullStringToEmpty(string: error.localizedDescription.trimString()), state: .error)
    }
    
}

// MARK: - Sorting  Logic Implemented
//===========================
extension CategoriesDetailVC: ProductSortVCDelegate  {
    func sortingApplied(sortType: String) {
//        switch sortType {
//        case "Sort by Latest","Sort by Oldest":
//            var orderType : ComparisonResult = .orderedAscending
//            orderType = (sortType == "Sort by Latest") ? .orderedDescending : .orderedAscending
//            if isAllProductsSelected {
//                let productsCategories = searchText.isEmpty ? productVC.productCategories :  productVC.searchProductCategories
//                let sortedProduct = productsCategories?.sorted(by: { (model1, model2) -> Bool in
//                    let date1 = model1.created_at?.toDate(dateFormat: Date.DateFormat.yyyyMMddHHmmss.rawValue)
//                    let date2 = model2.created_at?.toDate(dateFormat: Date.DateFormat.yyyyMMddHHmmss.rawValue)
//                    return date1?.compare(date2 ?? Date()) == orderType
//                })
//                if !searchText.isEmpty {
////                     newProductsVC.searchProductCategories = sortedProduct
////                     productVC.mainCollView.reloadData()
//                } else {
////                      productVC.productCategories = sortedProduct
//                }
//
//            } else{
//                 let tokenssCategories = searchText.isEmpty ? tokenVC.tokenCategories :  tokenVC.searchTokenCategories
//                let sortedToken = tokenssCategories?.sorted(by: { (model1, model2) -> Bool in
//                    let date1 = model1.created_at?.toDate(dateFormat: Date.DateFormat.yyyyMMddHHmmss.rawValue)
//                    let date2 = model2.created_at?.toDate(dateFormat: Date.DateFormat.yyyyMMddHHmmss.rawValue)
//                    return date1?.compare(date2 ?? Date()) == orderType
//                })
//                if !searchText.isEmpty {
//                    tokenVC.searchTokenCategories = sortedToken
//                    tokenVC.mainCollView.reloadData()
//                } else {
//                    tokenVC.tokenCategories = sortedToken
//                }
//
//            }
//        case "Sort by Name (A-Z)","Sort by Name (Z-A)":
//            var orderType : ComparisonResult = .orderedAscending
//            orderType = (sortType == "Sort by Name (Z-A)") ? .orderedDescending : .orderedAscending
//            if isAllProductsSelected {
//                let productsCategories = searchText.isEmpty ? productVC.productCategories :  productVC.searchProductCategories
//                let sortedProduct = productsCategories?.sorted{$0.category_name?.localizedCompare($1.category_name ?? "") == orderType}
//                if !searchText.isEmpty {
//                    productVC.searchProductCategories = sortedProduct
//                    productVC.mainCollView.reloadData()
//                } else {
//                    productVC.productCategories = sortedProduct
//                }
                
//            } else{
//                let tokenssCategories = searchText.isEmpty ? tokenVC.tokenCategories :  tokenVC.searchTokenCategories
//                let sortedToken = tokenssCategories?.sorted{$0.category_name?.localizedCompare($1.category_name ?? "") == orderType}
//                if !searchText.isEmpty {
//                    tokenVC.searchTokenCategories = sortedToken
//                    tokenVC.mainCollView.reloadData()
//                } else {
//                    tokenVC.tokenCategories = sortedToken
//                }
//            }
//        default:
//            print(sortType)
//        }
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
//        self.productVC.searchText = searchText
//        self.tokenVC.searchText = searchText
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
