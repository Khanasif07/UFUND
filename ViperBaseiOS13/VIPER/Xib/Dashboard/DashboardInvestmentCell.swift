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
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var cryptoPercentageValue: UILabel!
    @IBOutlet weak var dollarPercentageValue: UILabel!
    @IBOutlet weak var cryptoInvestmentValue: UILabel!
    @IBOutlet weak var dollarInvestmentValue: UILabel!
    
    // MARK: - Variables
    //===========================
    var parties = ["",""]
    var partiesPercentage = [0.5,99.5]
    
    // MARK: - Lifecycle
    //===========================
    override func awakeFromNib() {
        super.awakeFromNib()
        setupProgressView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dataContainerView.addShadowRounded(cornerRadius: 5, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 5)
    }
    
    private func setupProgressView(){
        pieChartView.delegate = self
        let l = pieChartView.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .top
        l.orientation = .vertical
        l.xEntrySpace = 7
        l.yEntrySpace = 0
        l.yOffset = 0
//        chartView.legend = l

        // entry label styling
        pieChartView.drawEntryLabelsEnabled = false
        pieChartView.entryLabelColor = .yellow
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
        
        
        set.colors = [#colorLiteral(red: 0.137254902, green: 0.262745098, blue: 0.8745098039, alpha: 1),#colorLiteral(red: 0.1647058824, green: 0.7450980392, blue: 0.7843137255, alpha: 1)]
        
        let data = PieChartData(dataSet: set)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        
        data.setValueFont(.systemFont(ofSize: 15, weight: .bold))
        data.setValueTextColor(.clear)
        
        pieChartView.data = data
        pieChartView.highlightValues(nil)
    }
    
    // MARK: - IBActions
    //===========================
    
    
}
