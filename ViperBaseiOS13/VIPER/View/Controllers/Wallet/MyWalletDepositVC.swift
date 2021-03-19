//
//  MyWalletDepositVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 19/03/21.
//  Copyright © 2021 CSS. All rights reserved.
//


import UIKit
import iOSDropDown

class MyWalletDepositVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var currencyTxtField: DropDown!
    @IBOutlet weak var proceedBtn: UIButton!
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var currencyControl: UISegmentedControl!
    // MARK: - Variables
    //===========================
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.dataContainerView.roundCorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 15.0)
    }
    
    
    // MARK: - IBActions
    //===========================
    
    @IBAction func proceedBtnAction(_ sender: UIButton) {
        
    }
    
    @IBAction func crossBtnAction(_ sender: UIButton) {
        self.popOrDismiss(animation: true)
    }
    
}

// MARK: - Extension For Functions
//===========================
extension MyWalletDepositVC {
    
    private func initialSetup() {
        
    }
}
