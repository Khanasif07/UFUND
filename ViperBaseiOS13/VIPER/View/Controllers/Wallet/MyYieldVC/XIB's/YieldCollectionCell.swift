//
//  YieldCollectionCell.swift
//  ViperBaseiOS13
//
//  Created by Admin on 01/06/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit

class YieldCollectionCell: UICollectionViewCell {

    @IBOutlet weak var midSecondLbl: UILabel!
    @IBOutlet weak var midFirstLbl: UILabel!
    @IBOutlet weak var middleView: UIStackView!
    @IBOutlet weak var topLbl: UILabel!
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var bottomLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpFont()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dataContainerView.roundCorners([.layerMaxXMaxYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner], radius: 10.0)
    }
    
    private func setUpFont(){
        topLbl.font = .setCustomFont(name: .medium, size: .x14)
        midFirstLbl.font = .setCustomFont(name: .semiBold, size: .x15)
        midSecondLbl.font = .setCustomFont(name: .semiBold, size: .x15)
        bottomLbl.font = .setCustomFont(name: .semiBold, size: .x15)
    }

}
