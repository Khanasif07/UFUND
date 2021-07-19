//
//  MyYieldVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 01/06/21.
//  Copyright © 2021 CSS. All rights reserved.
//


import UIKit
import DZNEmptyDataSet
import ObjectMapper

class MyYieldVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
//    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mainCollectionView: UICollectionView!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    
    // MARK: - Variables
    //===========================
    private lazy var loader  : UIView = {
            return createActivityIndicator(self.view)
        }()
    let userType = UserDefaults.standard.value(forKey: UserDefaultsKey.key.isFromInvestor) as? String
    var menuContent = [(Constants.string.myProfile.localize(),[]),(Constants.string.categories.localize(),[]),(Constants.string.Products.localize(),[]),(Constants.string.TokenizedAssets.localize(),[]),(Constants.string.allMyInvestment.localize(),[]),(Constants.string.wallet.localize(),[]),(Constants.string.changePassword.localize(),[]),(Constants.string.logout.localize(),[])]
    var sections = [("Overall User Earning",true),("Earning In Crypto",false),("Earning In Fiat",false)]
    var searchText = ""
    var selectedCategory : (([CategoryModel],Bool)) = ([],false)
    var selectedInvestorStart_from : (String,Bool) = ("",false)
    var selectedInvestorStart_to : (String,Bool) = ("",false)
    var selectedInvestorMature_from : (String,Bool) = ("",false)
    var selectedInvestorMature_to : (String,Bool) = ("",false)
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func backBtnAction(_ sender: Any) {
        self.popOrDismiss(animation: true)
    }
    
    @IBAction func filterBtnAction(_ sender: UIButton) {
        let filterVC = MyYieldFilterVC.instantiate(fromAppStoryboard: .Filter)
        filterVC.modalPresentationStyle = .overCurrentContext
        self.present(filterVC, animated: true, completion: nil)
    }
    
}

// MARK: - Extension For Functions
//===========================
extension MyYieldVC {
    
    private func initialSetup() {
        self.setUpFont()
//        self.setSearchBar()
        self.collectionSetUp()
        self.tableSetUp()
        self.hitYieldWalletBalanceAPI()
        self.hitYieldBuyInvestAPI()
    }
    
    private func setUpFont(){
        self.titleLbl.font =  isDeviceIPad ? .setCustomFont(name: .bold, size: .x20) : .setCustomFont(name: .bold, size: .x16)
    }
    
//    private func setSearchBar(){
//        self.searchBar.delegate = self
//        if #available(iOS 13.0, *) {
//            self.searchBar.backgroundColor = #colorLiteral(red: 1, green: 0.3843137255, blue: 0.4235294118, alpha: 1)
//            searchBar.tintColor = .white
//            searchBar.setIconColor(.white)
//            searchBar.setPlaceholderColor(.white)
//            self.searchBar.searchTextField.font = .setCustomFont(name: .medium, size: isDeviceIPad ? .x18 : .x14)
//            self.searchBar.searchTextField.textColor = .lightGray
//        } else {
//            // Fallback on earlier versions
//        }
//    }
    
    private func collectionSetUp(){
        self.mainCollectionView.delegate = self
        self.mainCollectionView.dataSource = self
        self.mainCollectionView.registerCell(with: YieldCollectionCell.self)
//        self.mainCollectionView.registerCell(with: MenuItemCollectionCell.self)
    }
    
    private func tableSetUp(){
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.emptyDataSetSource = self
        self.mainTableView.emptyDataSetDelegate  = self
        self.mainTableView.registerCell(with: MyWalletTableCell.self)
        self.mainTableView.registerHeaderFooter(with: MyWalletSectionView.self)
        self.mainTableView.registerHeaderFooter(with: YieldSectionHeaderView.self)
    }
    
    func rotateLeft(dropdownView: UIView,left: CGFloat = -1) {
        UIView.animate(withDuration: 1.0, animations: {
            dropdownView.transform = CGAffineTransform(rotationAngle: ((180.0 * CGFloat(Double.pi)) / 180.0) * CGFloat(left))
            self.view.layoutIfNeeded()
        })
    }
    
    private func hitYieldWalletBalanceAPI(){
        self.loader.isHidden = false
        self.presenter?.HITAPI(api: Base.yieldBalance.rawValue, params: nil , methodType: .GET, modelClass: WalletEntity.self, token: true)
    }
    
    private func hitYieldBuyInvestAPI(){
//        self.loader.isHidden = false
//        self.presenter?.HITAPI(api: Base.yieldBuyInvest.rawValue, params: nil, methodType: .GET, modelClass: SendTokenTypeModelEntity.self, token: true)
    }
    
}

// MARK: - Extension For TableView
//===========================
extension MyYieldVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return menuContent.endIndex + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 0
        default:
            return  menuContent[section-1].1.endIndex
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: MyWalletTableCell.self, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let view = mainTableView.dequeueHeaderFooter(with: YieldSectionHeaderView.self)
            return view
        default:
            let view = mainTableView.dequeueHeaderFooter(with: MyWalletSectionView.self)
            view.sectionTappedAction = { [weak self] (sender) in
                guard let selff = self else { return }
                if selff.menuContent[section].1.endIndex == 0 {
                    selff.menuContent[section].1 = ["1","2","3","4","5","6"]
                } else {
                    selff.menuContent[section].1 = []
                }
                tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .fade)
            }
