//
//  CategoryNewProductsVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 15/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//


import UIKit
import DZNEmptyDataSet

class CategoryNewProductsVC: UIViewController {

    @IBOutlet weak var mainCollView: UICollectionView!
    
    var categoryType: CategoryType = .Products
    var isSearchEnable: Bool = false
    var categoryModel : CategoryModel?
    var categoryModelId : Int = 0
    var searchNewProductListing : [ProductModel]? = []
    var  newProductListing : [ProductModel]?{
        didSet{
            self.mainCollView.reloadData()
        }
    }
    lazy var loader  : UIView = {
        return createActivityIndicator(self.view)
    }()
    var searchText: String? {
           didSet{
               if let searchedText = searchText{
                   if searchedText.isEmpty{
                       self.isSearchEnable = false
                       self.mainCollView.reloadData()
                   } else {
                       self.isSearchEnable = true
                       self.searchNewProductListing = newProductListing?.filter({(($0.product_title?.lowercased().contains(s: searchedText.lowercased()))!)})
                       self.mainCollView.reloadData()
                   }
               }
           }
       }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.parent?.isKind(of: CategoriesProductsDetailVC.self) ?? false{
            if let controller = self.parent as? CategoriesProductsDetailVC {
                  self.categoryModel = controller.categoryModel
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }
    
    
    private func initialSetup(){
        self.mainCollView.delegate = self
        self.mainCollView.dataSource = self
        self.mainCollView.emptyDataSetDelegate = self
        self.mainCollView.emptyDataSetSource = self
        self.mainCollView.registerCell(with: AllProductsCollCell.self)
        let layout1 = UICollectionViewFlowLayout()
        layout1.scrollDirection = .vertical
        mainCollView.collectionViewLayout = layout1
        layout1.minimumInteritemSpacing = 0
        layout1.minimumLineSpacing = 0
    }
 
    private func getProgressPercentage(productModel: ProductModel?) -> Double{
        let investValue =   (productModel?.investment_product_total ?? 0.0 )
        let totalValue =  (productModel?.total_product_value ?? 0.0)
        return (investValue / totalValue) * 100
    }


}

//MARK: - Collection view delegate
extension CategoryNewProductsVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
   
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isSearchEnable ?   (self.searchNewProductListing?.endIndex ?? 0)   : (self.newProductListing?.endIndex ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(with: AllProductsCollCell.self, indexPath: indexPath)
        switch categoryType {
        case .Products:
            cell.productNameLbl.text =  isSearchEnable ? (self.searchNewProductListing?[indexPath.row].product_title ?? "") : (self.newProductListing?[indexPath.row].product_title ?? "")
            let imgEntity =  isSearchEnable ? (self.searchNewProductListing?[indexPath.row].product_image ?? "") : (self.newProductListing?[indexPath.row].product_image ?? "")
            let url = URL(string: baseUrl + "/" +  nullStringToEmpty(string: imgEntity))
            cell.productImgView.sd_setImage(with: url , placeholderImage: nil)
            cell.productTypeLbl.text = isSearchEnable ? (self.searchNewProductListing?[indexPath.row].category?.category_name ?? "") : (self.newProductListing?[indexPath.row].category?.category_name ?? "")
            cell.priceLbl.text = isSearchEnable ? "\((self.searchNewProductListing?[indexPath.row].total_product_value ?? 0))" : "\((self.newProductListing?[indexPath.row].total_product_value ?? 0))"
            cell.investmentLbl.text = "\(self.getProgressPercentage(productModel: isSearchEnable ?   (self.searchNewProductListing?[indexPath.row])   : (self.newProductListing?[indexPath.row])).round(to: 1))" + "%"
        default:
            cell.productNameLbl.text =   isSearchEnable ? (self.searchNewProductListing?[indexPath.row].tokenname ?? "") : (self.newProductListing?[indexPath.row].tokenname ?? "")
            let imgEntity =   isSearchEnable ? (self.searchNewProductListing?[indexPath.row].token_image ?? "") : (self.newProductListing?[indexPath.row].token_image ?? "")
            let url = URL(string: baseUrl + "/" +  nullStringToEmpty(string: imgEntity))
            cell.productImgView.sd_setImage(with: url , placeholderImage: nil)
            cell.productTypeLbl.text = isSearchEnable ? (self.searchNewProductListing?[indexPath.row].tokenrequest?.asset?.category?.category_name ?? "") : (self.newProductListing?[indexPath.row].tokenrequest?.asset?.category?.category_name ?? "")
            //            cell.priceLbl.text = isSearchEnable ? "\((self.allSearchProductListing?[indexPath.row].total_product_value ?? 0))" : "\((self.allProductListing?[indexPath.row].total_product_value ?? 0))"
            //            cell.investmentLbl.text = "\(self.getProgressPercentage(productModel: isSearchEnable ?   (self.allSearchProductListing?[indexPath.row])   : (self.allProductListing?[indexPath.row])).round(to: 1))" + "%"
        }
        cell.backgroundColor = .clear
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 2), height: 36 * collectionView.frame.height / 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch categoryType {
        case .Products:
            let ob = ProductDetailVC.instantiate(fromAppStoryboard: .Products)
            ob.productModel = isSearchEnable ?   (self.searchNewProductListing?[indexPath.row])   : (self.newProductListing?[indexPath.row])
            self.navigationController?.pushViewController(ob, animated: true)
        default:
            let ob = AssetsDetailVC.instantiate(fromAppStoryboard: .Products)
            ob.productModel = isSearchEnable ?   (self.searchNewProductListing?[indexPath.row])   : (self.newProductListing?[indexPath.row])
            self.navigationController?.pushViewController(ob, animated: true)
        }
    }
}


//MARK:- Tableview Empty dataset delegates
//========================================
extension CategoryNewProductsVC : DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
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
