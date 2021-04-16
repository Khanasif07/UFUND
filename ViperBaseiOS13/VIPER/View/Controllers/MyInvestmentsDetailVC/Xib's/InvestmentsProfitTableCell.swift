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
