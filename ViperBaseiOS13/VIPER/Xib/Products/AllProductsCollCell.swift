//
//  AllProductsCollCell.swift
//  ViperBaseiOS13
//
//  Created by Admin on 15/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit

class AllProductsCollCell: UICollectionViewCell {

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var liveView: UIView!
    @IBOutlet weak var investmentLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var productTypeLbl: UILabel!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var productImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.productImgView.roundCorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 10)
        self.bottomView.roundCorners([.layerMaxXMaxYCorner, .layerMinXMaxYCorner], radius: 10)
        self.liveView.roundCorners([.layerMaxXMaxYCorner,.layerMaxXMinYCorner], radius: liveView.frame.height / 2.0)
        self.dataContainerView.dropShadow(cornerRadius: 10, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 5)
        
    }
    

}


extension UIColor{
    @nonobjc class var black16: UIColor {
        return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.07983178448)
    }
}


   
