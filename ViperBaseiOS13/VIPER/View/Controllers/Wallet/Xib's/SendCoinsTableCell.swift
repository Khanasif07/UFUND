//
//  SendCoinsTableCell.swift
//  ViperBaseiOS13
//
//  Created by Admin on 18/05/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit

class SendCoinsTableCell: UITableViewCell {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var seeAllBtn: UIButton!
    @IBOutlet weak var numberOfTokenLbl: UILabel!
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var tabsCollView: ASDynamicCollectionView!
    
    // MARK: - Variables
    //===========================
    var investorDashboardData : DashboardEntity?{
        didSet{
            DispatchQueue.main.async {
                self.tabsCollView.layoutIfNeeded()
                self.tabsCollView.reloadData()
            }
        }
    }
    var tabsTapped:((IndexPath)->())?
    var inversterImage :[UIImage] = [#imageLiteral(resourceName: "icCategoriesBg"),#imageLiteral(resourceName: "icProductWithBg"),#imageLiteral(resourceName: "icTokenizedAssetBg"),#imageLiteral(resourceName: "icTokenInvestmentBg"),#imageLiteral(resourceName: "icEarningInCryptoBg"),#imageLiteral(resourceName: "icCryptoCurrencyBg")]
    var campinerImage: [UIImage] = [#imageLiteral(resourceName: "add"),#imageLiteral(resourceName: "profile"),#imageLiteral(resourceName: "soild"), #imageLiteral(resourceName: "wallets"),#imageLiteral(resourceName: "vynil"),#imageLiteral(resourceName: "wallets")]
    var headerCount : [(String,UIColor)]?
    var silderImage = [SilderImage]()
    var tokenListing : [SendTokenTypeModel]?{
        didSet{
            DispatchQueue.main.async {
                self.tabsCollView.layoutIfNeeded()
                self.tabsCollView.reloadData()
            }
        }
    }
    var isFromCampainer = false {
        didSet {
            if isFromCampainer {
                headerCount = [(Constants.string.categories.localize(),#colorLiteral(red: 1, green: 0.2588235294, blue: 0.3019607843, alpha: 1)),(Constants.string.Products.localize(),#colorLiteral(red: 0.3176470588, green: 0.3450980392, blue: 0.7333333333, alpha: 1)), (Constants.string.TokenizedAssets.localize(),#colorLiteral(red: 0.9725490196, green: 0.6980392157, blue: 0.2823529412, alpha: 1)),(Constants.string.allMyInvestment.localize(),#colorLiteral(red: 0.1411764706, green: 0.6352941176, blue: 0.6666666667, alpha: 1)),(Constants.string.earning.localize(),#colorLiteral(red: 0.5843137255, green: 0.7764705882, blue: 0.137254902, alpha: 1)),(Constants.string.wallet.localize(),#colorLiteral(red: 0.5529411765, green: 0.2705882353, blue: 0.8274509804, alpha: 1))]
            }else{
                headerCount = [
                    (Constants.string.categories.localize(),#colorLiteral(red: 1, green: 0.2588235294, blue: 0.3019607843, alpha: 1)),(Constants.string.Products.localize(),#colorLiteral(red: 0.3176470588, green: 0.3450980392, blue: 0.7333333333, alpha: 1)), (Constants.string.TokenizedAssets.localize(),#colorLiteral(red: 0.9725490196, green: 0.6980392157, blue: 0.2823529412, alpha: 1)),(Constants.string.allMyInvestment.localize(),#colorLiteral(red: 0.1411764706, green: 0.6352941176, blue: 0.6666666667, alpha: 1)),(Constants.string.earning.localize(),#colorLiteral(red: 0.5843137255, green: 0.7764705882, blue: 0.137254902, alpha: 1)),(Constants.string.wallet.localize(),#colorLiteral(red: 0.5529411765, green: 0.2705882353, blue: 0.8274509804, alpha: 1))]
                
            }
        }
    }
    
    // MARK: - Lifecycle
    //===========================
    override func awakeFromNib() {
        numberOfTokenLbl.font = isDeviceIPad ? .setCustomFont(name: .medium, size: .x20) : .setCustomFont(name: .medium, size: .x14)
        seeAllBtn.titleLabel?.font = isDeviceIPad ? .setCustomFont(name: .regular, size: .x18) : .setCustomFont(name: .regular, size: .x12)
        super.awakeFromNib()
        self.setupCollectionView()
    }
    
    
    private func setupCollectionView() {
        tabsCollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tabsCollView.delegate = self
        tabsCollView.dataSource = self
        let nibPost = UINib(nibName: XIB.Names.ProductsCollectionCell, bundle: nil)
        tabsCollView.register(nibPost, forCellWithReuseIdentifier: XIB.Names.ProductsCollectionCell)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.dataContainerView.roundCorners([.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner, .layerMaxXMaxYCorner], radius: 10)
    }
    
    // MARK: - IBActions
    //===========================
    
    
}


//MARK:- Tableview delegates
//==========================
extension SendCoinsTableCell: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tokenListing?.endIndex ?? 0
//        return isFromCampainer ? campinerImage.count : inversterImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: XIB.Names.ProductsCollectionCell, for: indexPath) as! ProductsCollectionCell
        cell.productValueLbll.isHidden = false
        cell.productImg.image = isFromCampainer ?  campinerImage[indexPath.row] : inversterImage[indexPath.row]
        cell.productNameLbl.textColor = .black
        cell.productNameLbl.text = tokenListing?[indexPath.row].token_details?.tokenname ?? ""
//        cell.productNameLbl.text = isFromCampainer ? nullStringToEmpty(string: headerCount?[indexPath.row].0) : nullStringToEmpty(string: headerCount?[indexPath.row].0)
        cell.productValueLbll.textColor = isFromCampainer ?  headerCount?[indexPath.row].1 :  headerCount?[indexPath.row].1
        cell.productValueLbll.text = "\(tokenListing?[indexPath.row].avilable_token ?? 0)"
//        cell.configureCellForInvestorDashboard(indexPath: indexPath, model: investorDashboardData ?? DashboardEntity())
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isDeviceIPad {
            return CGSize(width: (collectionView.frame.width) / 2 , height: 325.0)
        } else {
            return CGSize(width: (collectionView.frame.width) / 2 , height: 175.0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       if let handle = tabsTapped{
            handle(indexPath)
        }
    }
    
}
