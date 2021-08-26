//
//  AddAssetEmptyCell.swift
//  ViperBaseiOS13
//
//  Created by Admin on 26/08/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit

class AddAssetEmptyCell: UITableViewCell {

    @IBOutlet weak var walletAddressLbl: UILabel!
    @IBOutlet weak var minLbl: UILabel!
    @IBOutlet weak var qrCodeImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        minLbl.text = "Min \(User.main.min_eth ?? 0.0) ETH required."
        walletAddressLbl.text = "Wallet Address : " + "\(User.main.eth_address ?? "")"
        qrCodeImgView.image = Common.CreateQrCodeForyourString(string: User.main.eth_address ?? "")
    }
    
}
