//
//  ProductDetailPopUpVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 25/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit

class ProductDetailPopUpVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var tokenPriceValueLbl: UILabel!
    @IBOutlet weak var paymentMethodTxtField: UITextField!
    @IBOutlet weak var payableAmountValueLbl: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var buyNowBtn: UIButton!
    @IBOutlet weak var tokenQtyLbl: UILabel!
    
    // MARK: - Variables
    //===========================
    var buyNowBtnTitle: String = "Buy Product"
    var button = UIButton()
    var isForBuyproduct = false {
        didSet{
            if isForBuyproduct{
                self.buyNowBtnTitle = "Buy Product"
            }else {
                self.buyNowBtnTitle = "Invest"
            }
        }
    }
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.buyNowBtn.setTitle(buyNowBtnTitle, for: .normal)
        self.buyNowBtn.setCornerRadius(cornerR: self.buyNowBtn.frame.height / 2)
        self.cancelBtn.setCornerRadius(cornerR: self.cancelBtn.frame.height / 2)
        self.dataContainerView.dropShadow(cornerRadius: 10, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 5)
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func buyNowAction(_ sender: Any) {
        showAlert(message: "Under Development")
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.popOrDismiss(animation: true)
    }
    
    @IBAction func qtyMinusAction(_ sender: UIButton) {
        
    }
    
    @IBAction func qtyPlusAction(_ sender: Any) {
        
    }
    
}

// MARK: - Extension For Functions
//===========================
extension ProductDetailPopUpVC {
    
    private func initialSetup() {
         button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
         paymentMethodTxtField.setButtonToRightView(btn: button, selectedImage: #imageLiteral(resourceName: "dropDownButton"), normalImage: #imageLiteral(resourceName: "dropDownButton"), size: CGSize(width: 20, height: 20))
        self.cancelBtn.backgroundColor = .white
        self.cancelBtn.setTitleColor(#colorLiteral(red: 1, green: 0.1215686275, blue: 0.1764705882, alpha: 1), for: .normal)
        self.cancelBtn.borderColor = #colorLiteral(red: 1, green: 0.1215686275, blue: 0.1764705882, alpha: 1)
        self.cancelBtn.borderLineWidth = 1.0
    }
}

