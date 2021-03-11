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
    @IBOutlet weak var investmentStartStackView: UIStackView!
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
    
    
    func setCellForInvestmentDetailPage(){
        self.investmentStartStackView.isHidden = true
        self.offerEndDateTitleLbl.text = "End Date"
        self.offerStartDateTitleLbl.text = "Start Date"
    }
    
    func configureCellForAssetsDetailPage(model: ProductModel){
        self.offerEndDateLbl.text = model.tokenrequest?.created_at?.breakCompletDate(outPutFormat:  Date.DateFormat.mmmmyyy.rawValue, inputFormat:  Date.DateFormat.yyyyMMddHHmmss.rawValue).isEmpty ?? true ? "N/A" : model.end_date?.breakCompletDate(outPutFormat:  Date.DateFormat.mmmmyyy.rawValue, inputFormat:  Date.DateFormat.yyyyMMddHHmmss.rawValue)
        self.offerStartDateLbl.text = model.tokenrequest?.created_at?.breakCompletDate(outPutFormat:  Date.DateFormat.mmmmyyy.rawValue, inputFormat:  Date.DateFormat.yyyyMMddHHmmss.rawValue).isEmpty ?? true ? "N/A" : model.start_date?.breakCompletDate(outPutFormat:  Date.DateFormat.mmmmyyy.rawValue, inputFormat:  Date.DateFormat.yyyyMMddHHmmss.rawValue)
    }
    
    func configureCell(model: ProductModel){
        self.offerEndDateLbl.text = model.end_date?.breakCompletDate(outPutFormat:  Date.DateFormat.mmmmyyy.rawValue, inputFormat:  Date.DateFormat.yyyy_MM_dd.rawValue).isEmpty ?? true ? "N/A" : model.end_date?.breakCompletDate(outPutFormat:  Date.DateFormat.mmmmyyy.rawValue, inputFormat:  Date.DateFormat.yyyy_MM_dd.rawValue)
        self.offerStartDateLbl.text = model.start_date?.breakCompletDate(outPutFormat:  Date.DateFormat.mmmmyyy.rawValue, inputFormat:  Date.DateFormat.yyyy_MM_dd.rawValue).isEmpty ?? true ? "N/A" : model.start_date?.breakCompletDate(outPutFormat:  Date.DateFormat.mmmmyyy.rawValue, inputFormat:  Date.DateFormat.yyyy_MM_dd.rawValue)
        self.maturityDateLbl.text = model.maturity_date?.breakCompletDate(outPutFormat:  Date.DateFormat.mmmmyyy.rawValue, inputFormat:  Date.DateFormat.yyyy_MM_dd.rawValue).isEmpty ?? true ? "N/A" : model.maturity_date?.breakCompletDate(outPutFormat:  Date.DateFormat.mmmmyyy.rawValue, inputFormat:  Date.DateFormat.yyyy_MM_dd.rawValue)
        self.investmentStartDateLbl.text = model.updated_at?.breakCompletDate(outPutFormat:  Date.DateFormat.mmmmyyy.rawValue, inputFormat:  Date.DateFormat.yyyyMMddHHmmss.rawValue).isEmpty ?? true ? "N/A" : model.updated_at?.breakCompletDate(outPutFormat:  Date.DateFormat.mmmmyyy.rawValue, inputFormat:  Date.DateFormat.yyyyMMddHHmmss.rawValue)
    }
    
    // MARK: - IBActions
    //===========================
    
    
}
