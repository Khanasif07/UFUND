//
//  CountryCodeTableCell.swift
//  ViperBaseiOS13
//
//  Created by Admin on 09/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit

class CountryCodeTableCell: UITableViewCell {

    //MARK:- IBOutlets
    //================
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var countryNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
