//
//  ViewExtension.swift
//  User
//
//  Created by CSS on 17/01/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

enum Transition {
    
    case top
    case bottom
    case right
    case left
    
    var type : String {
        
        switch self {
            
        case .top :
            return CATransitionSubtype.fromBottom.rawValue
        case .bottom :
            return CATransitionSubtype.fromTop.rawValue
        case .right :
            return CATransitionSubtype.fromLeft.rawValue
        case .left :
            return CATransitionSubtype.fromRight.rawValue
            
        }
        
    }
    
}

enum Direction {
    case Top
    case Left
    case Right
    case Bottom
    
    var type : Int {
        
        switch self {
            
        case .Top :
            return 3
        case .Bottom :
            return 4
        case .Right :
            return 2
        case .Left :
            return 1
            
        }
        
    }

    
    
}

fileprivate var blurEffectViewGlobal : UIVisualEffectView?

extension UIView {
    
  

    func showAnimateView(_ view: UIView, isShow: Bool, direction: Direction, duration : Float = 0.8 ) {
            if isShow {
                view.isHidden = false
                self.bringSubviewToFront(view)
                print(direction.type)
                pushTransition(CFTimeInterval(duration), view: view, withDirection: direction.type)
                
                
            }
            else {
                self.sendSubviewToBack(view)
                view.isHidden = true
                pushTransition(CFTimeInterval(duration), view: view, withDirection: direction.type)
            }
        }
        
        
        
        
        func pushTransition(_ duration: CFTimeInterval, view: UIView, withDirection direction: Int) {
            let animation = CATransition()
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            animation.type = CATransitionType.push
            
            if direction == 1 {
                animation.subtype = CATransitionSubtype.fromRight
            }
            else if direction == 2 {
                animation.subtype = CATransitionSubtype.fromLeft
            }
            else if direction == 3 {
                animation.subtype = CATransitionSubtype.fromTop
            }
            else {
                animation.subtype = CATransitionSubtype.fromBottom
            }
            
            animation.duration = duration
            view.layer.add(animation, forKey: CATransitionType.moveIn.rawValue)
            
        }
        func show(with transition : Transition, duration : CFTimeInterval = 0.5, completion : (()->())?){
            
            
            let animation = CATransition()
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            animation.type = CATransitionType.push
            animation.subtype = CATransitionSubtype(rawValue: transition.type)
            animation.duration = duration
            self.layer.add(animation, forKey: CATransitionType.push.rawValue)
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                completion?()
            }
        }
        
        
    
    
    
    func dismissKeyBoardonTap(){
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.endEditingForce)))
        
    }
    
   @IBAction func endEditingForce(){
        
        self.endEditing(true)
        
    }
    
    
    // Hide and show in Dispatch Main thread
    
    func isHideInMainThread(_ isHide : Bool){
        
        DispatchQueue.main.async {
           
            if isHide {
                UIView.animate(withDuration: 0.1, animations: {
                     self.isHidden = isHide
                })
            } else {
                 self.isHidden = isHide
            }
            
        }
        
    }
    
    // Set Tint color
    
    @IBInspectable
    var tintColorId : Int {
        
        get {
           return self.tintColorId
        }
        set(newValue){
            self.tintColor = {
                
                if let color = Color.valueFor(id: newValue){
                    return color
                } else {
                    return tintColor
                }
                
            }()
        }
        
    }
    
    
   //Set background color
    
    @IBInspectable
    var backgroundColorId : Int {
        
        get {
            return self.backgroundColorId
        }
        set(newValue){
            self.backgroundColor = {
                
                if let color = Color.valueFor(id: newValue){
                    return color
                } else {
                    return backgroundColor
                }
                
            }()
        }
        
    }
    
    //Setting Corner Radius
    
    @IBInspectable
    var cornerRadius : CGFloat {
        
        get{
          return self.layer.cornerRadius
        }
        
        set(newValue) {
            self.layer.cornerRadius = newValue
        }
        
    }
    
    
    //MARK:- Setting bottom Line
    
    @IBInspectable
    var borderLineWidth : CGFloat {
        get {
            return self.layer.borderWidth
        }
        set(newValue) {
            self.layer.borderWidth = newValue
        }
    }
    
    
    //MARK:- Setting border color
    
    @IBInspectable
    var borderColor : UIColor {
        
        get {
            
            return UIColor(cgColor: self.layer.borderColor ?? UIColor.clear.cgColor)
        }
        set(newValue) {
            self.layer.borderColor = newValue.cgColor
        }
        
    }
    
    
    //MARK:- Shadow Offset
    
    @IBInspectable
    var offsetShadow : CGSize {
        
        get {
           return self.layer.shadowOffset
        }
        set(newValue) {
            self.layer.shadowOffset = newValue
        }
        
        
    }
    
    
    //MARK:- Shadow Opacity
    @IBInspectable
    var opacityShadow : Float {
        
        get{
            return self.layer.shadowOpacity
        }
        set(newValue) {
            self.layer.shadowOpacity = newValue
        }
        
    }
    
    //MARK:- Shadow Color
    @IBInspectable
    var colorShadow : UIColor? {
        
        get{
           return UIColor(cgColor: self.layer.shadowColor ?? UIColor.clear.cgColor)
        }
        set(newValue) {
            self.layer.shadowColor = newValue?.cgColor
        }
    }
    
    //MARK:- Shadow Radius
    @IBInspectable
    var radiusShadow : CGFloat {
        get {
             return self.layer.shadowRadius
        }
        set(newValue) {
            
           self.layer.shadowRadius = newValue
        }
    }
    
    //MARK:- Mask To Bounds
    
    @IBInspectable
    var maskToBounds : Bool {
        get {
            return self.layer.masksToBounds
        }
        set(newValue) {
            
            self.layer.masksToBounds = newValue
        }
    }
    
    
    //MARK:- Add Shadow with bezier path
    
    func addShadow(color : UIColor = .gray, opacity : Float = 0.5, offset : CGSize = CGSize(width: 0.5, height: 0.5), radius : CGFloat = 0.5, rasterize : Bool = true, maskToBounds : Bool = false){
        
        layer.masksToBounds = maskToBounds
        self.custom(layer: self.layer, opacity: opacity, offset: offset, color: color, radius: radius)
      //layer.shadowPath = UIBezierPath(rect: self.frame).cgPath
        layer.shouldRasterize = rasterize
        
    }
    
    //MARK:- Add shadow by beizer
    
    func addShadowBeizer() {
        
            
            let shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.bounds.width/2).cgPath
            shadowLayer.fillColor = UIColor.blue.cgColor
            shadowLayer.shadowPath = shadowLayer.path
        
          
            shadowLayer.shadowColor = UIColor.darkGray.cgColor
            shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            shadowLayer.shadowOpacity = 0.8
            shadowLayer.shadowRadius = 4
            
            self.layer.insertSublayer(shadowLayer, at: 0)
      
        
    }
    
    
    private func custom(layer customLayer : CALayer, opacity : Float, offset : CGSize, color : UIColor, radius : CGFloat){
        
        customLayer.shadowColor = color.cgColor
        customLayer.shadowOpacity = opacity
        customLayer.shadowOffset = offset
        customLayer.shadowRadius = radius
        
        
    }
  
    
    
    func addBlurview(with style : UIBlurEffect.Style = .dark, on completion : @escaping (()->Void)) {
        
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
       // blurEffectView.center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
        blurEffectView.frame = self.bounds
       // blurEffectView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
        
        let transition = CATransition()
        transition.duration = 1
        transition.type = CATransitionType.fade
        //transition.subtype = kCATransitionFade
        blurEffectView.layer.add(transition, forKey: kCATransition)
        blurEffectViewGlobal = blurEffectView
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            completion()
        }
    }
    
    func removeBlurView() {
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.fade
        blurEffectViewGlobal?.layer.add(transition, forKey: kCATransition)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
            blurEffectViewGlobal?.removeFromSuperview()
        }
    }
    
    //MARK:- Make View Round
    
    func makeRoundedCorner(){
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.bounds.width/2
        
    }
    
    //MARK:- Add Button Animation
    
    func addPressAnimation(with  duration : TimeInterval = 0.2 , transform : CGAffineTransform = CGAffineTransform(scaleX: 0.95, y: 0.95)) {
        
        UIView.animate(withDuration: duration, animations: {
            self.transform = transform
        }) { (bool) in
            UIView.animate(withDuration: duration, animations: {
                self.transform = .identity
            })
        }
    }
    
    
}


