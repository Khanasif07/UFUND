//
//  CustomCircularBar.swift
//  ViperBaseiOS13
//
//  Created by Admin on 23/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import Foundation
import UIKit


class CircularProgressBar: UIView {
    
    //MARK: awakeFromNib
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        label.text = "0"
        labelPercent.text = "%"
    }
    
    
    //MARK: Public
    public var startGradientColor: UIColor = UIColor.blue
    public var endGradientColor: UIColor = UIColor.white
    
    public var starttAngle : CGFloat = 0
    
    public var lineWidth:CGFloat = 15.0 {
        didSet{
            foregroundLayer.lineWidth = lineWidth
            backgroundLayer.lineWidth = lineWidth - (0.20 * lineWidth)
        }
    }
    
    public var labelSize: CGFloat = 25.0 {
        didSet {
            label.font = UIFont.systemFont(ofSize: 25.0)
            label.sizeToFit()
            configLabel()
        }
    }
    
    public var labelPercentSize: CGFloat = 25.0 {
        didSet {
            labelPercent.font = UIFont.systemFont(ofSize: 25.0)
            labelPercent.sizeToFit()
            configLabelPercent()
        }
    }
      
    
    private func configLabelPercent(){
        labelPercent.textColor = UIColor.black
        labelPercent.sizeToFit()
        labelPercent.center = CGPoint(x: pathCenter.x + (label.frame.size.width/2), y: pathCenter.y )
    }
    
    
    private func makeLabelPercent(withText text: String) -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        label.text = text
        label.font = UIFont.systemFont(ofSize: 25.0)
        label.sizeToFit()
        label.textColor = UIColor.black
        label.center = CGPoint(x: pathCenter.x + (label.frame.size.width/2) + 10, y: pathCenter.y - 10.0)
        return label
    }
    
    public var safePercent: Int = 100 {
        didSet{
            setForegroundLayerColorForSafePercent()
        }
    }
    
    public var wholeCircleAnimationDuration: Double = 2
    
    public var lineBackgroundColor: UIColor = .gray
    public var lineColor: UIColor = .red
    public var lineFinishColor: UIColor = .green
    
    
    public func setProgress(to progressConstant: Double, withAnimation: Bool) {
        
        var progress: Double {
            get {
                if progressConstant > 1 { return 1 }
                else if progressConstant < 0 { return 0 }
                else { return progressConstant }
            }
        }
        
        
        foregroundLayer.strokeEnd = CGFloat(progress)
        
        if withAnimation {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = 0
            animation.toValue = progress
            animation.duration = 2.0
            foregroundLayer.add(animation, forKey: "foregroundAnimation")
            
        }
        
        var currentTime:Double = 0
        let timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { (timer) in
            if currentTime >= 2.0 {
                timer.invalidate()
            } else {
                currentTime += 0.05
                let percent = currentTime / 2.0 * 100
                self.label.text = "\(Int(progress * percent))"
                self.setForegroundLayerColorForSafePercent()
                self.configLabel()
                self.configLabelPercent()
            }
        }
        timer.fire()
        
    }
    
    
    
    
    //MARK: Private
    var label = UILabel()
    var labelPercent = UILabel()
    private var gradientLayer: CAGradientLayer!
    private let foregroundLayer = CAShapeLayer()
    private let backgroundLayer = CAShapeLayer()
    private var radius: CGFloat {
        get{
            if self.frame.width < self.frame.height { return (self.frame.width - lineWidth)/2 }
            else { return (self.frame.height - lineWidth)/2 }
        }
    }
    
    private var pathCenter: CGPoint{
        get{ return self.convert(self.center, from:self.superview) }
    }
    
    private func makeBar(){
        self.layer.sublayers = nil
        drawBackgroundLayer()
        drawForegroundLayer()
    }
    
    private func drawBackgroundLayer() {
        let path = UIBezierPath(arcCenter: pathCenter, radius: self.radius, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        self.backgroundLayer.path = path.cgPath
        self.backgroundLayer.strokeColor = lineBackgroundColor.cgColor
        self.backgroundLayer.lineWidth = lineWidth
        self.backgroundLayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(backgroundLayer)
        
    }
    
    private func drawForegroundLayer(){
        
        let startAngle = starttAngle
        let endAngle = 2 * CGFloat.pi + startAngle
        
        let path = UIBezierPath(arcCenter: pathCenter, radius: self.radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        foregroundLayer.lineCap = CAShapeLayerLineCap.round
        foregroundLayer.path = path.cgPath
        foregroundLayer.lineWidth = lineWidth
        foregroundLayer.fillColor = UIColor.clear.cgColor
        foregroundLayer.strokeColor = lineColor.cgColor
        foregroundLayer.strokeEnd = 0
        
        gradientLayer = CAGradientLayer()
        gradientLayer.colors = [startGradientColor.cgColor, endGradientColor.cgColor]
        gradientLayer.frame = CGRect.init(x: 0, y: 0, width: self.width, height: self.height)
        gradientLayer.mask = foregroundLayer
        
        self.layer.addSublayer(gradientLayer)
        
    }
    
    private func makeLabel(withText text: String) -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        label.text = text
        label.font = UIFont.systemFont(ofSize: 25.0)
        label.sizeToFit()
        label.center = pathCenter
        return label
    }
    
    private func configLabel(){
        label.sizeToFit()
        label.center = CGPoint(x: pathCenter.x - 10, y: pathCenter.y)
    }
    
  
    
    private func setForegroundLayerColorForSafePercent(){
        if Int(label.text ?? "0")! >= self.safePercent {
            self.foregroundLayer.strokeColor = lineFinishColor.cgColor
        } else {
            self.foregroundLayer.strokeColor = lineColor.cgColor
        }
    }
    
    private func setupView() {
        makeBar()
        self.addSubview(label)
        self.addSubview(labelPercent)
    }
    
    
    
    //Layout Sublayers

    private var layoutDone = false
    override func layoutSublayers(of layer: CALayer) {
        if !layoutDone {
            let tempText = label.text
            setupView()
            label.text = tempText
            layoutDone = true
        }
    }
    
}


extension UIView{
    var width: CGFloat {
           get { return self.frame.size.width }
           set { self.frame.size.width = newValue }
       }
       var height: CGFloat {
           get { return self.frame.size.height }
           set { self.frame.size.height = newValue }
       }
}
