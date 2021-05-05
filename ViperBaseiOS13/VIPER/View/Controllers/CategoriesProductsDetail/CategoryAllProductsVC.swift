//
//  CategoryAllProductsVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 15/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit
import ObjectMapper
import DZNEmptyDataSet

class CategoryAllProductsVC: UIViewController {

    @IBOutlet weak var mainCollView: UICollectionView!
    
    var isUsedForMyInvestment: Bool = false
    var categoryType: CategoryType = .Products
    var categoryModel : CategoryModel?
    var allProductListing : [ProductModel]?{
        didSet{
            self.mainCollView.reloadData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        self.mainCollView.registerCell(with: NewProductsCollCell.self)
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
extension CategoryAllProductsVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
   
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.allProductListing?.endIndex ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch categoryType {
        case .Products:
            let cell = collectionView.dequeueCell(with: AllProductsCollCell.self, indexPath: indexPath)
            cell.productNameLbl.text =   (self.allProductListing?[indexPath.row].product_title ?? "")
            let imgEntity =   (self.allProductListing?[indexPath.row].product_image ?? "")
            let url = URL(string: baseUrl + "/" +  nullStringToEmpty(string: imgEntity))
            cell.productImgView.sd_setImage(with: url , placeholderImage: nil)
            cell.productTypeLbl.text =  (self.allProductListing?[indexPath.row].category?.category_name ?? "")
            cell.priceLbl.text =  "\((self.allProductListing?[indexPath.row].total_product_value ?? 0))"
            cell.investmentLbl.text =  "\(self.getProgressPercentage(productModel: (self.allProductListing?[indexPath.row])).round(to: 1))" + "%"
            cell.statusLbl.text = (self.allProductListing?[indexPath.row].product_status == 1) ? "Live" : (self.allProductListing?[indexPath.row].status == 2) ? "Closed" : "Matured"
            return cell
        default:
            let cell = collectionView.dequeueCell(with: NewProductsCollCell.self, indexPath: indexPath)
            cell.productNameLbl.text =   (self.allProductListing?[indexPath.row].tokenname ?? "")
            let imgEntity =    (self.allProductListing?[indexPath.row].token_image ?? "")
             let url = URL(string: baseUrl + "/" +  nullStringToEmpty(string: imgEntity))
            cell.productImgView.sd_setImage(with: url , placeholderImage: nil)
            cell.categoryLbl.text = (self.allProductListing?[indexPath.row].tokenrequest?.asset?.category?.category_name ?? "")
            cell.priceLbl.text =  "\((self.allProductListing?[indexPath.row].tokenrequest?.asset?.asset_value ?? 0))"
            cell.statusLbl.text = (self.allProductListing?[indexPath.row].token_status == 1) ? "Live" : "Live"
            cell.backgroundColor = .clear
                   return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 2), height: 36 * collectionView.frame.height / 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        switch categoryType {
        case .Products:
            if let parentVC = self.parent {
                 if let topVC = parentVC as? ProductTokenInvestmentVC {
                    if !topVC.isRequestinApi {
                        guard topVC.nextPageAvailable, !topVC.isRequestinApi else { return }
                    } else {
                        guard !topVC.isRequestinApi else { return }
                    }
                    topVC.isRequestinApi = true
                    topVC.getProductList(page: topVC.currentPage)
                }
            }
        default:
            if let parentVC = self.parent {
               if let topVC = parentVC as? ProductTokenInvestmentVC {
                    if !topVC.isRequestinApi {
                        guard topVC.nextPageAvailable, !topVC.isRequestinApi else { return }
                    } else {
                        guard !topVC.isRequestinApi else { return }
                    }
                    topVC.isRequestinApi = true
                    topVC.getProductList(page: topVC.currentPage)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch categoryType {
        case .Products:
            if isUsedForMyInvestment {
                let ob = MyInvestmentsDetailVC.instantiate(fromAppStoryboard: .Products)
                ob.productModel =  (self.allProductListing?[indexPath.row])
                ob.investmentType = .MyProductInvestment
                self.navigationController?.pushViewController(ob, animated: true)
            } else {
                let ob = ProductDetailVC.instantiate(fromAppStoryboard: .Products)
                ob.productModel =  (self.allProductListing?[indexPath.row])
                self.navigationController?.pushViewController(ob, animated: true)
            }
        default:
            if isUsedForMyInvestment {
                let ob = MyInvestmentsDetailVC.instantiate(fromAppStoryboard: .Products)
                ob.investmentType = .MyTokenInvestment
                ob.productModel =  (self.allProductListing?[indexPath.row])
                self.navigationController?.pushViewController(ob, animated: true)
            } else {
                let ob = AssetsDetailVC.instantiate(fromAppStoryboard: .Products)
                ob.productModel =  (self.allProductListing?[indexPath.row])
                self.navigationController?.pushViewController(ob, animated: true)
            }
        }
    }
}


//MARK:- Tableview Empty dataset delegates
//========================================
extension CategoryAllProductsVC : DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
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
