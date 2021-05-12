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
        self.coinLbl.text = model.tokensymbol ?? ""
        self.rewardsLbl.text = (model.tokenrequest?.asset?.reward == 1 ) ? "Goods" : (model.tokenrequest?.asset?.reward == 2 ) ? "Interest" : "Share"
        self.backedAssetsLbl.text = model.tokenrequest?.asset?.asset_title ?? ""
        self.auditorsLbl.text = model.user?.name ?? ""
        self.tokenTypeLbl.text = "\(model.token_type ?? 0)"
        self.contractAddressLbl.text = model.contract_address ?? ""
        self.typeLbl.text = model.tokenrequest?.tokensymbol ?? ""
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
