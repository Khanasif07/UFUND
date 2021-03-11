//
//  PriceRangeVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 16/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit
import RangeSeekSlider

class PriceRangeVC: UIViewController {
    
    enum FilterPriceType {
        case priceRange
        case earning
        case yield
    }
    
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var maxRangeLbl: UILabel!
    @IBOutlet weak var minRangeLbl: UILabel!
    @IBOutlet weak var maxRangeField: UITextField!
    @IBOutlet weak var priceSlider: RangeSeekSlider!
    @IBOutlet weak var minRangeField: UITextField!
    
    // MARK: - Variables
    //===========================
    var filterPriceType : FilterPriceType = .priceRange
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }
}

// MARK: - Extension For Functions
//===========================
extension PriceRangeVC : RangeSeekSliderDelegate {
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat){
        let min = minValue
        let max = maxValue
        switch filterPriceType {
        case .priceRange:
            self.minRangeField.text = "\(min.round(to: 2))"
            ProductFilterVM.shared.minimumPrice = min.round(to: 2)
            self.maxRangeField.text = "\(max.round(to: 2))"
            ProductFilterVM.shared.maximumPrice = max.round(to: 2)
        case .earning:
            self.minRangeField.text = "\(min.round(to: 2))"
            ProductFilterVM.shared.minimumEarning = min.round(to: 2)
            self.maxRangeField.text = "\(max.round(to: 2))"
            ProductFilterVM.shared.maximumEarning = max.round(to: 2)
        case .yield:
            self.minRangeField.text = "\(min.round(to: 2))"
            ProductFilterVM.shared.minimumYield = min.round(to: 2)
            self.maxRangeField.text = "\(max.round(to: 2))"
            ProductFilterVM.shared.maximumYield = max.round(to: 2)
        }
    }
    
    private func initialSetup() {
        self.priceSlider.delegate = self
        switch filterPriceType {
        case .priceRange:
            self.maxRangeLbl.text = "Max. Range"
            self.minRangeLbl.text = "Min. Range"
            self.minRangeField.text = "\(ProductFilterVM.shared.minimumPrice)"
            self.maxRangeField.text = "\(ProductFilterVM.shared.maximumPrice)"
            self.priceSlider.selectedMinValue = CGFloat(ProductFilterVM.shared.minimumPrice)
            self.priceSlider.selectedMaxValue = CGFloat(ProductFilterVM.shared.maximumPrice)
        case .earning:
            self.maxRangeLbl.text = "Max. Earning"
            self.minRangeLbl.text = "Min. Earning"
            self.minRangeField.text = "\(ProductFilterVM.shared.minimumEarning)"
            self.maxRangeField.text = "\(ProductFilterVM.shared.maximumEarning)"
            self.priceSlider.selectedMinValue = CGFloat(ProductFilterVM.shared.minimumEarning)
            self.priceSlider.selectedMaxValue = CGFloat(ProductFilterVM.shared.maximumEarning)
        case .yield:
            self.priceSlider.minValue =  0.0
            self.priceSlider.maxValue = 100.0
            self.maxRangeLbl.text = "Max. Percentage"
            self.minRangeLbl.text = "Min. Percentage"
            self.minRangeField.text = "\(ProductFilterVM.shared.minimumYield)"
            self.maxRangeField.text = "\(ProductFilterVM.shared.maximumYield)"
            self.priceSlider.selectedMinValue = CGFloat(ProductFilterVM.shared.minimumYield)
            self.priceSlider.selectedMaxValue = CGFloat(ProductFilterVM.shared.maximumYield)
        }
       
    }
}

