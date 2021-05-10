//
//  LabelExtension.swift
//  ViperBaseiOS13
//
//  Created by Deepika on 20/11/19.
//  Copyright © 2019 CSS. All rights reserved.
//

import Foundation
import UIKit

extension UILabel{
    func animate() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            // moves label up 100 units in the y axis
            self.transform = CGAffineTransform(translationX: 0, y: -25)
        }) { finished in
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                // move label back down to its original position
                self.transform = CGAffineTransform(translationX: 0, y: 0)
            }) { finished in
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                    // move label back down to its original position
                    self.transform = CGAffineTransform(translationX: 0, y: -2)
                }) { finished in
                    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                        // move label back down to its original position
                        self.transform = CGAffineTransform(translationX: 0, y: 0)
                    })
                }
            }
        }
    }
    

    
    func attributeString(string:String,range:NSRange,color:UIColor) {
        let attributeStr: NSMutableAttributedString = NSMutableAttributedString(string: string)
        attributeStr.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        self.attributedText = attributeStr
    }
    
    func attributeString(string: String,range1:NSRange,range2:NSRange?,color:UIColor) {

        let attributedString = NSMutableAttributedString(string: string)
        
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 50 // Whatever line spacing you want in points
        
        // *** Apply attribute to string ***
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:range1)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range1)
        if (range2 != nil) {
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range2!)
        }
        // *** Set Attributed String to your label ***
        self.attributedText = attributedString
    }
}


extension UILabel {
    func halfTextColorChange (fullText : String , changeText : String) {
        let strNumber: NSString = fullText as NSString
        let range = (strNumber).range(of: changeText)
        let rangeSignUp = NSString(string: strNumber).range(of: changeText, options: String.CompareOptions.caseInsensitive)
               
        let rangeFull = NSString(string: strNumber).range(of: fullText, options: String.CompareOptions.caseInsensitive)
        
        let attribute = NSMutableAttributedString.init(string: fullText)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(hex: primaryColor) , range: range)
        attribute.addAttributes([NSAttributedString.Key.foregroundColor : UIColor(hex: darkTextColor),
                                  NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: isDeviceIPad ? 14.0 : 12.0)],range: rangeFull)
        
         attribute.addAttributes([NSAttributedString.Key.foregroundColor : UIColor(hex: primaryColor),
                                       NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: isDeviceIPad ? 14.0 : 12.0),
                                      NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue as Any],range: rangeSignUp)
        self.attributedText = attribute
    }
    
    func underLineText(fullText : String , changeText : String) {
        
        let strSignup = fullText
          let rangeSignUp = NSString(string: strSignup).range(of: changeText, options: String.CompareOptions.caseInsensitive)
          let rangeFull = NSString(string: strSignup).range(of: strSignup, options: String.CompareOptions.caseInsensitive)
          let attrStr = NSMutableAttributedString.init(string:strSignup)
          attrStr.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.white,
                                 NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: isDeviceIPad ? 14.0 : 12.0)],range: rangeFull)
          attrStr.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.white,
                                 NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: isDeviceIPad ? 16.0 : 14.0),
                                NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue as Any],range: rangeSignUp) // for swift 4 -> Change thick to styleThick
          self.attributedText = attrStr
    }
    
    func applyEffectToLabel(textCol: UIColor,text: String) {
        
        self.textColor = textCol
        self.text = nullStringToEmpty(string: text)
    }
}


class GradientLabel: UILabel {
var gradientColors: [CGColor] = []

override func drawText(in rect: CGRect) {
    if let gradientColor = drawGradientColor(in: rect, colors: gradientColors) {
        self.textColor = gradientColor
    }
    super.drawText(in: rect)
}

private func drawGradientColor(in rect: CGRect, colors: [CGColor]) -> UIColor? {
    let currentContext = UIGraphicsGetCurrentContext()
    currentContext?.saveGState()
    defer { currentContext?.restoreGState() }

    let size = rect.size
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                    colors: colors as CFArray,
                                    locations: nil) else { return nil }

    let context = UIGraphicsGetCurrentContext()
    context?.drawLinearGradient(gradient,
                                start: CGPoint(x: 0.0, y: 0.5),
                                end: CGPoint(x: size.width, y: 0.5),
                                options: [])
    let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    guard let image = gradientImage else { return nil }
    return UIColor(patternImage: image)
}
}
