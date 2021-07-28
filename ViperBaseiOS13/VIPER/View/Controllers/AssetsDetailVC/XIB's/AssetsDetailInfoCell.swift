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
    @IBOutlet var titleLbls: [UILabel]!
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
        self.titleLbls.forEach({ (lbl) in
            lbl.font = isDeviceIPad ? .setCustomFont(name: .regular, size: .x16) : .setCustomFont(name: .regular, size: .x12)})
        [tokenDecimnalLbl,coinLbl,typeLbl,categorylbl,auditorsLbl,backedAssetsLbl,contractAddressLbl,tokenTypeLbl,rewardsLbl,totalSupplyLbl].forEach { (lbl) in
            lbl.font = isDeviceIPad ? .setCustomFont(name: .semiBold, size: .x18) : .setCustomFont(name: .semiBold, size: .x14)
        }
    }
    
    func configureCell(model:ProductModel){
        self.coinLbl.text = model.tokensymbol ?? "N/A"
        self.rewardsLbl.text = (model.tokenrequest?.asset?.reward == 1 ) ? "Goods" : (model.tokenrequest?.asset?.reward == 2 ) ? "Interest" : "Share"
        self.backedAssetsLbl.text = model.tokenrequest?.asset?.asset_title ?? "N/A"
        self.auditorsLbl.text = model.user?.name ?? "N/A"
        self.tokenTypeLbl.text = model.tokenrequest?.token_type?.name ?? "N/A"
        self.contractAddressLbl.text = model.contract_address ?? "N/A"
        self.typeLbl.text = model.tokenrequest?.asset?.asset_type?.name ?? "N/A"
        self.tokenDecimnalLbl.text = "\(model.decimal ?? "N/A")"
        self.categorylbl.text = model.tokenrequest?.asset?.category?.category_name ?? "N/A"
        self.totalSupplyLbl.text = "\(model.tokensupply ?? 0)"
    }
    
    func configureCellCampaigner(model:ProductModel){
        self.coinLbl.text = model.tokensymbol ?? "N/A"
        self.rewardsLbl.text = (model.tokenrequest?.asset?.reward == 1 ) ? "Goods" : (model.tokenrequest?.asset?.reward == 2 ) ? "Interest" : "Share"
        self.backedAssetsLbl.text = model.tokenrequest?.asset?.asset_title ?? "N/A"
        self.auditorsLbl.text = model.user?.name ?? "N/A"
        self.tokenTypeLbl.text = model.asset?.asset_type?.name ?? "N/A"
        self.contractAddressLbl.text = model.contract_address ?? "N/A"
        self.typeLbl.text = model.asset?.asset_type?.name ?? "N/A"
        self.tokenDecimnalLbl.text = "\(model.decimal ?? "N/A")"
        self.categorylbl.text = model.asset?.category?.category_name ?? "N/A"
        self.totalSupplyLbl.text = "\(model.tokensupply ?? 0)"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - IBActions
    //===========================
    
    
}
