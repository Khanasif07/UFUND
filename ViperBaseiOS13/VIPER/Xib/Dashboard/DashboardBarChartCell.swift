//
//  DashboardBarChartCell.swift
//  ViperBaseiOS13
//
//  Created by Admin on 23/03/21.
//  Copyright © 2021 CSS. All rights reserved.
//

#if canImport(UIKit)
import UIKit
#endif
import Charts
#if canImport(UIKit)
import UIKit
#endif


class DashboardBarChartCell: UITableViewCell, ChartViewDelegate {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var productPerCurrencyTitlelbl: UILabel!
    @IBOutlet weak var buyHistoryTitleLbl: UILabel!
    @IBOutlet weak var buyMonthlyTxtField: UITextField!
    @IBOutlet weak var buyHistoryTxtField: UITextField!
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var barChartView :  BarChartView!
    
    // MARK: - Variables
    //===========================
    var buttonView = UIButton()
    var buttonView1 = UIButton()
    var buyHistoryBtnTapped: ((UIButton)->())?
    var buyMonthlyBtnTapped: ((UIButton)->())?
    //
    var firstBarValue: [Double] = [1.0,0.4,5.0,4.0,6.0,5.0,0.9]
    var vertXValues : [String]?{
        didSet{
            self.awakeFromNib()
        }
    }
    let verYValues = ["0 €","1000 €","2000 €","3000 €", "4000 €", "5000 €","6000 €", "7000 €", "8000 €","9000 €", "10000 €"]
    
    // MARK: - Lifecycle
    //===========================
    override func awakeFromNib() {
        super.awakeFromNib()
        buttonView.imageEdgeInsets = UIEdgeInsets(top: 0, left: -7.5, bottom: 0, right: +7.5)
        buyMonthlyTxtField.setButtonToRightView(btn: buttonView, selectedImage: #imageLiteral(resourceName: "icDropdown"), normalImage: #imageLiteral(resourceName: "icDropdown"), size: CGSize(width: 20, height: 20))
        buttonView1.imageEdgeInsets = UIEdgeInsets(top: 0, left: -7.5, bottom: 0, right: +7.5)
        buyHistoryTxtField.setButtonToRightView(btn: buttonView1, selectedImage: #imageLiteral(resourceName: "icDropdown"), normalImage: #imageLiteral(resourceName: "icDropdown"), size: CGSize(width: 20, height: 20))
        buyHistoryTitleLbl.font  = isDeviceIPad ? .setCustomFont(name: .semiBold, size: .x18) : .setCustomFont(name: .semiBold, size: .x14)
        productPerCurrencyTitlelbl.font  = isDeviceIPad ? .setCustomFont(name: .regular, size: .x18) : .setCustomFont(name: .regular, size: .x14)
        [buyMonthlyTxtField,buyHistoryTxtField].forEach { (txtField) in
             txtField.font  = isDeviceIPad ? .setCustomFont(name: .medium, size: .x16) : .setCustomFont(name: .medium, size: .x12)
        }
        self.setupVerticalChart()
        self.drawVerticalChart()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dataContainerView.addShadowRounded(cornerRadius: 5, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 5)
    }
    
    @IBAction func buyMonthlyBtnAction(_ sender: UIButton) {
        if let handle = buyMonthlyBtnTapped{
            handle(sender)
        }
    }
    
    @IBAction func buyHistoryBtnAction(_ sender: UIButton) {
        if let handle = buyHistoryBtnTapped{
            handle(sender)
        }
    }
    
    
    //MARK: VERTICAL CHART
    //=======================
    func setupVerticalChart() {
        self.setup(barLineChartView: barChartView)
        barChartView.drawBarShadowEnabled = false
        barChartView.drawValueAboveBarEnabled = false
//        barChartView.legend.enabled = false
        barChartView.dragEnabled = false
        barChartView.doubleTapToZoomEnabled = false
        barChartView.pinchZoomEnabled = false
        barChartView.noDataTextColor  = .white
        //
        barChartView.xAxis.granularity = 1.0
        barChartView.xAxis.granularityEnabled = true
        barChartView.xAxis.centerAxisLabelsEnabled = true
        barChartView.xAxis.setLabelCount(3, force: true)
        barChartView.fitBars = true
        //
        
        let legend = barChartView.legend
        legend.enabled = true
        legend.horizontalAlignment = .center
        legend.verticalAlignment = .top
        legend.orientation = .vertical
        legend.drawInside = true
//        legend.yOffset =  -0.25
//        legend.xOffset =  -0.25
//        legend.yEntrySpace = 0.0
        legend.xEntrySpace = 0.0
        
        let xAxis = barChartView.xAxis
        xAxis.labelCount = vertXValues?.count ?? 0
        xAxis.drawAxisLineEnabled = true
        xAxis.drawGridLinesEnabled = false
        xAxis.drawLimitLinesBehindDataEnabled = false
        xAxis.labelTextColor = .black
        xAxis.granularity = 1.0
        xAxis.labelFont = UIFont.systemFont(ofSize: 7.5)
//        xAxis.labelCount = (vertXValues?.count ?? 0)
        xAxis.labelPosition = .bottom
        xAxis.centerAxisLabelsEnabled = false
        xAxis.granularityEnabled = true
        xAxis.drawLabelsEnabled = true
//        xAxis.axisMinimum = 0
        xAxis.axisMaximum = Double(vertXValues?.count ?? 0) - 1.0//to increase length of x-axis more than content size
        xAxis.valueFormatter = IndexAxisValueFormatter(values: vertXValues ?? [])
        
        let leftAxis = barChartView.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 10.0)
        leftAxis.labelCount = verYValues.count
        leftAxis.valueFormatter = IndexAxisValueFormatter(values: verYValues)
        leftAxis.labelPosition = .outsideChart
        leftAxis.axisMinimum = 0
        leftAxis.axisMaximum = Double(verYValues.count)
        leftAxis.granularity = 1.0
        leftAxis.granularityEnabled = true
        leftAxis.drawAxisLineEnabled = true
        leftAxis.drawLimitLinesBehindDataEnabled = false
        leftAxis.drawGridLinesEnabled = false
        leftAxis.drawLabelsEnabled = true
        
        let rightAxis = barChartView.rightAxis
        rightAxis.enabled = false
    }
    
    func drawVerticalChart() {
        barChartView.noDataText = "No Data Found"
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<(self.vertXValues?.count ?? 0) {
            let dataEntry = BarChartDataEntry(x: Double(i) , yValues: [self.firstBarValue[i]])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "")
        chartDataSet.stackLabels = ["Taget 100%","Target 110%", "Taget 120%"]
        chartDataSet.colors = [.blue]
        let dataSets: [BarChartDataSet] = [chartDataSet]
        let chartData = BarChartData(dataSets: dataSets)
        chartData.setDrawValues(false)
        
        let groupSpace = 0.06//formula for calculate actual width (((barWidth + barSpace) * (number of bar in group) ) + groupSpace == 1)
        let barSpace = 0.00
        let barWidth = 0.31
        chartData.barWidth = barWidth
        chartData.groupBars(fromX: 0.0, groupSpace: groupSpace, barSpace: barSpace)
        barChartView.notifyDataSetChanged()
        barChartView.data = chartData
        barChartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
        
    }
    
    /// Returns the colors array according to condition for real sale values.
    ///
    /// - Returns: Array of UIColors
    
    func setup(barLineChartView chartView: BarLineChartViewBase) {
        chartView.chartDescription?.enabled = false
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.isUserInteractionEnabled = false
        chartView.pinchZoomEnabled = false
        chartView.noDataTextColor  = .white
    }
    
}
