//
//  ConfirmViewController.swift
//  ViperBaseiOS13
//
//  Created by Admin on 19/08/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit

class ConfirmViewController: UIViewController {

    public var image : UIImage? = nil
    @IBOutlet weak var confirmImageView: UIImageView!
    override func viewDidLoad() {
        self.navigationItem.hidesBackButton = true
        super.viewDidLoad()
        confirmImageView.image = image
    }

    @IBAction func confirmClicked(_ sender: Any) {
        let rootVC : KYCViewController = self.navigationController?.viewControllers[1] as! KYCViewController
        self.navigationController?.popViewController(animated: true)
        rootVC.confirmed()
    }
    

    @IBAction func retryClicked(_ sender: Any) {
        let rootVC : KYCViewController = self.navigationController?.viewControllers[1] as! KYCViewController
        self.navigationController?.popViewController(animated: true)
        rootVC.retry()
    }
}

