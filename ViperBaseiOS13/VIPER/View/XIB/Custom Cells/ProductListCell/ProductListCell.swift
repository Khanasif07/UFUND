//
//  ProductListCell.swift
//  ViperBaseiOS13
//
//  Created by Deepika on 26/12/19.
//  Copyright © 2019 CSS. All rights reserved.
//

import UIKit

class ProductListCell: UICollectionViewCell {
    
    @IBOutlet weak var middleValLbl: UILabel!
    @IBOutlet weak var enValueLbl: UILabel!
    @IBOutlet weak var startValueLbl: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var statusStack: UIStackView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var labelValue: UILabel!
    @IBOutlet weak var labelProductAmount: UILabel!
    
    

    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        applyShadowView(view: bgView)

        statusStack.addBackground(color: UIColor(hex: primaryColor))
        stackView.addBackground(color: UIColor(hex: primaryColor))
        statusView.frame.size = CGSize(width: self.labelProductAmount.frame.width + 20.0, height: 13)
        
    }

}
