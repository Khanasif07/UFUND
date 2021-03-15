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
    let bottomSheetVC = MyWalletSheetVC()
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self.view)
        if self.bottomSheetVC.view.frame.contains(touchLocation) {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        bottomSheetVC.closePullUp()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addBottomSheetView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        depositView.addShadowRounded(cornerRadius: 5, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 5)
        withdrawlView.addShadowRounded(cornerRadius: 5, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 5)
        walletBalanceView.addShadowRounded(cornerRadius: 5, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 5)
        topView.addShadowRounded(cornerRadius: 5, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 5)
        middleView.subviews.forEach { (innerView) in
            innerView.addShadowRounded(cornerRadius: 5, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 5)
            bottomSheetVC.view.dropShadow(cornerRadius: 10, color: UIColor.black16, offset: CGSize(width: 0, height: -3), opacity: 0.16, shadowRadius: 8)
            self.view.layoutIfNeeded()
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
    
    func addBottomSheetView() {
        
        guard !self.children.contains(bottomSheetVC) else { return }
        self.addChild(bottomSheetVC)
        //        self.view.addSubview(bottomSheetVC.view)
        self.view.insertSubview(bottomSheetVC.view, belowSubview: self.topView)
        //        bottomSheetVC.didMove(toParent: self)
        
        let height = view.frame.height
        let width  = view.frame.width
        bottomSheetVC.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)
        if UIScreen.main.bounds.size.height <= 812 {
            bottomSheetVC.bottomLayoutConstraint.constant = self.view.safeAreaInsets.bottom + (self.tabBarController?.tabBar.height ?? 0)
        }
        let adjustForTabbarInsets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 0, bottom: self.tabBarController?.tabBar.frame.height ?? 30, right: 0)
        bottomSheetVC.mainTableView.contentInset = adjustForTabbarInsets
        bottomSheetVC.mainTableView.scrollIndicatorInsets = adjustForTabbarInsets
        //        bottomSheetVC.listingTableView.refreshControl = refreshControl
        self.view.layoutIfNeeded()
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
