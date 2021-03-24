//
//  DashboardTabsTableCell.swift
//  ViperBaseiOS13
//
//  Created by Admin on 23/03/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit

class DashboardTabsTableCell: UITableViewCell {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var tabsCollView: ASDynamicCollectionView!
    
    // MARK: - Variables
    //===========================
    var inversterImage :[UIImage] = [#imageLiteral(resourceName: "icCategoriesBg"),#imageLiteral(resourceName: "icProductWithBg"),#imageLiteral(resourceName: "icTokenizedAssetBg"),#imageLiteral(resourceName: "icTokenInvestmentBg"),#imageLiteral(resourceName: "icEarningInCryptoBg"),#imageLiteral(resourceName: "icCryptoCurrencyBg")]
    var campinerImage: [UIImage] = [#imageLiteral(resourceName: "add"),#imageLiteral(resourceName: "profile"),#imageLiteral(resourceName: "soild"), #imageLiteral(resourceName: "wallets"),#imageLiteral(resourceName: "vynil"),#imageLiteral(resourceName: "wallets")]
    var headerCount : [String]?
    var silderImage = [SilderImage]()
    var isFromCampainer = false {
        didSet {
            if isFromCampainer {
                headerCount = [Constants.string.add.localize(), Constants.string.profile.localize(), Constants.string.MyProducts.localize(),Constants.string.wallet.localize(), Constants.string.requests.localize(), Constants.string.send.localize()]
            }else{
                headerCount = [Constants.string.categories.localize(),Constants.string.Products.localize(), Constants.string.TokenizedAssets.localize(),Constants.string.allMyInvestment.localize(),Constants.string.earning.localize(),Constants.string.wallet.localize()]
                
            }
        }
    }
    
    // MARK: - Lifecycle
    //===========================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupCollectionView()
        // Initialization code
    }
    
    private func setupCollectionView() {
        tabsCollView.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        tabsCollView.delegate = self
        tabsCollView.dataSource = self
        let nibPost = UINib(nibName: XIB.Names.ProductsCollectionCell, bundle: nil)
        tabsCollView.register(nibPost, forCellWithReuseIdentifier: XIB.Names.ProductsCollectionCell)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - IBActions
    //===========================
    
    
}


//MARK:- Tableview delegates
//==========================
extension DashboardTabsTableCell: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isFromCampainer ? campinerImage.count : inversterImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: XIB.Names.ProductsCollectionCell, for: indexPath) as! ProductsCollectionCell
        cell.productValueLbll.isHidden = false
        cell.productImg.image = isFromCampainer ?  campinerImage[indexPath.row] : inversterImage[indexPath.row]
        cell.productNameLbl.textColor = .black
        cell.productNameLbl.text = isFromCampainer ? nullStringToEmpty(string: headerCount?[indexPath.row]) : nullStringToEmpty(string: headerCount?[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 16) / 2 , height: 175.0)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
}
