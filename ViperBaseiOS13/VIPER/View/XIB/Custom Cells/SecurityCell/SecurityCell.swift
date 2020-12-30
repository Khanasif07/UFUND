//
//  SecurityCell.swift
//  Project
//
//  Created by Deepika on 23/09/19.
//  Copyright © 2019 css. All rights reserved.
//

import UIKit

class SecurityCell: UITableViewCell {

    @IBOutlet weak var hiddenButton: UIButton!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var switchToogle: UISwitch!
    @IBOutlet weak var securityTitle: UITextField!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bgView.applyEffectToView()
    }

    func darkTheme() {
        bgView.backgroundColor = UIColor(hex: buttonTextColor)
        securityTitle.textColor = UIColor(hex: darkTextColor)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
}
