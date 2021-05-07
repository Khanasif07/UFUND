//
//  SideMenuHeaderView.swift
//  ViperBaseiOS13
//
//  Created by Admin on 05/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit

class SideMenuHeaderView: UITableViewHeaderFooterView {
    
    var headerBtnAction: ((UIButton)->())?

    @IBOutlet weak var dropdownView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var headerBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLbl.font = isDeviceIPad ? .setCustomFont(name: .medium, size: .x14) : .setCustomFont(name: .regular, size: .x14)
    }
    
    
    @IBAction func sectionTapped(_ sender: UIButton) {
        if let handle = headerBtnAction{
            handle(sender)
        }
    }

}
