//
//  MyWalletSectionView.swift
//  ViperBaseiOS13
//
//  Created by Admin on 16/03/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit

class MyWalletSectionView: UITableViewHeaderFooterView {
    
    var sectionTappedAction: ((UIButton)->())?

    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var sectionMiddleLbl: UILabel!
    @IBOutlet weak var dropdownBtn: UIButton!
    @IBOutlet weak var sectionTitleLbl: UILabel!
    @IBOutlet weak var dataContainerView: UIView!
    
    
    @IBAction func sectionBtnTapped(_ sender: UIButton) {
        if let handle = sectionTappedAction{
            handle(sender)
        }
    }
    
    open func populateData(model: History){
        let date = (model.created_at)?.toDate(dateFormat: Date.DateFormat.yyyyMMddHHmmss.rawValue) ?? Date()
        self.dateLbl.text = date.convertToDefaultString()
        self.sectionMiddleLbl.text = model.type ?? ""
        self.sectionTitleLbl.text = model.via ?? ""
    }
    
    open func populateDataForWallet(model: History){
        let date = (model.created_at)?.toDate(dateFormat: Date.DateFormat.yyyyMMddHHmmss.rawValue) ?? Date()
        self.dateLbl.text = model.status?.uppercased() ?? ""
        self.sectionMiddleLbl.text = date.convertToDefaultString()
        self.sectionTitleLbl.text = model.payment_id ?? ""
    }
    
    open func populateDataForSell(model: History){
        let date = (model.created_at)?.toDate(dateFormat: Date.DateFormat.yyyyMMddHHmmss.rawValue) ?? Date()
        self.dateLbl.text = model.status?.uppercased() ?? ""
        self.sectionMiddleLbl.text = date.convertToDefaultString()
        self.sectionTitleLbl.text = "$ " + String(model.amount ?? 0.0)
        self.dateLbl.textColor = #colorLiteral(red: 0.09411764706, green: 0.7411764706, blue: 0.4705882353, alpha: 1)
    }

}
