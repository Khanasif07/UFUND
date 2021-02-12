//
//  ProductCollectionCell.swift
//  ViperBaseiOS13
//
//  Created by Admin on 11/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit

class ProductCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var productImg: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyShadowView(view: shadowView)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        DispatchQueue.main.async {
//            self.productNameLbl.textColor = UIColor(hex: darkTextColor)
        }
    }
}
