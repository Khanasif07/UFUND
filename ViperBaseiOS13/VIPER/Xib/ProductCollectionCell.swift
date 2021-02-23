//
//  ProductCollectionCell.swift
//  ViperBaseiOS13
//
//  Created by Admin on 11/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit

class ProductCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imageViewContainerView: UIView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var productImg: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
       
        self.productImg.roundCorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 10)
        self.imageViewContainerView.roundCorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 10)
        self.shadowView.dropShadow(cornerRadius: 10, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 5)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
