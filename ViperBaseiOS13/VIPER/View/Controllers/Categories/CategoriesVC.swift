//
//  CategoriesVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 11/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit
import ObjectMapper

class CategoriesVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var sortBtn: UIButton!
    @IBOutlet weak var btnStackView: UIView!
    @IBOutlet weak var tokenBtn: UIButton!
    @IBOutlet weak var productBtn: UIButton!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var searchViewHConst: NSLayoutConstraint!
    @IBOutlet weak var searchTxtField: UISearchBar!
    
    // MARK: - Variables
    //===========================
    var sortType : String = ""
    var searchTextForProduct: String  = ""
    var searchTextForToken : String  = ""
    var tokenVC : CategoriesTokenVC!
    var productVC : CategoriesProductsVC!
    lazy var loader  : UIView = {
                return createActivityIndicator(self.view)
    }()
    var isPruductSelected = true {
        didSet {
            if isPruductSelected {
                self.productBtn.setTitleColor(.white, for: .normal)
                self.tokenBtn.setTitleColor(.darkGray, for: .normal)
                self.productBtn.backgroundColor = #colorLiteral(red: 1, green: 0.1215686275, blue: 0.1764705882, alpha: 1)
                self.tokenBtn.setBackGroundColor(color: .clear)
                self.searchTxtField.text = searchTextForProduct
                self.searchBarSearchButtonClicked(searchTxtField)
            } else {
                self.productBtn.setTitleColor(.darkGray, for: .normal)
                self.tokenBtn.setTitleColor(.white, for: .normal)
                self.productBtn.setBackGroundColor(color: .clear)
                self.tokenBtn.backgroundColor = #colorLiteral(red: 1, green: 0.1215686275, blue: 0.1764705882, alpha: 1)
                self.searchTxtField.text = searchTextForToken
                self.searchBarSearchButtonClicked(searchTxtField)
            }
        }
    }
    
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetUp()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bottomView.addShadowToTopOrBottom(location: .top, color: UIColor.black16)
        btnStackView.setCornerRadius(cornerR: btnStackView.frame.height / 2.0)
        tokenBtn.setCornerRadius(cornerR: tokenBtn.frame.height / 2.0)
        productBtn.setCornerRadius(cornerR: productBtn.frame.height / 2.0)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
       
    
    // MARK: - IBActions
    //===========================
    
    @IBAction func productBtnTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        self.mainScrollView.setContentOffset(CGPoint.zero, animated: true)
        self.view.layoutIfNeeded()
    }
    
    @IBAction func tokenBtnTapped(_ sender: Any) {
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
        vc.sortTypeApplied = self.sortType
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

// MARK: - Extension For Functions
//===========================
extension CategoriesVC {
    
    private func initialSetUp(){
        self.setUpFont()
        self.setUpSearchBar()
        self.configureScrollView()
        self.instantiateViewController()
        self.isPruductSelected = true
        self.getCategoryList()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func configureScrollView(){
        self.mainScrollView.contentSize = CGSize(width: 2 * UIScreen.main.bounds.width, height: 1)
        self.mainScrollView.delegate = self
        self.mainScrollView.isPagingEnabled = true
    }
    
    private func instantiateViewController() {
        //instantiate the CategoriesTokenVC
        self.tokenVC = CategoriesTokenVC.instantiate(fromAppStoryboard: .Main)
        self.tokenVC.view.frame.origin = CGPoint(x: UIScreen.main.bounds.width, y: 0)
        self.mainScrollView.frame = self.tokenVC.view.frame
        self.mainScrollView.addSubview(self.tokenVC.view)
        self.addChild(self.tokenVC)
        
        //instantiate the CategoriesProductsVC
        self.productVC = CategoriesProductsVC.instantiate(fromAppStoryboard: .Main)
        self.productVC.view.frame.origin = CGPoint.zero
        self.mainScrollView.frame = self.productVC.view.frame
        self.mainScrollView.addSubview(self.productVC.view)
        self.addChild(self.productVC)
    }
    
    private func setUpFont(){
        self.titleLbl.font =  isDeviceIPad ? .setCustomFont(name: .bold, size: .x20) : .setCustomFont(name: .bold, size: .x16)
        self.btnStackView.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.9176470588, blue: 0.9176470588, alpha: 0.7010701185)
        self.btnStackView.borderLineWidth = 1.5
        self.btnStackView.borderColor = #colorLiteral(red: 0.6196078431, green: 0.6196078431, blue: 0.6196078431, alpha: 0.1007089439)
        self.sortBtn.titleLabel?.font = isDeviceIPad ? .setCustomFont(name: .semiBold, size: .x16) : .setCustomFont(name: .semiBold, size: .x12)
        self.productBtn.titleLabel?.font = isDeviceIPad ? .setCustomFont(name: .semiBold, size: .x18) : .setCustomFont(name: .semiBold, size: .x14)
        self.tokenBtn.titleLabel?.font = isDeviceIPad ? .setCustomFont(name: .semiBold, size: .x18) : .setCustomFont(name: .semiBold, size: .x14)
    }
    
    private func getCategoryList(){
        self.loader.isHidden = false
        self.presenter?.HITAPI(api: Base.category.rawValue, params: nil, methodType: .GET, modelClass: AdditionsModel.self, token: true)
    }
    
    private func setUpSearchBar(){
        if #available(iOS 13.0, *) {
            self.searchTxtField.searchTextField.font = .setCustomFont(name: .medium, size: .x14)
            self.searchTxtField.delegate = self
            self.searchTxtField.searchTextField.textColor = .white
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 13.0, *) {
            self.searchTxtField.searchTextField.textColor = .white
        } else {
            // Fallback on earlier versions
        }
        searchViewHConst.constant = 0.0
        self.view.layoutIfNeeded()
    }
}

