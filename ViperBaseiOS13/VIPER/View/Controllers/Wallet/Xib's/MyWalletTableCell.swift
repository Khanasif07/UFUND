//
//  MyWalletTableCell.swift
//  ViperBaseiOS13
//
//  Created by Admin on 16/03/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit

class MyWalletTableCell: UITableViewCell {

    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLbl.font = .setCustomFont(name: .semiBold, size: .x13)
        descLbl.font = .setCustomFont(name: .regular, size: .x13)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    open func populateData(model: History){
    }
    
}
