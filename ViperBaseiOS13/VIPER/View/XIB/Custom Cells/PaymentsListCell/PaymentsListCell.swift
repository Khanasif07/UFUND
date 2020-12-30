//
//  PaymentsListCell.swift
//  ViperBaseiOS13
//
//  Created by Deepika on 26/11/19.
//  Copyright © 2019 CSS. All rights reserved.
//

import UIKit

class PaymentsListCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var tapButton: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var cardNumberLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.applyEffectToView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
