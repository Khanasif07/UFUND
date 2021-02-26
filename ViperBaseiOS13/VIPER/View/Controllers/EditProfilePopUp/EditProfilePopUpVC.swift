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
    var btnValue: String = "Cancel"
    var titleImgValue : UIImage = #imageLiteral(resourceName: "icInformationProfile")
    var titleValue : String = "Approval Waiting"
    var descValue  : String  = "Your request has been sent to admin. Please wait for admin approval"

    @IBOutlet weak var titleImgView: UIImageView!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var cancelBtn: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLbl.text = titleValue
        self.descLbl.text = descValue
        self.cancelBtn.setTitle(btnValue, for: .normal)
        self.titleImgView.image = titleImgValue
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
