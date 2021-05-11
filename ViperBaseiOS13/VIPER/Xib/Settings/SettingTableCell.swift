//
//  SettingTableCell.swift
//  ViperBaseiOS13
//
//  Created by Admin on 27/04/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit

class SettingTableCell: UITableViewCell {

    @IBOutlet weak var titleImgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLbl.font = isDeviceIPad ? .setCustomFont(name: .semiBold, size: .x14) : .setCustomFont(name: .medium, size: .x14)
    }
}
