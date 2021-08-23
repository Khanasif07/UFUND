//
//  ConfirmViewController.swift
//  ViperBaseiOS13
//
//  Created by Admin on 19/08/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit
protocol ConfirmViewControllerDelegate: class {
    func confirmBtnAction()
    func retryBtnAction()
}

class ConfirmViewController: UIViewController {

    public var image : UIImage? = nil
    weak var delegate:ConfirmViewControllerDelegate?
    
    @IBOutlet weak var confirmImageView: UIImageView!
    
    override func viewDidLoad() {
        self.navigationItem.hidesBackButton = true
        super.viewDidLoad()
        confirmImageView.image = image
    }

    @IBAction func confirmClicked(_ sender: Any) {
        self.delegate?.confirmBtnAction()
        self.popOrDismiss(animation: true)
    }
    

    @IBAction func retryClicked(_ sender: Any) {
        self.delegate?.retryBtnAction()
        self.popOrDismiss(animation: true)
    }
}

