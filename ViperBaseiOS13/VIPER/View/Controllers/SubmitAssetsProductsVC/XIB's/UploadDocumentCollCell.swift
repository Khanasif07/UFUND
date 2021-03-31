//
//  UploadDocumentCollCell.swift
//  ViperBaseiOS13
//
//  Created by Admin on 31/03/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit

class UploadDocumentCollCell: UICollectionViewCell {

    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var shadowView: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyShadowView(view: shadowView)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        DispatchQueue.main.async {
            self.productImg.layer.masksToBounds = true
//            self.productImg.layer.borderWidth = 8.0
//            self.productImg.layer.borderColor = UIColor.rgb(r: 237, g: 236, b: 255).cgColor
            self.productImg.layer.cornerRadius = self.productImg.bounds.width / 2
        }
    }
    
}
