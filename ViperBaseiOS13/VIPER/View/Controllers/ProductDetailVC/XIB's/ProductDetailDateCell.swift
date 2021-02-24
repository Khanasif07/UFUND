//
//  ProductDetailDateCell.swift
//  ViperBaseiOS13
//
//  Created by Admin on 19/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit

class ProductDetailDateCell: UITableViewCell {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var offerEndDateTitleLbl: UILabel!
    @IBOutlet weak var offerStartDateTitleLbl: UILabel!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var offerStartDateLbl: UILabel!
    @IBOutlet weak var maturityDateLbl: UILabel!
    @IBOutlet weak var investmentStartDateLbl: UILabel!
    @IBOutlet weak var offerEndDateLbl: UILabel!
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
    }
    
    func setCellForAssetsDetailPage(){
        self.bottomStackView.isHidden = true
        self.offerEndDateTitleLbl.text = "End Date"
        self.offerStartDateTitleLbl.text = "Start Date"
    }
    
    // MARK: - IBActions
    //===========================
    
    
}
