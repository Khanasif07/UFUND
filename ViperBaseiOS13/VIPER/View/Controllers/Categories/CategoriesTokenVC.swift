//
//  CategoriesTokenVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 11/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class CategoriesTokenVC: UIViewController {
    
    @IBOutlet weak var mainCollView: UICollectionView!
    
    var searchTokenCategories : [CategoryModel]? = []
    var isSearchEnable : Bool = false
    var tokenCategories : [CategoryModel]?{
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
                    self.searchTokenCategories = tokenCategories?.filter({(($0.category_name?.lowercased().contains(s: searchedText.lowercased()))!)})
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
        self.mainCollView.registerCell(with: ProductCollectionCell.self)
        let layout1 = UICollectionViewFlowLayout()
        layout1.scrollDirection = .vertical
        mainCollView.collectionViewLayout = layout1
        layout1.minimumInteritemSpacing = 0
        layout1.minimumLineSpacing = 0
    }
    
}

//MARK: - Collection view delegate
extension CategoriesTokenVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isSearchEnable ?  (self.searchTokenCategories?.endIndex ?? 0) : (self.tokenCategories?.endIndex ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(with: ProductCollectionCell.self, indexPath: indexPath)
        cell.productName.text = isSearchEnable ? (self.searchTokenCategories?[indexPath.row].category_name ?? "") : (self.tokenCategories?[indexPath.row].category_name ?? "")
        let imgEntity =  isSearchEnable ? (self.searchTokenCategories?[indexPath.row].image ?? "") : (self.tokenCategories?[indexPath.row].image ?? "")
        let url = URL(string: baseUrl + "/" +  nullStringToEmpty(string: imgEntity))
        cell.productImg.sd_setImage(with: url , placeholderImage: nil)
        cell.backgroundColor = .clear
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2 , height: 34 * collectionView.frame.height / 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedVC = CategoriesDetailVC.instantiate(fromAppStoryboard: .Main)
        selectedVC.categoryTitle = isSearchEnable ? (self.searchTokenCategories?[indexPath.row].category_name ?? "") : (self.tokenCategories?[indexPath.row].category_name ?? "")
        self.navigationController?.pushViewController(selectedVC, animated: true)
    }
}


//MARK:- Tableview Empty dataset delegates
//========================================
extension CategoriesTokenVC : DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return  #imageLiteral(resourceName: "icNoData")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string:"", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray,NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16.0)])
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string:"Looks Nothing Found", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray,NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16.0)])
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
