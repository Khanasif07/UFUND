//
//  CustomDashedView.swift
//  ViperBaseiOS13
//
//  Created by Admin on 06/04/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import Foundation
import UIKit

class RectangularDashedView: UIView {
    

    @IBInspectable var dashWidth: CGFloat = 1.00
    @IBInspectable var dashColor: UIColor = #colorLiteral(red: 0.3294117647, green: 0.337254902, blue: 0.3607843137, alpha: 0.5)
    @IBInspectable var dashLength: CGFloat = 8.0
    @IBInspectable var betweenDashesSpace: CGFloat = 5.0
    
    var dashBorder: CAShapeLayer?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dashBorder?.removeFromSuperlayer()
        let dashBorder = CAShapeLayer()
        dashBorder.lineWidth = dashWidth
        dashBorder.strokeColor = dashColor.cgColor
        dashBorder.lineDashPattern = [dashLength, betweenDashesSpace] as [NSNumber]
        dashBorder.frame = bounds
        
        dashBorder.fillColor = nil
        if cornerRadius > 0 {
            dashBorder.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        } else {
            dashBorder.path = UIBezierPath(rect: bounds).cgPath
        }
        layer.addSublayer(dashBorder)
        self.dashBorder = dashBorder
    }
}

