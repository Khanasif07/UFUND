//
//  UploadDocumentTableCell.swift
//  ViperBaseiOS13
//
//  Created by Admin on 31/03/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit

class UploadDocumentTableCell: UITableViewCell {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var tabsCollView: ASDynamicCollectionView!
    
    // MARK: - Variables
    //===========================
    var imgDataArray = [(UIImage,Data,Bool)]()
    var uploadBtnsTapped: ((IndexPath)->())?
    var investorDashboardData : DashboardEntity?{
        didSet{
            self.tabsCollView.reloadData()
        }
    }
    var headerCount : [(String,UIColor)]?
    var isFromAddProduct = false {
        didSet {
            if isFromAddProduct {
                headerCount = [
                    (Constants.string.uploadDoucment.localize(),#colorLiteral(red: 1, green: 0.2588235294, blue: 0.3019607843, alpha: 1)),(Constants.string.uploadRegulatoryDoucment.localize(),#colorLiteral(red: 0.3176470588, green: 0.3450980392, blue: 0.7333333333, alpha: 1)), (Constants.string.uploadProductImage.localize(),#colorLiteral(red: 0.9725490196, green: 0.6980392157, blue: 0.2823529412, alpha: 1))]
                self.tabsCollView.reloadData()
            }else{
                
                headerCount = [(Constants.string.uploadDoucment.localize(),#colorLiteral(red: 1, green: 0.2588235294, blue: 0.3019607843, alpha: 1)),
                               (Constants.string.uploadRegulatoryDoucment.localize(),#colorLiteral(red: 0.3176470588, green: 0.3450980392, blue: 0.7333333333, alpha: 1)),
                               (Constants.string.uploadTokensImage.localize(),#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)),(Constants.string.uploadAssetImage.localize(),#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))]
                self.tabsCollView.reloadData()
                
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
        tabsCollView.contentInset = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        tabsCollView.delegate = self
        tabsCollView.dataSource = self
        tabsCollView.registerCell(with: UploadDocumentCollCell.self)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dataContainerView.addShadowRounded(cornerRadius: 5, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 5)
    }
    
    // MARK: - IBActions
    //===========================
    
    
}


//MARK:- Tableview delegates
//==========================
extension UploadDocumentTableCell: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return headerCount?.endIndex ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueCell(with: UploadDocumentCollCell.self, indexPath: indexPath)
        cell.documentImgView.image = imgDataArray[indexPath.row].0
        cell.documentImgView.isHidden = !imgDataArray[indexPath.row].2
        cell.documentBtnTapped = { [weak self] (sender)  in
            guard let selff = self else {return}
            if let handle = selff.uploadBtnsTapped{
                if let cell = collectionView.cell(forItem: sender) as? UploadDocumentCollCell {
                           if  let indexPath = collectionView.indexPath(forItem: cell){
                            handle(indexPath)
                    }
                }
            }
            print(selff)
        }
        cell.productNameLbl.textColor = .black
        cell.productNameLbl.text = isFromAddProduct ? nullStringToEmpty(string: headerCount?[indexPath.row].0) : nullStringToEmpty(string: headerCount?[indexPath.row].0)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 32) / 2 , height: isDeviceIPad ? 185.0 : 147.5)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
}
