//
//  UserProfilePhoneNoCell.swift
//  ViperBaseiOS13
//
//  Created by Admin on 09/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit

class UserProfilePhoneNoCell: UITableViewCell {
    
    var countryPickerTapped : ((UIButton)->())?

    @IBOutlet weak var countryTxtFld: UITextField!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var textFieldView: UIView!
    
    @IBAction func countryPickerAction(_ sender: UIButton) {
        if let handle = countryPickerTapped {
            handle(sender)
        }
    }
    
     override func layoutSubviews() {
           super.layoutSubviews()
           self.dataContainerView.applyShadow(radius: 0)
       }
       
    override func awakeFromNib() {
        super.awakeFromNib()
        countryTxtFld.contentVerticalAlignment = .center
        // horizontal alignment
        countryTxtFld.textAlignment = .center
        countryTxtFld.isUserInteractionEnabled = false
        countryTxtFld.font =   isDeviceIPad ? .setCustomFont(name: .medium, size: .x16) : .setCustomFont(name: .regular, size: .x12)
        self.titleLbl.font =  isDeviceIPad ? .setCustomFont(name: .bold, size: .x16) : .setCustomFont(name: .bold, size: .x12)
        self.phoneTextField.font =  isDeviceIPad ? .setCustomFont(name: .medium, size: .x16) : .setCustomFont(name: .regular, size: .x12)
        textFieldView.applyEffectToView()
    }
}
