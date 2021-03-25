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
    @IBOutlet weak var buyMonthlyTxtField: UITextField!
    @IBOutlet weak var buyHistoryTxtField: UITextField!
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var  barChartView :  BarChartView!
    
    // MARK: - Variables
    //===========================
    var buttonView = UIButton()
    var buttonView1 = UIButton()
    var buyHistoryBtnTapped: ((UIButton)->())?
    var buyMonthlyBtnTapped: ((UIButton)->())?
    
    // MARK: - Lifecycle
    //===========================
    override func awakeFromNib() {
        super.awakeFromNib()
        buttonView.imageEdgeInsets = UIEdgeInsets(top: 0, left: -7.5, bottom: 0, right: +7.5)
        buyMonthlyTxtField.setButtonToRightView(btn: buttonView, selectedImage: #imageLiteral(resourceName: "icDropdown"), normalImage: #imageLiteral(resourceName: "icDropdown"), size: CGSize(width: 20, height: 20))
        buttonView1.imageEdgeInsets = UIEdgeInsets(top: 0, left: -7.5, bottom: 0, right: +7.5)
        buyHistoryTxtField.setButtonToRightView(btn: buttonView1, selectedImage: #imageLiteral(resourceName: "icDropdown"), normalImage: #imageLiteral(resourceName: "icDropdown"), size: CGSize(width: 20, height: 20))
        self.setUpBarChart()
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
    
//    override func updateChartData() {
//        if self.shouldHideData {
//            chartView.data = nil
//            return
//        }
//
//        self.setDataCount(Int(sliderX.value) + 1, range: UInt32(sliderY.value))
//    }
    
    func setDataCount(_ count: Int, range: UInt32) {
        let start = 1
        
        let yVals = (start..<start+count+1).map { (i) -> BarChartDataEntry in
            let mult = range + 1
            let val = Double(arc4random_uniform(mult))
            if arc4random_uniform(100) < 25 {
                return BarChartDataEntry(x: Double(i), y: val, icon: UIImage(named: "icon"))
            } else {
                return BarChartDataEntry(x: Double(i), y: val)
            }
        }
        
        var set1: BarChartDataSet! = nil
//        if let set = barChartView.data as? BarChartDataSet {
//            set1 = set
//            set1.replaceEntries(yVals)
//            barChartView.data?.notifyDataChanged()
//            barChartView.notifyDataSetChanged()
//        } else {
            set1 = BarChartDataSet(entries: yVals, label: "2021")
            set1.colors = ChartColorTemplates.material()
            set1.drawValuesEnabled = false
            
            let data = BarChartData(dataSet: set1)
            data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 10)!)
            data.barWidth = 0.5
            barChartView.data = data
//        }
        
        //        chartView.setNeedsDisplay()
    }
    
//    override func optionTapped(_ option: Option) {
//        super.handleOption(option, forChartView: chartView)
//    }
    
    private func setUpBarChart(){
//        self.setup(barLineChartView: barChartView)
        barChartView.delegate = self
        barChartView.drawBarShadowEnabled = false
        barChartView.drawValueAboveBarEnabled = false
        barChartView.maxVisibleCount = 60
        let xAxis = barChartView.xAxis
               xAxis.labelPosition = .bottom
               xAxis.labelFont = .systemFont(ofSize: 10)
               xAxis.granularity = 1
               xAxis.labelCount = 7
               xAxis.valueFormatter = DayAxisValueFormatter(chart: barChartView)
        
               let l = barChartView.legend
               l.horizontalAlignment = .left
               l.verticalAlignment = .bottom
               l.orientation = .horizontal
               l.drawInside = false
               l.form = .circle
               l.formSize = 9
               l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
               l.xEntrySpace = 4
        self.setDataCount(11, range: 1000)
    }
    
}



//
//  DayAxisValueFormatter.swift
//  ChartsDemo-iOS
//
//  Created by Jacob Christie on 2017-07-09.
//  Copyright © 2017 jc. All rights reserved.
//



public class DayAxisValueFormatter: NSObject, IAxisValueFormatter {
    weak var chart: BarLineChartViewBase?
    let months = ["Jan", "Feb", "Mar",
                  "Apr", "May", "Jun",
                  "Jul", "Aug", "Sep",
                  "Oct", "Nov", "Dec"]
    
    
    init(chart: BarLineChartViewBase) {
        self.chart = chart
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let days = Int(value)
        let year = determineYear(forDays: days)
        let month = determineMonth(forDayOfYear: days)
        
        let monthName = months[month % months.count]
        let yearName = "\(year)"
        
        if let chart = chart,
            chart.visibleXRange > 30 * 6 {
            return monthName + yearName
        } else {
            let dayOfMonth = determineDayOfMonth(forDays: days, month: month + 12 * (year - 2016))
            var appendix: String
            
            switch dayOfMonth {
            case 1, 21, 31: appendix = "st"
            case 2, 22: appendix = "nd"
            case 3, 23: appendix = "rd"
            default: appendix = "th"
            }
            
            return dayOfMonth == 0 ? "" : String(format: "%d\(appendix) \(monthName)", dayOfMonth)
        }
    }
    
    private func days(forMonth month: Int, year: Int) -> Int {
        // month is 0-based
        switch month {
        case 1:
            var is29Feb = false
            if year < 1582 {
                is29Feb = (year < 1 ? year + 1 : year) % 4 == 0
            } else if year > 1582 {
                is29Feb = year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)
            }
            
            return is29Feb ? 29 : 28
            
        case 3, 5, 8, 10:
            return 30
            
        default:
            return 31
        }
    }
    
    private func determineMonth(forDayOfYear dayOfYear: Int) -> Int {
        var month = -1
        var days = 0
        
        while days < dayOfYear {
            month += 1
            if month >= 12 {
                month = 0
            }
            
            let year = determineYear(forDays: days)
            days += self.days(forMonth: month, year: year)
        }
        
        return max(month, 0)
    }
    
    private func determineDayOfMonth(forDays days: Int, month: Int) -> Int {
        var count = 0
        var daysForMonth = 0
        
        while count < month {
            let year = determineYear(forDays: days)
            daysForMonth += self.days(forMonth: count % 12, year: year)
            count += 1
        }
        
        return days - daysForMonth
    }
    
    private func determineYear(forDays days: Int) -> Int {
        switch days {
        case ...366: return 2016
        case 367...730: return 2017
        case 731...1094: return 2018
        case 1095...1458: return 2019
        default: return 2020
        }
    }
}
