//
//  UserProfileTableCell.swift
//  ViperBaseiOS13
//
//  Created by Admin on 08/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit

class UserProfileTableCell: UITableViewCell {

    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var textFIeld: UITextField!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var textFieldView: UIView!
    
    
    override func prepareForReuse() {
        textFIeld.rightView = nil
        textFIeld.inputView = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.dataContainerView.applyShadow(radius: 0)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLbl.font =  isDeviceIPad ? .setCustomFont(name: .semiBold, size: .x14) : .setCustomFont(name: .medium, size: .x14)
        self.textFIeld.font =  isDeviceIPad ? .setCustomFont(name: .medium, size: .x14) : .setCustomFont(name: .regular, size: .x12)
        textFieldView.applyEffectToView()
    }

}
