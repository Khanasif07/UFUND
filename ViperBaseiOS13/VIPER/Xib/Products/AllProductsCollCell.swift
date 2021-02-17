//
//  AllProductsCollCell.swift
//  ViperBaseiOS13
//
//  Created by Admin on 15/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit

class AllProductsCollCell: UICollectionViewCell {

    @IBOutlet weak var liveView: UIView!
    @IBOutlet weak var investmentLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var productTypeLbl: UILabel!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var productImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    dataContainerView.roundCorners([.layerMaxXMaxYCorner,.layerMaxXMinYCorner,.layerMinXMinYCorner,.layerMinXMaxYCorner], radius: 12.5)
        dataContainerView.borderColor = UIColor.black16
        dataContainerView.borderLineWidth = 1.0
        liveView.roundCorners([.layerMaxXMaxYCorner,.layerMaxXMinYCorner], radius: liveView.frame.height / 2.0)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        dataContainerView.addShadowDefault(cornerRadius: 5, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 5)
              
    }

}


extension UIColor{
    @nonobjc class var black16: UIColor {
        return UIColor(white: 48.0 / 255.0, alpha: 0.16)
    }
}
