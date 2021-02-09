//
//  UserProfileImageCell.swift
//  ViperBaseiOS13
//
//  Created by Admin on 08/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit

class UserProfileImageCell: UITableViewCell {
    
    var  profileImgBtnTapped:((UIButton)->())?

    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var dataContainerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
   
    override func layoutSubviews() {
        super.layoutSubviews()
        self.dataContainerView.applyShadow(radius: 0)
        profileImgView.layer.cornerRadius = self.profileImgView.frame.height / 2
    }
    
    
    @IBAction func profileImgBtnAction(_ sender: UIButton) {
        if let handle = profileImgBtnTapped{
            handle(sender)
        }
    }
    
}
