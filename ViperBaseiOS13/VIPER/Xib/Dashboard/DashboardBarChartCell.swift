//
//  DashboardBarChartCell.swift
//  ViperBaseiOS13
//
//  Created by Admin on 23/03/21.
//  Copyright © 2021 CSS. All rights reserved.
//


import UIKit

class DashboardBarChartCell: UITableViewCell {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var buyMonthlyTxtField: UITextField!
    @IBOutlet weak var buyHistoryTxtField: UITextField!
    @IBOutlet weak var dataContainerView: UIView!
    
    // MARK: - Variables
    //===========================
    
    // MARK: - Lifecycle
    //===========================
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dataContainerView.addShadowRounded(cornerRadius: 5, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 5)
    }
    
    // MARK: - IBActions
    //===========================
    
    
}
