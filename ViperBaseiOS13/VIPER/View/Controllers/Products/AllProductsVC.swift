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

class AllProductsVC: UIViewController {
    enum ProductType: String {
        case AllProducts
        case NewProducts
    }
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var searchViewHConst: NSLayoutConstraint!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var mainCollView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Variables
    //===========================
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
        // Do any additional setup after loading the view.
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 0.3, animations: {
            self.searchViewHConst.constant = 0.0
            self.view.layoutIfNeeded()
        })
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
    private func getProductList() {
        switch (userType,false) {
        case (UserType.campaigner.rawValue,false):
            self.presenter?.HITAPI(api: Base.myProductList.rawValue, params: nil, methodType: .GET, modelClass: ProductModel.self, token: true)
        case (UserType.investor.rawValue,false):
            self.presenter?.HITAPI(api: Base.investorAllProducts.rawValue, params: nil, methodType: .GET, modelClass: ProductModelEntity.self, token: true)
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
        cell.priceLbl.text = isSearchEnable ? "\((self.searchInvesterProductList?[indexPath.row].total_product_value ?? 0))" : "\((self.investerProductList?[indexPath.row].total_product_value ?? 0))"
        cell.backgroundColor = .clear
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 2), height: 35 * collectionView.frame.height / 100)
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
        print(sortType)
    }
}


extension AllProductsVC : PresenterOutputProtocol {
    
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        self.loader.isHidden = true
        let productModelEntity = dataDict as? ProductModelEntity
        self.investerProductList = productModelEntity?.data ?? []
        print(investerProductList)
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
        ProductFilterVM.shared.isSortingApplied = false
//        UserInfo.hotelFilter = nil
//        ProductFilterVM.shared.resetToDefault()
    }
    
    func doneButtonTapped() {
//        if let isUse = UserDefaults.getObject(forKey: "shouldApplyFormStars") as? Bool, isUse {
////            UserInfo.hotelFilterApplied = UserInfo.hotelFilter
//        }
        
        
        if ProductFilterVM.shared.isFilterApplied {
//            ProductFilterVM.shared.saveDataToUserDefaults()
        }
//        printDebug("done button tapped")
    }
}

