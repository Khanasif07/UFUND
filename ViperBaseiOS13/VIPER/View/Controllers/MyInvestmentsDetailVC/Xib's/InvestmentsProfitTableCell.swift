//
//  InvestmentsProfitTableCell.swift
//  ViperBaseiOS13
//
//  Created by Admin on 08/03/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit

class InvestmentsProfitTableCell: UITableViewCell {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var totalEarnTitleLbl: UILabel!
    @IBOutlet weak var netProfileTitleLbl: UILabel!
    @IBOutlet weak var youEarnedTitlelbl: UILabel!
    @IBOutlet weak var yourInvestTitlelbl: UILabel!
    @IBOutlet weak var yourInvAndProfileTitlelbl: UILabel!
    @IBOutlet weak var progressValue: UILabel!
    @IBOutlet weak var progressView: CircularProgressBar!
    @IBOutlet weak var yourInvestmentValueLbl: UILabel!
    @IBOutlet weak var yourInvestmentPercentageLbl: UILabel!
    @IBOutlet weak var newProfitPercentageLbl: UILabel!
    @IBOutlet weak var netProfitValueLbl: UILabel!
    @IBOutlet weak var yourEarnedValueLbl: UILabel!
    
    // MARK: - Variables
    //===========================
    var progressPercentageValue: Double = 0.0{
        didSet{
             self.progressView.setProgress(to: self.progressPercentageValue / 100, withAnimation: true)
        }
    }
    
    // MARK: - Lifecycle
    //===========================
    override func awakeFromNib() {
        super.awakeFromNib()
        progressValue.font  =  isDeviceIPad ? .setCustomFont(name: .bold, size: .x28) : .setCustomFont(name: .bold, size: .x24)
        yourInvAndProfileTitlelbl.font =  isDeviceIPad ? .setCustomFont(name: .medium, size: .x20) : .setCustomFont(name: .medium, size: .x16)
        [netProfileTitleLbl,youEarnedTitlelbl,yourInvestTitlelbl,totalEarnTitleLbl].forEach { (lbl) in
            lbl.font = isDeviceIPad ? .setCustomFont(name: .regular, size: .x16) : .setCustomFont(name: .regular, size: .x12)
        }
        [yourInvestmentValueLbl,yourEarnedValueLbl,netProfitValueLbl].forEach { (lbl) in
            lbl.font = isDeviceIPad ? .setCustomFont(name: .semiBold, size: .x18) : .setCustomFont(name: .semiBold, size: .x14)
        }
        self.setupProgressView()
    }
    
    func configureCell(model: ProductModel){
        let youEarned = (model.invested_amount ?? 0.0) + (model.earnings ?? 0.0)
        self.yourInvestmentValueLbl.text = "\(model.invested_amount ?? 0.0)"
        self.yourEarnedValueLbl.text = "\(youEarned)"
        self.progressValue.text = "\(progressPercentageValue)" + "%"
        self.netProfitValueLbl.text = "\((model.earnings ?? 0.0))"
    }
    
    private func setupProgressView(){
        self.progressView.safePercent     = 100
        self.progressView.backgroundColor = .clear
        self.progressView.starttAngle     = (-CGFloat.pi/2)
        self.progressView.lineWidth       = (self.width*25)/375
        self.progressView.labelPercent.isHidden = true
        self.progressView.label.isHidden        = true
        self.progressView.lineBackgroundColor   = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        self.progressView.drawDropShadow(color: UIColor.black16)
        self.progressView.startGradientColor    = #colorLiteral(red: 0.145618856, green: 0.6819573045, blue: 0.3444642127, alpha: 0.75)
        self.progressView.endGradientColor      = #colorLiteral(red: 0.145618856, green: 0.6819573045, blue: 0.3444642127, alpha: 1)
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
