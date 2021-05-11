//
//  AddDescTableCell.swift
//  ViperBaseiOS13
//
//  Created by Admin on 01/04/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit

class AddDescTableCell: UITableViewCell {

    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var textView: PlaceholderTextView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var textFieldView: UIView!
    
    
    override func prepareForReuse() {
        textView.inputView = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.dataContainerView.applyShadow(radius: 0)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLbl.font =  isDeviceIPad ? .setCustomFont(name: .semiBold, size: .x16) : .setCustomFont(name: .semiBold, size: .x12)
        self.textView.font =  isDeviceIPad ? .setCustomFont(name: .medium, size: .x16) : .setCustomFont(name: .regular, size: .x12)
        textView.applyEffectToView()
    }

}
