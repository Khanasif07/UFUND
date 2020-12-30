//
//  TextViewExtension.swift
//  GoJekUser
//
//  Created by Ansar on 05/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit


class RoundedTextView: UITextView {
    
    var roundCorners: UIRectCorner!
    
    override func draw(_ rect: CGRect) {
        
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: roundCorners, cornerRadii: CGSize(width: 15.0, height: 15.0))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
}

extension UITextView {
    
    func newHeight(withBaseHeight baseHeight: CGFloat) -> CGFloat {
        
        // Calculate the required size of the textview
        let fixedWidth = frame.size.width
        let newSize = sizeThatFits(CGSize(width: fixedWidth, height: .greatestFiniteMagnitude))
        var newFrame = frame
        
        // Height is always >= the base height, so calculate the possible new height
        let height: CGFloat = newSize.height > baseHeight ? newSize.height : baseHeight
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: height)
        
        return newFrame.height
    }
    
    class func RoundCornorTextView(backgroundColor: UIColor, textColor: UIColor, textFont: UIFont, roundCorners: UIRectCorner) -> UITextView {
        
        let textView = RoundedTextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = backgroundColor
        textView.textColor = textColor
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.roundCorners = roundCorners
        textView.font = textFont
        return textView
    }
    
    class func CommonTextView(backgroundColor: UIColor, textColor: UIColor, textFont: UIFont) -> UITextView {
        
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = backgroundColor
        textView.textColor = textColor
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.font = textFont
        return textView
    }
    
    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
    
}


