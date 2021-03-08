//
//  AssetsDetailInfoCell.swift
//  ViperBaseiOS13
//
//  Created by Admin on 24/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//


import UIKit

class AssetsDetailInfoCell: UITableViewCell {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var tokenDecimnalLbl: UILabel!
    @IBOutlet weak var coinLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var categorylbl: UILabel!
    @IBOutlet weak var auditorsLbl: UILabel!
    @IBOutlet weak var backedAssetsLbl: UILabel!
    @IBOutlet weak var contractAddressLbl: UILabel!
    @IBOutlet weak var tokenTypeLbl: UILabel!
    @IBOutlet weak var rewardsLbl: UILabel!
    @IBOutlet weak var totalSupplyLbl: UILabel!
    
    // MARK: - Variables
    //===========================
    
    // MARK: - Lifecycle
    //===========================
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(model:ProductModel){
//        self.tokenDecimnalLbl.text = "N/A"
        self.coinLbl.text = "N/A"
//        self.typeLbl.text = "N/A"
        self.rewardsLbl.text = "N/A"
//        self.totalSupplyLbl.text = "N/A"
//        self.tokenTypeLbl.text = "N/A"
//        self.contractAddressLbl.text = "N/A"
        self.backedAssetsLbl.text = "N/A"
        self.auditorsLbl.text = "N/A"
//        self.categorylbl.text = "N/A"
        self.tokenTypeLbl.text = "\(model.token_type ?? 0)"
        self.contractAddressLbl.text = model.contract_address ?? ""
        self.typeLbl.text = model.tokentype ?? ""
        self.tokenDecimnalLbl.text = "\(model.decimal ?? 0)"
        self.categorylbl.text = model.tokenrequest?.asset?.category?.category_name ?? ""
        self.totalSupplyLbl.text = "\(model.tokensupply ?? 0)"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - IBActions
    //===========================
    
    
}
