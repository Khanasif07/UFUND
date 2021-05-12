//
//  ProductDetailDescriptionCell.swift
//  ViperBaseiOS13
//
//  Created by Admin on 19/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit

class ProductDetailDescriptionCell: UITableViewCell {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var priceTitleLbl: UILabel!
    @IBOutlet weak var productDetailLbl: UILabel!
    @IBOutlet weak var productLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var productDescLbl: UILabel!
    @IBOutlet weak var productTitleLbl: UILabel!
    // MARK: - Variables
    //===========================
    
    // MARK: - Lifecycle
    //===========================
    override func awakeFromNib() {
        super.awakeFromNib()
        productLbl.font = isDeviceIPad ? .setCustomFont(name: .regular, size: .x14) : .setCustomFont(name: .regular, size: .x10)
        productTitleLbl.font = isDeviceIPad ? .setCustomFont(name: .semiBold, size: .x24) : .setCustomFont(name: .semiBold, size: .x20)
        productDetailLbl.font = isDeviceIPad ? .setCustomFont(name: .medium, size: .x18) : .setCustomFont(name: .medium, size: .x14)
        productDescLbl.font = isDeviceIPad ? .setCustomFont(name: .regular, size: .x16) : .setCustomFont(name: .regular, size: .x12)
        priceTitleLbl.font  = isDeviceIPad ? .setCustomFont(name: .medium, size: .x20) : .setCustomFont(name: .medium, size: .x16)
        priceLbl.font  = isDeviceIPad ? .setCustomFont(name: .semiBold, size: .x20) : .setCustomFont(name: .semiBold, size: .x16)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - IBActions
    //===========================
    
    
}