extension UIView {
    
    func applyEffectToView() {
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor(hex: "#FF1F2D").cgColor
        self.layer.borderWidth = 0.5
        self.backgroundColor = .clear
        self.layer.cornerRadius = 8
    }
    
    
    func setCornerRadius(cornerR: Int = 8) {
        
        self.maskToBounds = true
        self.layer.cornerRadius = cornerR
        self.maskToBounds = true
    }
    
   
    
    
    func setCirclerCornerRadius() {
        
        self.maskToBounds = true
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
    
    func applyShadow(radius: CGFloat = 8.0) {
        
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 1
        self.layer.shadowColor = UIColor(hex: "#0000001A").cgColor.copy(alpha: 0.15)
        self.backgroundColor = UIColor(hex: "#FFFFFF")
        self.layer.cornerRadius = radius
        self.layer.shadowOffset = CGSize(width: 0 , height:1)
    }
    
    
    func setGradientBackgroundForView() {
              DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                  let gradientLayer = CAGradientLayer()
                  gradientLayer.frame = self.bounds
                  let color0 = UIColor(hex: "#E30000").cgColor
                  let color1 = UIColor(hex: "#CC4343").cgColor
                  gradientLayer.colors = [color0,color1]
                  gradientLayer.locations = [0.0,1.0]
                  gradientLayer.startPoint =  CGPoint(x: 0.0, y: 1.0)
                  gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
                 
                 
                  self.layer.insertSublayer(gradientLayer, at: 0)
              }
          }
    
    func setGradientBackgroundForCornerRadiusView() {
                 DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                     let gradientLayer = CAGradientLayer()
                     gradientLayer.frame = self.bounds
                     let color0 = UIColor(hex: "#E30000").cgColor
                     let color1 = UIColor(hex: "#CC4343").cgColor
                     gradientLayer.colors = [color0,color1]
                     gradientLayer.locations = [0.0,1.0]
                     gradientLayer.startPoint =  CGPoint(x: 0.0, y: 1.0)
                     gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
                     gradientLayer.cornerRadius = 8
                    gradientLayer.masksToBounds = true
                     self.layer.insertSublayer(gradientLayer, at: 0)
                 }
             }
    
    
    func setGradientBackgroundForViewWithTrans() {
                 DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                     let gradientLayer = CAGradientLayer()
                     gradientLayer.frame = self.bounds
                    let color0 = UIColor(hex: "#E30000").cgColor.copy(alpha: 0.29)
                     let color1 = UIColor(hex: "#CC4343").cgColor.copy(alpha: 0.29)
                     gradientLayer.colors = [color0,color1]
                     gradientLayer.locations = [0.0,1.0]
                     gradientLayer.startPoint =  CGPoint(x: 0.0, y: 1.0)
                     gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
                     self.layer.insertSublayer(gradientLayer, at: 0)
                 }
             }
}
