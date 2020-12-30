//
//  TextFieldExtension.swift
//  GoJekUser
//
//  Created by Ansar on 28/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    func setLeftPaddingPoints(_ amount:CGFloat)
    {
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount:CGFloat) {
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension UITextField {
    func placeholderColor() {
        let attributeString = [
            NSAttributedString.Key.foregroundColor: UIColor(hex: placeHolderColor),
            NSAttributedString.Key.font: self.font!
            ] as [NSAttributedString.Key : Any]
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: attributeString)
    }
}

extension UITextField {
    
    func applyEffectToTextField(placeHolderString: String) {
        self.textColor = UIColor(hex: darkTextColor)
        self.placeholder = nullStringToEmpty(string: placeHolderString)
        self.placeholderColor()
    }
}
