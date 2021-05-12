//
//  ProductSortTableCell.swift
//  ViperBaseiOS13
//
//  Created by Admin on 11/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit

class ProductSortTableCell: UITableViewCell {
    
    
    @IBOutlet weak var sortBtn: UIButton!
    @IBOutlet weak var sortTitleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        sortTitleLbl.font = isDeviceIPad ? .setCustomFont(name: .regular, size: .x20) : .setCustomFont(name: .regular, size: .x15)
    }
}
