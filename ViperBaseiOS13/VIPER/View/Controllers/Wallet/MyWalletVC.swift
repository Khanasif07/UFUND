//
//  MyWalletVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 15/03/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit


class MyWalletVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var dropdownView: UIView!
    @IBOutlet weak var currencyControl: UISegmentedControl!
    @IBOutlet weak var middleView: UIStackView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var userInvestmentImgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var userInvestmentValueLbl: UILabel!
    @IBOutlet weak var totalProductsValueLbl: UILabel!
    @IBOutlet weak var totalAssetsValueLbl: UILabel!
    @IBOutlet weak var withdrawlView: UIView!
    @IBOutlet weak var totalAssetsImgView: UIImageView!
    @IBOutlet weak var totalProductImgView: UIImageView!
    @IBOutlet weak var depositView: UIView!
    @IBOutlet weak var yourWalletBalanceLbl: UILabel!
    @IBOutlet weak var walletBalanceView: UIView!
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
        depositView.addShadowRounded(cornerRadius: 5, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 5)
         withdrawlView.addShadowRounded(cornerRadius: 5, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 5)
        walletBalanceView.addShadowRounded(cornerRadius: 5, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 5)
         topView.addShadowRounded(cornerRadius: 5, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 5)
        middleView.subviews.forEach { (innerView) in
            innerView.addShadowRounded(cornerRadius: 5, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 5)
        }
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func withdrawlBtnAction(_ sender: UIButton) {
    }
    @IBAction func depositBtnAction(_ sender: UIButton) {
    }
    
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.popOrDismiss(animation: true)
    }
    
    
}

// MARK: - Extension For Functions
//===========================
extension MyWalletVC {
    
    private func initialSetup() {
        self.setUpBorder()
    }
    
    private func setUpBorder(){
        [userInvestmentImgView,totalAssetsImgView,totalProductImgView].forEach { (imgView) in
            imgView?.layer.masksToBounds = true
            imgView?.layer.borderWidth = 8.0
            imgView?.layer.borderColor = UIColor.rgb(r: 237, g: 236, b: 255).cgColor
            imgView?.layer.cornerRadius = (imgView?.bounds.width ?? 0.0) / 2
        }
        dropdownView?.layer.masksToBounds = true
        dropdownView?.layer.borderWidth = 2.0
        dropdownView?.layer.borderColor = UIColor.rgb(r: 237, g: 236, b: 255).cgColor
        dropdownView?.layer.cornerRadius = 4.0
        
        
    }
}

// MARK: - Extension For TableView
//===========================
extension MyWalletVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
