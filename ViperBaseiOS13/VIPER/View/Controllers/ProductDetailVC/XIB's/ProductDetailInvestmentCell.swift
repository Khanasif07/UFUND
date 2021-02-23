//
//  ProductDetailInvestmentCell.swift
//  ViperBaseiOS13
//
//  Created by Admin on 19/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//
import UIKit

class ProductDetailInvestmentCell: UITableViewCell {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var progressValue: UILabel!
    @IBOutlet weak var progressView: CircularProgressBar!
    @IBOutlet weak var overAllInvestmentLbl: UILabel!
    
    // MARK: - Variables
    //===========================
    var progressPercentageValue: Double = 0.0
    
    // MARK: - Lifecycle
    //===========================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupProgressView()
    }
    
    private func setupProgressView(){
           self.progressView.safePercent     = 100
           self.progressView.backgroundColor = .clear
           self.progressView.starttAngle     = (-CGFloat.pi/2)
        self.progressView.lineWidth       = (self.width*25)/375
           self.progressView.labelPercent.isHidden = true
           self.progressView.label.isHidden        = true
           self.progressView.lineBackgroundColor   = UIColor.rgb(
               r: 255,
               g: 245,
               b: 231)
        self.progressView.drawDropShadow(color: UIColor.black16)
           self.progressView.startGradientColor    = UIColor.rgb(
               r: 255,
               g: 31,
               b: 45
           ).withAlphaComponent(0.75)
           self.progressView.endGradientColor      = UIColor.rgb(
               r: 255,
               g: 31,
               b: 45)
        delay(seconds: 1.0) {
            self.progressView.setProgress(to: self.progressPercentageValue / 100, withAnimation: true)
           }
       }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - IBActions
    //===========================
    
    
}
