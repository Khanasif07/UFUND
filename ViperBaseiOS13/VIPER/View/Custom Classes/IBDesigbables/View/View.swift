//
//  View.swift
//  User
//
//  Created by imac on 12/31/17.
//  Copyright © 2017 Appoets. All rights reserved.
//

import UIKit

@IBDesignable
class View: UIView {
    
    let gl = CAGradientLayer()
    
    
    
//    //Mask to Bounds
//
//    @IBInspectable
//    var maskToBounds : Bool = false {
//        didSet{
//            self.layer.masksToBounds = maskToBounds
//        }
//    }
//
    
    
    
    //MARK:- Make Rounded Corner
    @IBInspectable
    var isRoundedCorner : Bool = false {
        
        didSet {
            
            if isRoundedCorner {
                self.layer.masksToBounds = true
                self.layer.cornerRadius = self.frame.height/2
            }
        }
        
    }
    
    
    //MARK:- Blur Effect
    
    @IBInspectable
    var isBlurred : Bool = false {
        
        didSet {
            
            if isBlurred {
                
                let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
                visualEffectView.frame = CGRect(origin: CGPoint.zero, size: frame.size)
                self.addSubview(visualEffectView)
                
            }
            
        }
    }
    
   
    //MARK:- Navigation Bar
    
    @IBInspectable
    var isNavigationBar :Bool = false {
        
        didSet {
            
            if isNavigationBar {
                
                self.backgroundColor = UIColor.primary
                
            }
            
        }
        
    }
    
    //MARK:- Bottom Line
    
    @IBInspectable
    var bottomlineHeight : CGFloat = 0{
        
        didSet{
            addSubLayer()
        }
        
    }
    
    
    //MARK:- Bottom line color
    
    @IBInspectable
    var bottomLineColor : UIColor = .white{
        
        didSet{
            addSubLayer()
        }
        
    }
    
    //MARK:- Is Bottom Line Inverted
    
    @IBInspectable
    var isBottomLineInverted : Bool = false {
        
        didSet{
            addSubLayer()
        }
    }
    

    
    // Add Corner Radius Partially
    
    var corner = UIRectCorner()
    
    @IBInspectable
    var isTopRightClipped : Bool = false {
        didSet{
            add(rectCorner: .topRight, isAdd: isTopRightClipped)
        }
    }
    @IBInspectable
    var isBottomRightClipped : Bool = false {
        didSet{
           add(rectCorner: .bottomRight, isAdd: isBottomRightClipped)
        }
    }
    @IBInspectable
    var isTopLeftClipped : Bool = false {
        didSet{
           add(rectCorner: .topLeft, isAdd: isTopLeftClipped)
        }
    }
    @IBInspectable
    var isBottomLeftClipped : Bool = false {
        didSet{
           add(rectCorner: .bottomLeft, isAdd: isBottomLeftClipped)
        }
    }
    
    // Add Corners
    private func add(rectCorner : UIRectCorner, isAdd : Bool){
        
        if isAdd{
            corner.insert(rectCorner)
        }else {
            corner.remove(rectCorner)
        }
        
        
        let path = UIBezierPath(roundedRect:self.bounds,
                                byRoundingCorners: corner,
                                cornerRadii: offsetShadow)
        
        let maskLayer = CAShapeLayer()
        
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
        
    }
    

    
    // Adding Bottom Line
    private func addSubLayer(){
        
        let layer = CALayer()
        layer.frame = CGRect(origin: CGPoint(x: 0, y: isBottomLineInverted ?(self.bounds.height-bottomlineHeight) : 0), size: CGSize(width: self.bounds.width, height: bottomlineHeight))
        layer.backgroundColor = bottomLineColor.cgColor
        self.layer.addSublayer(layer)
        layer.contentsGravity = CALayerContentsGravity.resizeAspectFill
        
    }
    
    
    
    
}

public func applyShadowView(view: UIView) {
    
    view.layer.masksToBounds = false
    view.layer.shadowRadius = 2
    view.layer.shadowOpacity = 1
    view.layer.shadowColor = shadowColor.cgColor.copy(alpha: 0.25)
    view.layer.shadowOffset = CGSize(width: 0 , height:1)
}




@IBDesignable
class GradientView: UIView {
    
    @IBInspectable var firstColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var secondColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }

    @IBInspectable var isHorizontal: Bool = true {
        didSet {
            updateView()
        }
    }
    
    override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    
    func updateView() {
        let layer = self.layer as! CAGradientLayer
        layer.colors = [firstColor, secondColor].map {$0.cgColor}
        if (isHorizontal) {
            layer.startPoint = CGPoint(x: 0, y: 0.5)
            layer.endPoint = CGPoint (x: 1, y: 0.5)
        } else {
            layer.startPoint = CGPoint(x: 0.5, y: 0)
            layer.endPoint = CGPoint (x: 0.5, y: 1)
        }
    }
    
}
