//
//  AccountCell.swift
//  ViperBaseiOS13
//
//  Created by Deepika on 22/11/19.
//  Copyright © 2019 CSS. All rights reserved.
//

import UIKit

class AccountCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var profileLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        imgView.contentMode = .scaleAspectFit
        profileLbl.textColor = UIColor(hex: placeHolderColor)
        bgView.applyEffectToView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
