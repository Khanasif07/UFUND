//
//  NotificationCell.swift
//  ViperBaseiOS13
//
//  Created by Deepika on 25/11/19.
//  Copyright © 2019 CSS. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {

   
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var descripLbl: UILabel!
    @IBOutlet weak var ttileLbl: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
        timeLbl.textColor = UIColor(hex: "#717171")
        descripLbl.textColor = UIColor(hex: darkTextColor)
        ttileLbl.textColor = UIColor(hex: "#717171")
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
