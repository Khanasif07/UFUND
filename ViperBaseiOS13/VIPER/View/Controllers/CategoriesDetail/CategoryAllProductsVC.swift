//
//  CategoryAllProductsVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 15/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class CategoryAllProductsVC: UIViewController {

    @IBOutlet weak var mainCollView: UICollectionView!
    
    var isSearchEnable: Bool = false
    var allSearchProductListing : [ProductModel]? = []
    var  allProductListing : [ProductModel]?{
        didSet{
            self.mainCollView.reloadData()
        }
    }
    var searchText: String? {
           didSet{
               if let searchedText = searchText{
                   if searchedText.isEmpty{
                       self.isSearchEnable = false
                       self.mainCollView.reloadData()
                   } else {
                       self.isSearchEnable = true
                       self.allSearchProductListing = allProductListing?.filter({(($0.product_title?.lowercased().contains(s: searchedText.lowercased()))!)})
                       self.mainCollView.reloadData()
                   }
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

}

//MARK: - Collection view delegate
extension CategoryAllProductsVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
   
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isSearchEnable ?   (self.allSearchProductListing?.endIndex ?? 0)   : (self.allProductListing?.endIndex ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(with: AllProductsCollCell.self, indexPath: indexPath)
        cell.productNameLbl.text =  isSearchEnable ? (self.allSearchProductListing?[indexPath.row].product_title ?? "") : (self.allProductListing?[indexPath.row].product_title ?? "")
        let imgEntity =  isSearchEnable ? (self.allSearchProductListing?[indexPath.row].product_image ?? "") : (self.allProductListing?[indexPath.row].product_image ?? "")
        let url = URL(string: baseUrl + "/" +  nullStringToEmpty(string: imgEntity))
        cell.productImgView.sd_setImage(with: url , placeholderImage: nil)
        cell.productTypeLbl.text = isSearchEnable ? (self.allSearchProductListing?[indexPath.row].category?.category_name ?? "") : (self.allProductListing?[indexPath.row].category?.category_name ?? "")
        cell.priceLbl.text = isSearchEnable ? "\((self.allSearchProductListing?[indexPath.row].total_product_value ?? 0))" : "\((self.allProductListing?[indexPath.row].total_product_value ?? 0))"
        cell.backgroundColor = .clear
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 2), height: 35 * collectionView.frame.height / 100)
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

