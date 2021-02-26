//
//  EditProfilePopUpVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 10/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit

class EditProfilePopUpVC: UIViewController {
    
    var editProfileSuccess: ((UIButton)->())?

    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var cancelBtn: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cancelBtn.layer.cornerRadius = cancelBtn.frame.height / 2.0
        dataContainerView.layer.cornerRadius = 10.0
        applyShadowView(view: dataContainerView)
    }
    
    
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true) {
            if let handle = self.editProfileSuccess{
                handle(sender)
            }
        }
    }
    
}
