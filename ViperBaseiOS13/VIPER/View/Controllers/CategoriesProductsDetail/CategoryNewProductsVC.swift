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
    var categoryModel : CategoryModel?
    var categoryModelId : Int = 0
    var  newProductListing : [ProductModel]?{
        didSet{
            self.mainCollView.reloadData()
        }
    }
    lazy var loader  : UIView = {
        return createActivityIndicator(self.view)
    }()
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
        self.mainCollView.registerCell(with: NewProductsCollCell.self)
        self.mainCollView.registerCell(with: AllProductsCollCell.self)
        let layout1 = UICollectionViewFlowLayout()
        layout1.scrollDirection = .vertical
        mainCollView.collectionViewLayout = layout1
        layout1.minimumInteritemSpacing = 0
        layout1.minimumLineSpacing = 0
    }
 
    private func getProgressPercentage(productModel: ProductModel?) -> Double{
//        let investValue =   (productModel?.investment_product_total ?? 0.0 )
//        let totalValue =  (productModel?.total_product_value ?? 0.0)
//        return (investValue / totalValue) * 100
        let pending_invest_per =  (productModel?.pending_invest_per ?? 0 )
        return 100.0 - Double(pending_invest_per)
    }


}

//MARK: - Collection view delegate
extension CategoryNewProductsVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
   
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  (self.newProductListing?.endIndex ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        switch categoryType {
        case .Products:
            let cell = collectionView.dequeueCell(with: AllProductsCollCell.self, indexPath: indexPath)
            cell.productNameLbl.text =  (self.newProductListing?[indexPath.row].product_title ?? "")
            let imgEntity =  (self.newProductListing?[indexPath.row].product_image ?? "")
//            let url = URL(string: baseUrl + "/" +  nullStringToEmpty(string: imgEntity))
            let url = URL(string: nullStringToEmpty(string: imgEntity))
            cell.productImgView.sd_setImage(with: url , placeholderImage: nil)
            cell.productTypeLbl.text =  (self.newProductListing?[indexPath.row].category?.category_name ?? "")
            cell.priceLbl.text =  "\((self.newProductListing?[indexPath.row].total_product_value ?? 0))"
            cell.investmentPerValueLbl.text = "\(self.newProductListing?[indexPath.row].invest_profit_per ?? 0)"
            cell.investmentLbl.text = "\(self.getProgressPercentage(productModel: (self.newProductListing?[indexPath.row])).round(to: 1))" + "%"
            cell.statusLbl.text = (self.newProductListing?[indexPath.row].product_status == 1) ? "Live" : (self.newProductListing?[indexPath.row].status == 2) ? "Closed" : "Matured"
            return cell
        default:
            let cell = collectionView.dequeueCell(with: NewProductsCollCell.self, indexPath: indexPath)
            let imgEntity =   (self.newProductListing?[indexPath.row].token_image ?? "")
//            let url = URL(string: baseUrl + "/" +  nullStringToEmpty(string: imgEntity))
            let url = URL(string: nullStringToEmpty(string: imgEntity))
            cell.productImgView.sd_setImage(with: url , placeholderImage: nil)
            if userType == UserType.investor.rawValue {
                cell.categoryLbl.text =  (self.newProductListing?[indexPath.row].tokenrequest?.asset?.category?.category_name ?? "")
                cell.productNameLbl.text =  (self.newProductListing?[indexPath.row].tokenname ?? "")
            } else{
                cell.categoryLbl.text =  (self.newProductListing?[indexPath.row].asset?.category?.category_name ?? "")
                cell.productNameLbl.text =  (self.newProductListing?[indexPath.row].asset?.asset_title ?? "")
            }
            cell.priceLbl.text =  "\((self.newProductListing?[indexPath.row].tokenvalue ?? 0))"
            cell.statusLbl.text = (self.newProductListing?[indexPath.row].product_status == 1) ? "Live" : "Live"
            return cell
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 2), height: 36 * collectionView.frame.height / 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch categoryType {
        case .Products:
            let ob = ProductDetailVC.instantiate(fromAppStoryboard: .Products)
            ob.productModel = (self.newProductListing?[indexPath.row])
            self.navigationController?.pushViewController(ob, animated: true)
        default:
            let ob = AssetsDetailVC.instantiate(fromAppStoryboard: .Products)
            ob.productModel =  (self.newProductListing?[indexPath.row])
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

