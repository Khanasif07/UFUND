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
    
    // SET BUTTON TO RIGHT VIEW
    //=========================
    func setButtonToRightView(btn : UIButton, selectedImage : UIImage?, normalImage : UIImage?, size: CGSize?,isUserInteractionEnabled: Bool = true) {
        
        self.rightViewMode = .always
        self.rightView = btn
        
        btn.isSelected = false
        btn.isUserInteractionEnabled = isUserInteractionEnabled
        if let selectedImg = selectedImage { btn.setImage(selectedImg, for: .selected) }
        if let unselectedImg = normalImage { btn.setImage(unselectedImg, for: .normal) }
        if let btnSize = size {
            self.rightView?.frame.size = btnSize
        } else {
            self.rightView?.frame.size = CGSize(width: btn.intrinsicContentSize.width+10, height: self.frame.height)
        }
    }
    
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


extension UITextField{
    
    ///Sets and gets if the textfield has secure text entry
    var isSecureText:Bool{
        get{
            return self.isSecureTextEntry
        }
        set{
            let font = self.font
            self.isSecureTextEntry = newValue
            if let text = self.text{
                self.text = ""
                self.text = text
            }
            self.font = nil
            self.font = font
            self.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        }
    }
    
    func setupPasswordTextField() {
        self.isSecureText = true
        self.keyboardType = .asciiCapable
        self.isSecureTextEntry = self.isSecureText
        
        let showButton = UIButton()
        showButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        showButton.addTarget(self, action: #selector(self.showButtonTapped(_:)), for: .touchUpInside)
        self.setButtonToRightView(btn: showButton, selectedImage:  #imageLiteral(resourceName: "icHidePassword"), normalImage: #imageLiteral(resourceName: "icShowPassword"), size: CGSize(width: 20, height: 20))
    }
    
    /// Show Button Tapped
    @objc private func showButtonTapped(_ btn: UIButton) {
        btn.isSelected = !btn.isSelected
        self.isSecureText = !self.isSecureText
    }
}
