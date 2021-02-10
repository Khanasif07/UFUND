//
//  EditProfilePopUpVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 10/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit

class EditProfilePopUpVC: UIViewController {

    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var cancelBtn: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cancelBtn.setCornerRadius(cornerR: 24)
        self.dataContainerView.addShadow(color: UIColor.lightGray, opacity: 1, offset: CGSize(width: 0.5, height: 0.5))
    }
    
    
    @IBAction func cancelBtnAction(_ sender: UIButton) {
    }
    
}
