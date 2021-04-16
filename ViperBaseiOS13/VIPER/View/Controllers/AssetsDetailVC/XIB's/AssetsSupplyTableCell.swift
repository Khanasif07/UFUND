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
    @IBOutlet weak var totalSupplyPieChartLbl: UILabel!
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var dataContainerVIew: UIView!
    @IBOutlet weak var totalRemainingLbl: UILabel!
    @IBOutlet weak var totalSupplyLbl: UILabel!
    @IBOutlet weak var totalRemainingPerLbl: UILabel!
    @IBOutlet weak var totalSoldLbl: UILabel!
    @IBOutlet weak var totalSoldPerLbl: UILabel!
    
    // MARK: - Variables
    //===========================
    var parties = ["",""]
    var partiesPercentage = [0.50,0.50]
    
    
    // MARK: - Lifecycle
    //===========================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupProgressView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    public func configureCellForInvestor(model: ProductModel){
        let soldAssets = (model.tokenrequest?.tokensupply ?? 0) - (model.tokenrequest?.avilable_token ?? 0)
        let totalSupply = model.tokenrequest?.tokensupply ?? 0
        let totalRemaining = model.tokenrequest?.avilable_token ?? 0
        let soldPerValue = ((soldAssets * 100) / totalSupply)
        let totalRemainingPerValue = ((totalRemaining * 100) / totalSupply)
        self.totalSupplyLbl.text = "\(totalSupply)"
        self.totalSupplyPieChartLbl.text = "\(totalSupply)"
        self.totalRemainingLbl.text = "\(totalRemaining)"
        self.totalSoldLbl.text = "\(soldAssets)"
        self.totalSoldPerLbl.text = "(\(soldPerValue)" + "%)"
        self.totalRemainingPerLbl.text = "(\(totalRemainingPerValue)" + "%)"
        self.partiesPercentage = [Double(soldAssets),Double(totalRemaining)]
        self.partiesPercentage.removeAll(where: {$0 == 0.0})
        self.setDataCount(partiesPercentage.endIndex, range: 100)
    }
    
    public func configureCellForCampaigner(model: Asset){
        let soldAssets = (model.tokensupply ?? 0) - (model.avilable_token ?? 0)
           let totalSupply = model.tokensupply ?? 0
           let totalRemaining = model.avilable_token ?? 0
           let soldPerValue = ((soldAssets * 100) / totalSupply)
           let totalRemainingPerValue = ((totalRemaining * 100) / totalSupply)
           self.totalSupplyLbl.text = "\(totalSupply)"
           self.totalSupplyPieChartLbl.text = "\(totalSupply)"
           self.totalRemainingLbl.text = "\(totalRemaining)"
           self.totalSoldLbl.text = "\(soldAssets)"
           self.totalSoldPerLbl.text = "(\(soldPerValue)" + "%)"
           self.totalRemainingPerLbl.text = "(\(totalRemainingPerValue)" + "%)"
           self.partiesPercentage = [Double(soldAssets),Double(totalRemaining)]
           self.partiesPercentage.removeAll(where: {$0 == 0.0})
           self.setDataCount(partiesPercentage.endIndex, range: 100)
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
           self.setDataCount(2, range: 100)
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
           
           
           set.colors = [#colorLiteral(red: 0.09019607843, green: 0.6705882353, blue: 0.3568627451, alpha: 1),#colorLiteral(red: 0.9490196078, green: 0.7725490196, blue: 0.137254902, alpha: 1)]
           
           let data = PieChartData(dataSet: set)
           
           let pFormatter = NumberFormatter()
           pFormatter.numberStyle = .percent
           pFormatter.maximumFractionDigits = 1
           pFormatter.multiplier = 1
           pFormatter.percentSymbol = " %"
           data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
           
           data.setValueFont(.systemFont(ofSize: 12, weight: .semibold))
           data.setValueTextColor(.white)
           
           pieChartView.data = data
           pieChartView.highlightValues(nil)
       }
       
    
}
