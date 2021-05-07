//
//  MyWalletVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 15/03/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit
import iOSDropDown


class MyWalletVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var currencyTextField: DropDown!
    @IBOutlet weak var bottomStackView: UIStackView!
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
    var  buttonView = UIButton()
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
        let vc = MyWalletDepositVC.instantiate(fromAppStoryboard: .Wallet)
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func depositBtnAction(_ sender: UIButton) {
        let vc = MyWalletDepositVC.instantiate(fromAppStoryboard: .Wallet)
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func overAllUserInvestmentBtnAction(_ sender: UIButton) {
        let vc = AllProductsVC.instantiate(fromAppStoryboard: .Products)
        vc.productTitle = Constants.string.overall_user_investment.localize()
        vc.productType = .AllProducts
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func totalProductsBtnAction(_ sender: UIButton) {
        let vc = AllProductsVC.instantiate(fromAppStoryboard: .Products)
        vc.productTitle = Constants.string.totalProducts.localize()
        vc.productType = .AllProducts
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func totalAssetsBtnAction(_ sender: UIButton) {
        let vc = AllProductsVC.instantiate(fromAppStoryboard: .Products)
        vc.productTitle = Constants.string.myToken_and_assets.localize()
        vc.productType = .AllProducts
        self.navigationController?.pushViewController(vc, animated: true)
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
        self.titleLbl.font = isDeviceIPad ? .setCustomFont(name: .bold, size: .x20) : .setCustomFont(name: .bold, size: .x16)
        DispatchQueue.main.async {
            [self.userInvestmentImgView,self.totalAssetsImgView,self.totalProductImgView].forEach { (imgView) in
                imgView?.layer.masksToBounds = true
                imgView?.layer.borderWidth = 8.0
                imgView?.layer.borderColor = UIColor.rgb(r: 237, g: 236, b: 255).cgColor
                imgView?.layer.cornerRadius = (imgView?.bounds.width ?? 0.0) / 2
            }
        }
        dropdownView?.layer.masksToBounds = true
        dropdownView?.layer.borderWidth = 2.0
        dropdownView?.layer.borderColor = UIColor.rgb(r: 237, g: 236, b: 255).cgColor
        dropdownView?.layer.cornerRadius = 4.0
        currencyControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        self.currencyTextField.delegate = self
        buttonView.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        currencyTextField.setButtonToRightView(btn: buttonView, selectedImage: #imageLiteral(resourceName: "icDropdown"), normalImage: #imageLiteral(resourceName: "icDropdown"), size: CGSize(width: 20, height: 20))
        currencyTextField.optionArray = ["ETH","BTC"]
        currencyTextField.optionIds = [0,1]
        currencyTextField.arrowColor = .clear
        currencyTextField.didSelect { (categoryName, index,id)  in
            print(categoryName)
            print(index)
            print(id)
        }
        
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            currencyTextField.isHidden = false
        } else {
             currencyTextField.isHidden = true
        }
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
        let globalPoint = bottomStackView.superview?.convert(bottomStackView.frame.origin, to: nil)
        bottomSheetVC.textContainerHeight = (globalPoint?.y ?? 0.0)
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


extension MyWalletVC : UITextFieldDelegate {
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if  textField == currencyTextField {
            self.view.endEditingForce()
            currencyTextField.showList()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        view.endEditingForce()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditingForce()
        return true
    }
}


