//
//  Fonts.swift
//  ViperBaseiOS13
//
//  Created by Deepika on 21/11/19.
//  Copyright © 2019 CSS. All rights reserved.
//

import Foundation
import UIKit

//Custom font type
enum FontType: String {

    case extraLight = "Poppins-ExtraLight"
    case bold = "Poppins-Bold"
    case regular = "Poppins-Regular"
    case semiBold = "Poppins-SemiBold"
    case light = "Poppins-Light"
    case medium = "Poppins-Medium"
    
}

//Custom font size
enum FontSize: CGFloat {
    case x8 = 8.0
    case x10 = 10.0
    case x12 = 12.0
    case x13 = 13.0
    case x15 = 15.0
    case x14 = 14.0
    case x16 = 16.0
    case x18 = 18.0
    case x20 = 20.0
    case x22 = 22.0
    case x24 = 24.0
    case x26 = 26.0
    case x28 = 28.0
    case x30 = 30.0
    
}

//Set Custom font and size
extension UIFont {
    
    class func setCustomFont(name: FontType, size: FontSize) -> UIFont {
        print(size)
        print(name.rawValue)
        return UIFont(name: name.rawValue, size: size.rawValue) ?? UIFont.boldSystemFont(ofSize: 16)
    }
}
