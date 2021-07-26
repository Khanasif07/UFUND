//
//  AssetsSupplyTableCell.swift
//  ViperBaseiOS13
//
//  Created by Admin on 15/04/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit
import Charts

class AssetsSupplyTableCell: UITableViewCell,ChartViewDelegate {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var totalSoldTitlelbl: UILabel!
    @IBOutlet weak var totalRemTitleLbl: UILabel!
    @IBOutlet weak var myTokentitleLbl: UILabel!
    @IBOutlet weak var totalSupplyTitleLbl: UILabel!
    @IBOutlet weak var totalSupplyPieChartLbl: UILabel!
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var dataContainerVIew: UIView!
    @IBOutlet weak var totalRemainingLbl: UILabel!
    @IBOutlet weak var totalSupplyLbl: UILabel!
    @IBOutlet weak var totalRemainingPerLbl: UILabel!
    @IBOutlet weak var totalSoldLbl: UILabel!
    @IBOutlet weak var totalSoldPerLbl: UILabel!
    @IBOutlet weak var myTokenLbl: UILabel!
    @IBOutlet weak var myTokenPerLbl: UILabel!
    @IBOutlet weak var myTokenStackView: UIStackView!
    
    // MARK: - Variables
    //===========================
    var parties = ["","",""]
    var partiesPercentage = [0.0]
    
    
    // MARK: - Lifecycle
    //===========================
    override func awakeFromNib() {
        super.awakeFromNib()
        totalSupplyPieChartLbl.font =  isDeviceIPad ? .setCustomFont(name: .bold, size: .x20) : .setCustomFont(name: .bold, size: .x16)
        [totalSoldTitlelbl,totalRemTitleLbl,totalSupplyTitleLbl].forEach { (lbl) in
            lbl.font = isDeviceIPad ? .setCustomFont(name: .regular, size: .x16) : .setCustomFont(name: .regular, size: .x12)
        }
        [totalSupplyLbl,myTokenLbl,totalRemainingLbl,totalSoldLbl].forEach { (lbl) in
            lbl.font = isDeviceIPad ? .setCustomFont(name: .semiBold, size: .x18) : .setCustomFont(name: .semiBold, size: .x14)
        }
        self.setupProgressView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    public func configureCellForInvestor(model: ProductModel){
        let totalSupply = model.tokensupply ?? 0
        if totalSupply != 0 {
        let totalRemaining = model.avilable_token ?? 0
//        let myTokenValue = model.tokenvalue ?? 0.0
        let soldAssets = (totalSupply) - (totalRemaining)
        let soldPerValue = ((soldAssets * 100) / totalSupply)
//        let myTokenValuePer = ((myTokenValue * 100) / Double(totalSupply))
        let totalRemainingPerValue = ((totalRemaining * 100) / totalSupply)
        self.totalSupplyLbl.text = "\(totalSupply)"
        self.totalSupplyPieChartLbl.text = "\(totalSupply)"
        self.totalRemainingLbl.text = "\(totalRemaining)"
        self.totalSoldLbl.text = "\(soldAssets)"
        self.totalSoldPerLbl.text = "(\(soldPerValue)" + "%)"
        self.totalRemainingPerLbl.text = "(\(totalRemainingPerValue)" + "%)"
//        self.myTokenLbl.text =  "\(myTokenValue)"
//        self.myTokenPerLbl.text = "(\(myTokenValuePer)" + "%)"
//        self.partiesPercentage = [Double(soldAssets),Double(totalRemaining),Double(myTokenValue)]
        self.partiesPercentage = [Double(soldAssets),Double(totalRemaining)]
        self.partiesPercentage.removeAll(where: {$0 == 0.0})
        self.setDataCount(partiesPercentage.endIndex, range: 100)
        }else {
            self.setDataCount(partiesPercentage.endIndex, range: 100)
        }
    }
    
    public func configureCellForCampaigner(model: Asset,productModel: ProductModel){
        let totalSupply = productModel.tokensupply ?? 0
        if totalSupply != 0 {
            let totalRemaining = productModel.avilable_token ?? 0
            let myTokenValue = productModel.user_product?.amount ?? 0
            let soldAssets = (totalSupply) - (totalRemaining) - (myTokenValue)
            let soldPerValue = ((soldAssets * 100) / totalSupply)
            let myTokenValuePer = ((myTokenValue * 100) / totalSupply)
            let totalRemainingPerValue = ((totalRemaining * 100) / totalSupply)
            self.totalSupplyLbl.text = "\(totalSupply)"
            self.totalSupplyPieChartLbl.text = "\(totalSupply)"
            self.totalRemainingLbl.text = "\(totalRemaining)"
            self.totalSoldLbl.text = "\(soldAssets)"
            self.totalSoldPerLbl.text = "(\(soldPerValue)" + "%)"
            self.totalRemainingPerLbl.text = "(\(totalRemainingPerValue)" + "%)"
            self.myTokenLbl.text =  "\(myTokenValue)"
            self.myTokenPerLbl.text = "(\(myTokenValuePer)" + "%)"
            self.partiesPercentage = [Double(soldAssets),Double(totalRemaining),Double(myTokenValue)]
            self.partiesPercentage.removeAll(where: {$0 == 0.0})
            self.setDataCount(partiesPercentage.endIndex, range: 100)
        } else {
            self.setDataCount(partiesPercentage.endIndex, range: 100)
        }
    }
    
     private func setupProgressView(){
           pieChartView.delegate = self
           pieChartView.legend.enabled = false

           // entry label styling
           pieChartView.drawEntryLabelsEnabled = false
           pieChartView.entryLabelColor = .yellow
           pieChartView.usePercentValuesEnabled = true
           pieChartView.entryLabelFont = .systemFont(ofSize: 12, weight: .bold)
           pieChartView.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
          self.setDataCount(partiesPercentage.endIndex, range: 100)
       }
       
       func setDataCount(_ count: Int, range: UInt32) {
           let entries = (0..<count).map { (i) -> PieChartDataEntry in
               // IMPORTANT: In a PieChart, no values (Entry) should have the same xIndex (even if from different DataSets), since no values can be drawn above each other.
               return PieChartDataEntry(value: partiesPercentage[i],
                                        label: parties[i % parties.count],
                                        icon: #imageLiteral(resourceName: "icEarningInCryptoBg"))
           }
           
           let set = PieChartDataSet(entries: entries, label: "")
           set.drawIconsEnabled = false
           set.sliceSpace = 1
           
           
           set.colors = [#colorLiteral(red: 0.09019607843, green: 0.6705882353, blue: 0.3568627451, alpha: 1),#colorLiteral(red: 0.9490196078, green: 0.7725490196, blue: 0.137254902, alpha: 1),#colorLiteral(red: 1, green: 0.1215686275, blue: 0.1764705882, alpha: 1)]
           
           let data = PieChartData(dataSet: set)
           
           let pFormatter = NumberFormatter()
           pFormatter.numberStyle = .percent
           pFormatter.maximumFractionDigits = 1
           pFormatter.multiplier = 1
           pFormatter.percentSymbol = " %"
           data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
           
        data.setValueFont(isDeviceIPad  ? .setCustomFont(name: .bold, size: .x16) : .setCustomFont(name: .bold, size: .x12))
           
           pieChartView.data = data
           pieChartView.highlightValues(nil)
       }
       
    
}
