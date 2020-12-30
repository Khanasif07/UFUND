//
//  CoinCell.swift
//  ViperBaseiOS13
//
//  Created by Deepika on 27/11/19.
//  Copyright © 2019 CSS. All rights reserved.
//

import UIKit

class CoinCell: UICollectionViewCell {

    @IBOutlet weak var cryptoLbl: UILabel!
    @IBOutlet weak var cryptoImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        cryptoLbl.textColor = UIColor(hex: placeHolderColor)
    }

}
