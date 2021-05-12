//
//  DashboardInvestmentCell.swift
//  ViperBaseiOS13
//
//  Created by Admin on 23/03/21.
//  Copyright © 2021 CSS. All rights reserved.
//
import Charts
import UIKit

class DashboardInvestmentCell: UITableViewCell, ChartViewDelegate {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var allMyInvestTitleLbl: UILabel!
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var cryptoPercentageValue: UILabel!
    @IBOutlet weak var investCryptoTitleLbl: UILabel!
    @IBOutlet weak var investDollarTitleLbl: UILabel!
    @IBOutlet weak var dollarPercentageValue: UILabel!
    @IBOutlet weak var cryptoInvestmentValue: UILabel!
    @IBOutlet weak var dollarInvestmentValue: UILabel!
    
    // MARK: - Variables
    //===========================
    var parties = ["",""]
    var partiesPercentage = [25.0,0.0]{
        didSet{
            self.partiesPercentage.removeAll(where: {$0 == 0.0})
            self.setDataCount(partiesPercentage.endIndex, range: 100)
        }
    }
    
    // MARK: - Lifecycle
    //===========================
    override func awakeFromNib() {
        super.awakeFromNib()
        [investCryptoTitleLbl,investDollarTitleLbl].forEach { (lbl) in
            lbl.font  = isDeviceIPad ? .setCustomFont(name: .regular, size: .x16) : .setCustomFont(name: .regular, size: .x12)
        }
        [cryptoInvestmentValue,dollarInvestmentValue].forEach { (lbl) in
            lbl.font  = isDeviceIPad ? .setCustomFont(name: .bold, size: .x22) : .setCustomFont(name: .bold, size: .x18)
        }
        self.allMyInvestTitleLbl.font  = isDeviceIPad ? .setCustomFont(name: .semiBold, size: .x20) : .setCustomFont(name: .semiBold, size: .x16)
        setupProgressView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dataContainerView.addShadowRounded(cornerRadius: 5, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 5)
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
        
        
        set.colors = [#colorLiteral(red: 0.1647058824, green: 0.7450980392, blue: 0.7843137255, alpha: 1),#colorLiteral(red: 0.5294117647, green: 0.262745098, blue: 0.9137254902, alpha: 1)]
        
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
    
    // MARK: - IBActions
    //===========================
    
    
}

