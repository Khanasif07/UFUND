//
//  FundCell.swift
//  ViperBaseiOS13
//
//  Created by Deepika on 14/03/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit

class FundCell: UICollectionViewCell {
    
    @IBOutlet weak var balanceLbl: UILabel!
    @IBOutlet weak var coinName: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var bgColor: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