//            self.rotateLeft(dropdownView: view.dropdownBtn,left : (self.menuContent[section-1].1.isEmpty ) ? 0 : -1)
            return view
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 55.0
        default:
            return 48.0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


// MARK: - Extension For CollectionView
//===========================
extension MyYieldVC : UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections.endIndex
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(with: YieldCollectionCell.self, indexPath: indexPath)
        cell.topLbl.text = sections[indexPath.row].0
        cell.topLbl.font = sections[indexPath.row].1 ? .setCustomFont(name: .semiBold, size: .x15) : .setCustomFont(name: .semiBold, size: .x14)
        cell.midFirstLbl.textColor  = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        cell.midSecondLbl.textColor  = sections[indexPath.row].1 ?  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
        cell.topLbl.textColor = sections[indexPath.row].1 ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
        cell.bottomLbl.textColor = (indexPath.row != 1) ? #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1) : #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        cell.middleView.isHidden  = (indexPath.row == 2)
        cell.midSecondLbl.isHidden  = (indexPath.row != 0)
        cell.midFirstLbl.isHidden  = (indexPath.row == 2)
        cell.dataContainerView.backgroundColor = sections[indexPath.row].1 ? #colorLiteral(red: 1, green: 0.1215686275, blue: 0.1764705882, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: sections[indexPath.row].0.widthOfString(usingFont: isDeviceIPad ? .setCustomFont(name: .semiBold, size: .x16) : .setCustomFont(name: .semiBold, size: .x12)) + 35.0, height: 35.0)
        let widtth  = (indexPath.row == 0) ? self.mainCollectionView.width - 16.0 : (self.mainCollectionView.width - 26.0)/2
        return CGSize(width: widtth , height: (self.mainCollectionView.height - 24.0)/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
          return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
      }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let indexx = self.sections.firstIndex(where: { (sortTuple) -> Bool in
            return sortTuple.1
        }){
            self.sections[indexx].1 = false
            self.sections[indexPath.row].1 = true
        } else {
            self.sections[indexPath.row].1 = true
        }
        self.mainCollectionView.reloadSections(NSIndexSet(index: indexPath.section) as IndexSet)
//        self.mainCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        self.mainTableView.reloadData()
    }
    
}


//MARK:- Tableview Empty dataset delegates
//========================================
extension MyYieldVC : DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
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

extension MyYieldVC : PresenterOutputProtocol {
    
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        self.loader.isHidden = true
    }
    
    func showSuccessWithParams(statusCode:Int,params: [String : Any], api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        self.loader.isHidden = true
        switch api {
        case Base.yieldBalance.rawValue:
            print(api)
        case Base.yieldBuyInvest.rawValue:
            print(api)
        default:
            print(api)
        }
        print(statusCode)
    }
    
    func showError(error: CustomError) {
        ToastManager.show(title:  nullStringToEmpty(string: error.localizedDescription.trimString()), state: .success)
        
    }
 
}


//MARK:- UISearchBarDelegate
//========================================
extension MyYieldVC: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
//        self.searchProducts(searchValue: self.searchText)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.resignFirstResponder()
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
//        self.searchProducts(searchValue: "")
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        searchBar.resignFirstResponder()
    }
}


// MARK: - Hotel filter Delegate methods

extension MyYieldVC: ProductFilterVCDelegate {
    func filterDataWithoutFilter(_ category: ([CategoryModel], Bool), _ status: ([String], Bool), _ min: (CGFloat, Bool), _ max: (CGFloat, Bool), _ start_from: (String, Bool), _ start_to: (String, Bool), _ close_from: (String, Bool), _ close_to: (String, Bool), _ maturity_from: (String, Bool), _ maturity_to: (String, Bool)) {
        ProductFilterVM.shared.selectedCategoryListing = self.selectedCategory.0
        ProductFilterVM.shared.start_from = self.selectedInvestorStart_from.0
        ProductFilterVM.shared.start_to = self.selectedInvestorStart_to.0
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
        ProductFilterVM.shared.investmentMaturity_from = maturity_from.1 ? maturity_from.0 : ""
        ProductFilterVM.shared.investmentMaturity_to = maturity_to.1 ? maturity_to.0 : ""
        ProductFilterVM.shared.start_from = start_from.1 ? start_from.0 : ""
        ProductFilterVM.shared.start_to = start_to.1 ? start_to.0 : ""
        if !start_from.1{self.selectedInvestorStart_from = ("",false) }
        if !start_to.1{self.selectedInvestorStart_to = ("",false) }
        if !maturity_from.1{self.selectedInvestorMature_from = ("",false) }
        if !maturity_to.1{self.selectedInvestorMature_to = ("",false) }
        //
        var params  = ProductFilterVM.shared.paramsDictForProducts
        params[ProductCreate.keys.page] =  1
        params[ProductCreate.keys.search] = self.searchText
//        switch (userType,false) {
//        case (UserType.campaigner.rawValue,false):
//            params[ProductCreate.keys.status] = campaignerProductType.titleValue
//            self.presenter?.HITAPI(api: Base.campaignerProductsDefault.rawValue, params: params, methodType: .GET, modelClass: ProductsModelEntity.self, token: true)
//        case (UserType.investor.rawValue,false):
//             params[ProductCreate.keys.new_products] = productType == .AllProducts ? 0 : 1
//             self.presenter?.HITAPI(api: Base.investerProductsDefault.rawValue, params: params, methodType: .GET, modelClass: ProductsModelEntity.self, token: true)
//        default:
//            break
//        }
//        self.loader.isHidden = false
    }
}
