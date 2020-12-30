//
//  ImageView.swift
//  User
//
//  Created by CSS on 09/01/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
@IBDesignable
class ImageView: UIImageView {

    //MARK:- Make Rounded Corner
    @IBInspectable
    var isRoundedCorner : Bool = false {
        
        didSet {
            
            if isRoundedCorner {
                self.layer.masksToBounds = true
                self.layer.cornerRadius =  frame.height/2
            }
        }
        
    }

    //MARK:- Make Image Tint Color
    @IBInspectable
    var isImageTintColor : Bool = false {
        
        didSet {
            
            if isImageTintColor {
              
                self.image = self.image?.withRenderingMode(.alwaysTemplate)
    
            }
        }
        
    }
    
    
    func setRoundCorner() {
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.height/2
        self.layoutIfNeeded()
    }
    
    func setShadow(color: UIColor) {
        self.layer.shadowOpacity = 0.7
        self.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        self.layer.shadowRadius = 7.0
        self.layer.shadowColor = color.cgColor
    }
    
    
    
    
}
