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
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var chartStackView: UIStackView!
    @IBOutlet weak var submittedProductLbl: UILabel!
    @IBOutlet weak var productImgView: UIImageView!
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var submittedProductValue: UILabel!
    @IBOutlet var valueLbls: [UIButton]!
    @IBOutlet var descLbls: [UILabel]!
    
    
    // MARK: - Variables
    //==========================
    var valueBtnTapped: ((UIButton) -> ())?
    var parties = ["","","",""]
    var partiesPercentage = [0,0,0,0]{
        didSet{
            self.setDataCount(partiesPercentage.endIndex, range: 100)
        }
    }
    
    // MARK: - Lifecycle
    //===========================
    override func awakeFromNib() {
        super.awakeFromNib()
        setupProgressView()
        setUpProductAssetLogo()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dataContainerView.addShadowRounded(cornerRadius: 5, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 5)
    }
    
    private func setUpProductAssetLogo(){
        self.submittedProductValue.font  = isDeviceIPad ? .setCustomFont(name: .bold, size: .x28) : .setCustomFont(name: .bold, size: .x24)
        self.submittedProductLbl.font = isDeviceIPad ? .setCustomFont(name: .medium, size: .x18) : .setCustomFont(name: .medium, size: .x14)
        self.valueLbls.forEach { (lbl) in
            lbl.titleLabel?.font = isDeviceIPad ? .setCustomFont(name: .bold, size: .x18) : .setCustomFont(name: .bold, size: .x14)
        }
        DispatchQueue.main.async {
            self.productImgView.layer.masksToBounds = true
            self.productImgView.layer.borderWidth = 8.0
            self.productImgView.layer.borderColor = UIColor.rgb(r: 237, g: 236, b: 255).cgColor
            self.productImgView.layer.cornerRadius = self.productImgView.bounds.width / 2
        }
    }
    
    private func setupProgressView(){
        pieChartView.delegate = self
        pieChartView.legend.enabled = false

        // entry label styling
        pieChartView.entryLabelColor = .white
        pieChartView.usePercentValuesEnabled = true
        pieChartView.entryLabelFont = .systemFont(ofSize: 12, weight: .light)
        pieChartView.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
        self.setDataCount(partiesPercentage.endIndex, range: 100)
    }
    
    public func setupDescriptionForProducts(product: ProductTypes){
        self.descLbls[0].text = "No of Approved Products"
        self.descLbls[1].text = "No of Products Pending for Approval"
        self.descLbls[2].text = "No of Rejected Products"
        self.descLbls[3].text = "No of sold Products"
        
        self.valueLbls[0].setTitle(String(product.approved  ?? 0), for: .normal)
        self.valueLbls[1].setTitle(String(product.pending ?? 0), for: .normal)
        self.valueLbls[2].setTitle(String(product.reject ?? 0), for: .normal)
        self.valueLbls[3].setTitle(String(product.sold ?? 0), for: .normal)
    }
    
    public func setupDescriptionForAssets(asset: AssetTypes){
        self.descLbls[0].text = "No of Approved Assets"
        self.descLbls[1].text = "No of Assets Pending for Approval"
        self.descLbls[2].text = "No of Rejected Assets"
        self.descLbls[3].text = "No of sold Assets"
        
        self.valueLbls[0].setTitle(String(asset.approved  ?? 0), for: .normal)
        self.valueLbls[1].setTitle(String(asset.pending ?? 0), for: .normal)
        self.valueLbls[2].setTitle(String(asset.reject ?? 0), for: .normal)
        self.valueLbls[3].setTitle(String(asset.sold ?? 0), for: .normal)
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
        set.sliceSpace = 2.0
        //
//        set.yValuePosition = PieChartDataSet.ValuePosition.outsideSlice
        //
        
        set.colors = [#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1),#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1),#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1),#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)]
        
        let data = PieChartData(dataSet: set)
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.zeroSymbol = ""
        pFormatter.multiplier = 1.0
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        data.setValueFont(isDeviceIPad  ? .setCustomFont(name: .bold, size: .x16) : .setCustomFont(name: .bold, size: .x12))
        data.setValueTextColor(.white)
        
        pieChartView.data = data
        pieChartView.highlightValues(nil)
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func valueBtnAction(_ sender: UIButton) {
        if let handle = valueBtnTapped{
            handle(sender)
        }
    }
    
    
}
