//
//  TranscationHistoryCell.swift
//  Project
//
//  Created by Deepika on 21/05/19.
//  Copyright © 2019 css. All rights reserved.
//

import UIKit

class TranscationHistoryCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var seeMoreButton: UIButton!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var txtId: UILabel!
    @IBOutlet weak var accountLbl: UILabel!
    @IBOutlet weak var inUSDLbl: UILabel!
    @IBOutlet weak var sendOrReceiverLbl: UILabel!
    @IBOutlet weak var inHADTLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
         statusLbl.textColor = UIColor(hex: greenColur)
    }

    func darkTheme() {
        
        dateLbl.textColor = UIColor(hex: darkTextColor)
        
         inHADTLbl.textColor = UIColor(hex: darkTextColor)
        
         sendOrReceiverLbl.textColor = UIColor(hex: darkTextColor)
        
         accountLbl.textColor = UIColor(hex: darkTextColor)
        
    
        
        
        inUSDLbl.textColor = shadowColor
        
        
           txtId.textColor = shadowColor
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
      
       
        // Configure the view for the selected state
    }
    
    
    
}
