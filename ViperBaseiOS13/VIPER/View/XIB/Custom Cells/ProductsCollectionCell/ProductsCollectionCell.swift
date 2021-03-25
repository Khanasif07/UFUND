//
//  ProductsCollectionCell.swift
//  ViperBaseiOS13
//
//  Created by Deepika on 26/11/19.
//  Copyright © 2019 CSS. All rights reserved.
//

import UIKit

class ProductsCollectionCell: UICollectionViewCell {

    @IBOutlet weak var redBackgroundView: UIView!
    @IBOutlet weak var productValueLbll: UILabel!
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
            self.productImg.layer.borderWidth = 8.0
            self.productImg.layer.borderColor = UIColor.rgb(r: 237, g: 236, b: 255).cgColor
            self.productImg.layer.cornerRadius = self.productImg.bounds.width / 2
        }
    }
    
    public func configureCell(indexPath: IndexPath){
        if indexPath.row == 0 {
            redBackgroundView.roundCorners([.layerMinXMaxYCorner], radius: 5.0)
        } else if indexPath.row == 1 {
            redBackgroundView.roundCorners([.layerMaxXMaxYCorner], radius: 5.0)
        } else {}
    }
    
    public func configureCellForInvestorDashboard(indexPath: IndexPath,model: DashboardEntity){
        switch indexPath.row {
        case 0:
            productValueLbll.text = "\(model.total_categories ?? 0)"
        case 1:
            productValueLbll.text = "\(model.total_products ?? 0)"
        case 2:
            productValueLbll.text = "$ " + "\(model.total_tokenizes_assets ?? 0)"
        case 3:
            productValueLbll.text = "\(model.my_investements ?? 0)"
        case 4:
            productValueLbll.text = "$ " + "\(model.total_earning ?? 0)"
        case 5:
            productValueLbll.text = "$ " + "\(model.total_wallets ?? 0)"
        default:
            print("")
        }
    }

}
