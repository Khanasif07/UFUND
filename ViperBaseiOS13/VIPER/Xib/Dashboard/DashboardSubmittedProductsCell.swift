//
//  DashboardSubmittedProductsCell.swift
//  ViperBaseiOS13
//
//  Created by Admin on 25/03/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import Charts
import UIKit

class DashboardSubmittedProductsCell: UITableViewCell, ChartViewDelegate {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var submittedProductLbl: UILabel!
    @IBOutlet weak var productImgView: UIImageView!
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var submittedProductValue: UILabel!
  
    
    // MARK: - Variables
    //===========================
    var progressPercentageValue: Double = 45.0
    var parties = ["","","",""]
    var partiesPercentage = [25,50,10,15]{
        didSet{
            self.setDataCount(4, range: 100)
        }
    }
    
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
        pieChartView.entryLabelColor = .white
        pieChartView.entryLabelFont = .systemFont(ofSize: 12, weight: .light)
        pieChartView.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
        self.setDataCount(4, range: 100)
    }
    
    func setDataCount(_ count: Int, range: UInt32) {
        let entries = (0..<count).map { (i) -> PieChartDataEntry in
            // IMPORTANT: In a PieChart, no values (Entry) should have the same xIndex (even if from different DataSets), since no values can be drawn above each other.
            return PieChartDataEntry(value: Double(partiesPercentage[i]) ,
                                     label: parties[i % parties.count],
                                     icon: #imageLiteral(resourceName: "icEarningInCryptoBg"))
        }
        
        let set = PieChartDataSet(entries: entries, label: "")
        set.drawIconsEnabled = false
        set.sliceSpace = 0
        
        
        set.colors = [#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1),#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1),#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1),#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)]
        
        let data = PieChartData(dataSet: set)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        
        data.setValueFont(.systemFont(ofSize: 11, weight: .light))
        data.setValueTextColor(.clear)
        
        pieChartView.data = data
        pieChartView.highlightValues(nil)
    }
    
    // MARK: - IBActions
    //===========================
    
    
}