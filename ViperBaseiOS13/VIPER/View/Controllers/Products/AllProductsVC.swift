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
    var searchTask: DispatchWorkItem?
    var productType: ProductType = .AllProducts
    var searchText : String = ""
    var productTitle: String = "All Products"
    var isSearchEnable: Bool = false
    var searchInvesterProductList : [ProductModel]? = []
    var investerProductList : [ProductModel]?{
        didSet{
            self.mainCollView.reloadData()
        }
    }
    private lazy var loader  : UIView = {
           return createActivityIndicator(self.view)
       }()
    let userType = UserDefaults.standard.value(forKey: UserDefaultsKey.key.isFromInvestor) as? String
    
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
//            self.presenter?.HITAPI(api: Base.investorAllProducts.rawValue, params: nil, methodType: .GET, modelClass: ProductModelEntity.self, token: true)
            let params : [String:Any] = ["page": page,"new_products": productType == .AllProducts ? 0 : 1,"search": search]
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
        //                ob.selectedIndex = index
        //            vc.add(childViewController: ob)
        vc.present(ob, animated: true, completion: nil)
        //        self.addChild(ob)
        //        let frame = self.view.bounds
        //        ob.view.frame = frame
        //        self.view.addSubview(ob.view)
        
        //               childViewController.didMove(toParent: self)
        //        }
    }
    
    private func searchProducts(searchValue: String){
        guard searchValue.count > 2 else {
            return }
        self.searchTask?.cancel()
        let task = DispatchWorkItem { [weak self] in
            self?.getProductList(page: 1, search: searchValue)
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
        switch sortType {
        case "Sort by Name (A-Z)":
            let params :[String:Any] = ["new_products":  productType == .AllProducts ? 0 : 1,"sort_order":"ASC","sort_by":"product_title"]
            self.presenter?.HITAPI(api: Base.investerProductsDefault.rawValue, params: params, methodType: .GET, modelClass: ProductsModelEntity.self, token: true)
        case "Sort by Name (Z-A)":
            let params :[String:Any] = ["new_products":  productType == .AllProducts ? 0 : 1,"sort_order":"DESC","sort_by":"product_title"]
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
extension AllProductsVC: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        if let text = searchBar.text,!text.byRemovingLeadingTrailingWhiteSpaces.isEmpty{
            self.searchProducts(searchValue: text)
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


// MARK: - Hotel filter Delegate methods

extension AllProductsVC: ProductFilterVCDelegate {
    func clearAllButtonTapped() {
        let params :[String:Any] = ["new_products": productType == .AllProducts ? 0 : 1]
        self.presenter?.HITAPI(api: Base.investerProductsDefault.rawValue, params: params, methodType: .GET, modelClass: ProductsModelEntity.self, token: true)
    }
    
    func filterApplied() {
        var params :[String:Any] = ["page": 1,"search": searchText]
        if ProductFilterVM.shared.selectedCategoryListing.endIndex > 0{
            let category =  ProductFilterVM.shared.selectedCategoryListing.map { (model) -> String in
                return String(model.id ?? 0)
            }.joined(separator: ",")
            params["category"] = category
        }
        if ProductFilterVM.shared.selectedCurrencyListing.endIndex > 0{
            let currency =  ProductFilterVM.shared.selectedCurrencyListing.map { (model) -> String in
                return String(model.id ?? 0)
            }.joined(separator: ",")
            params["currency"] = currency
        }
        if ProductFilterVM.shared.minimumPrice != 0{
            params["min"] = ProductFilterVM.shared.minimumPrice
        }
        if ProductFilterVM.shared.maximumPrice != 0{
            params["max"] = ProductFilterVM.shared.maximumPrice
        }
        if ProductFilterVM.shared.status.endIndex > 0{
            if ProductFilterVM.shared.status.contains(Status.All.title){
                params["new_products"] = productType == .AllProducts ? 0 : 1
                self.presenter?.HITAPI(api: Base.investerProductsDefault.rawValue, params: params, methodType: .GET, modelClass: ProductsModelEntity.self, token: true)
                return
            }
            if ProductFilterVM.shared.status.contains(Status.Live.title){
                params["status"] = Status.Live.rawValue
            }
            if ProductFilterVM.shared.status.contains(Status.Matured.title){
                params["status"] = Status.Matured.rawValue
            }
        }
        params["new_products"] = productType == .AllProducts ? 0 : 1
        self.presenter?.HITAPI(api: Base.investerProductsDefault.rawValue, params: params, methodType: .GET, modelClass: ProductsModelEntity.self, token: true)
    }
}

