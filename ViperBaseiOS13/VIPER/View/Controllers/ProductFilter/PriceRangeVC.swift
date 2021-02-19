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
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var maxRangeField: UITextField!
    @IBOutlet weak var priceSlider: RangeSeekSlider!
    @IBOutlet weak var minRangeField: UITextField!
    
    // MARK: - Variables
    //===========================
    
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
        self.minRangeField.text = "\(min.round(to: 2))"
        ProductFilterVM.shared.minimumPrice = min.round(to: 2)
        self.maxRangeField.text = "\(max.round(to: 2))"
        ProductFilterVM.shared.maximumPrice = max.round(to: 2)
    }
    
    private func initialSetup() {
        self.priceSlider.delegate = self
        self.priceSlider.selectedMinValue = CGFloat(ProductFilterVM.shared.minimumPrice)
        self.priceSlider.selectedMaxValue = CGFloat(ProductFilterVM.shared.maximumPrice)
    }
}

