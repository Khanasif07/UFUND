//
//  MyWalletSectionView.swift
//  ViperBaseiOS13
//
//  Created by Admin on 16/03/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit

class MyWalletSectionView: UITableViewHeaderFooterView {
    
    var sectionTappedAction: ((UIButton)->())?

    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var sectionMiddleLbl: UILabel!
    @IBOutlet weak var dropdownBtn: UIButton!
    @IBOutlet weak var sectionTitleLbl: UILabel!
    @IBOutlet weak var dataContainerView: UIView!
    
    
    @IBAction func sectionBtnTapped(_ sender: UIButton) {
        if let handle = sectionTappedAction{
            handle(sender)
        }
    }
    

}
