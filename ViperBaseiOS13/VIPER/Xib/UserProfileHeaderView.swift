//
//  UserProfileHeaderView.swift
//  ViperBaseiOS13
//
//  Created by Admin on 08/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import Foundation
import UIKit

class UserProfileHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var dataContainerView: UIView!
    
    override func awakeFromNib() {
        self.titleLbl.font =  isDeviceIPad ? .setCustomFont(name: .bold, size: .x16) : .setCustomFont(name: .bold, size: .x12)
        self.dataContainerView.roundCorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 8)
    }
}