// MARK: - Api Success failure
//===========================
extension CategoriesVC : PresenterOutputProtocol{
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
         self.loader.isHidden = true
        if let addionalModel = dataDict as? AdditionsModel{
            tokenVC.tokenCategories = addionalModel.token_categories
            productVC.productCategories = addionalModel.product_categories
        }
        
    }
    
    func showError(error: CustomError) {
        self.loader.isHidden = true
        ToastManager.show(title:  nullStringToEmpty(string: error.localizedDescription.trimString()), state: .error)
    }
    
}

// MARK: - Sorting  Logic Implemented
//===========================
extension CategoriesVC: ProductSortVCDelegate  {
    func sortingApplied(sortType: String) {
        self.sortType = sortType
        switch sortType {
        case Constants.string.sort_by_latest,Constants.string.sort_by_oldest:
            var orderType : ComparisonResult = .orderedAscending
            orderType = (sortType == Constants.string.sort_by_latest) ? .orderedDescending : .orderedAscending
            if isPruductSelected {
                let productsCategories = searchTextForProduct.isEmpty ? productVC.productCategories :  productVC.searchProductCategories
                let sortedProduct = productsCategories?.sorted(by: { (model1, model2) -> Bool in
                    let date1 = model1.created_at?.toDate(dateFormat: Date.DateFormat.yyyyMMddHHmmss.rawValue)
                    let date2 = model2.created_at?.toDate(dateFormat: Date.DateFormat.yyyyMMddHHmmss.rawValue)
                    return date1?.compare(date2 ?? Date()) == orderType
                })
                if !searchTextForProduct.isEmpty {
                     productVC.searchProductCategories = sortedProduct
                     productVC.mainCollView.reloadData()
                } else {
                      productVC.productCategories = sortedProduct
                }
              
            } else{
                let tokenssCategories = searchTextForToken.isEmpty ? tokenVC.tokenCategories :  tokenVC.searchTokenCategories
                let sortedToken = tokenssCategories?.sorted(by: { (model1, model2) -> Bool in
                    let date1 = model1.created_at?.toDate(dateFormat: Date.DateFormat.yyyyMMddHHmmss.rawValue)
                    let date2 = model2.created_at?.toDate(dateFormat: Date.DateFormat.yyyyMMddHHmmss.rawValue)
                    return date1?.compare(date2 ?? Date()) == orderType
                })
                if !searchTextForToken.isEmpty {
                    tokenVC.searchTokenCategories = sortedToken
                    tokenVC.mainCollView.reloadData()
                } else {
                    tokenVC.tokenCategories = sortedToken
                }
                
            }
        case Constants.string.sort_by_name_AZ,Constants.string.sort_by_name_ZA:
            var orderType : ComparisonResult = .orderedAscending
            orderType = (sortType == Constants.string.sort_by_name_ZA) ? .orderedDescending : .orderedAscending
                        if isPruductSelected {
            let productsCategories = searchTextForProduct.isEmpty ? productVC.productCategories :  productVC.searchProductCategories
            let sortedProduct = productsCategories?.sorted{$0.category_name?.localizedCompare($1.category_name ?? "") == orderType}
            if !searchTextForProduct.isEmpty {
                productVC.searchProductCategories = sortedProduct
                productVC.mainCollView.reloadData()
            } else {
                productVC.productCategories = sortedProduct
            }
            
                        } else{
            let tokenssCategories = searchTextForToken.isEmpty ? tokenVC.tokenCategories :  tokenVC.searchTokenCategories
            let sortedToken = tokenssCategories?.sorted{$0.category_name?.localizedCompare($1.category_name ?? "") == orderType}
            if !searchTextForToken.isEmpty {
                tokenVC.searchTokenCategories = sortedToken
                tokenVC.mainCollView.reloadData()
            } else {
                tokenVC.tokenCategories = sortedToken
            }
            }
        default:
            print(sortType)
        }
    }
}


//    MARK:- ScrollView delegate
//    ==========================
extension CategoriesVC: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.mainScrollView.contentOffset.x <= UIScreen.main.bounds.width / 2 {
            isPruductSelected = true
        }
        else {
            isPruductSelected = false
        }
    }
}


//MARK:- UISearchBarDelegate
//========================================
extension CategoriesVC: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if isPruductSelected {
                self.searchTextForProduct = searchText
                self.productVC.searchText = searchText
        } else {
                self.searchTextForToken = searchText
                self.tokenVC.searchText = searchText
        }
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
