//
//  DashboardInvestmentCell.swift
//  ViperBaseiOS13
//
//  Created by Admin on 23/03/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit

class DashboardInvestmentCell: UITableViewCell {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var cryptoPercentageValue: UILabel!
    @IBOutlet weak var dollarPercentageValue: UILabel!
    @IBOutlet weak var cryptoInvestmentValue: UILabel!
    @IBOutlet weak var progessBar: CircularProgressBar!
    @IBOutlet weak var dollarInvestmentValue: UILabel!
    
    // MARK: - Variables
    //===========================
    var progressPercentageValue: Double = 45.0
    
    // MARK: - Lifecycle
    //===========================
    override func awakeFromNib() {
        super.awakeFromNib()
        setupProgressView()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dataContainerView.addShadowRounded(cornerRadius: 5, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 5)
    }
    
    private func setupProgressView(){
        self.progessBar.safePercent     = 100
        self.progessBar.backgroundColor = .clear
        self.progessBar.starttAngle     = (-CGFloat.pi/2)
        self.progessBar.lineWidth       = (self.width*25)/375
        self.progessBar.labelPercent.isHidden = true
        self.progessBar.label.isHidden        = true
        self.progessBar.lineBackgroundColor   = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        self.progessBar.drawDropShadow(color: UIColor.black16)
        self.progessBar.startGradientColor    = #colorLiteral(red: 0.145618856, green: 0.6819573045, blue: 0.3444642127, alpha: 0.75)
        self.progessBar.endGradientColor      = #colorLiteral(red: 0.145618856, green: 0.6819573045, blue: 0.3444642127, alpha: 1)
        delay(seconds: 1.0) {
            self.progessBar.setProgress(to: self.progressPercentageValue / 100, withAnimation: true)
        }
    }
    
    // MARK: - IBActions
    //===========================
    
    
}
