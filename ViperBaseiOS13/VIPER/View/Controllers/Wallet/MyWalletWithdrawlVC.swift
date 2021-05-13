//
//  MyWalletWithdrawlVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 13/05/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit
import iOSDropDown

class MyWalletWithdrawlVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var toAddressLbl: UILabel!
    @IBOutlet weak var addresstxtView: UIView!
    @IBOutlet weak var addAmtLbl: UILabel!
    @IBOutlet weak var withdrawlWalletLbl: UILabel!
    @IBOutlet weak var currencyTxtField: UITextField!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var amtTxtField: UITextField!
    @IBOutlet weak var addressTxtField: UITextField!
    @IBOutlet weak var proceedBtn: UIButton!
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var currencyControl: UISegmentedControl!
    // MARK: - Variables
    //===========================
    var selectedCurrencyType = "ETC"
    var  buttonView = UIButton()
    private lazy var loader  : UIView = {
           return createActivityIndicator(self.view)
       }()
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.proceedBtn.setCornerRadius()
        self.dataContainerView.roundCorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 15.0)
    }
    
    
    // MARK: - IBActions
    //===========================
    
    @IBAction func withdrawlBtnAction(_ sender: UIButton) {
        
    }
    
    @IBAction func crossBtnAction(_ sender: UIButton) {
        self.popOrDismiss(animation: true)
    }
    
}

// MARK: - Extension For Functions
//===========================
extension MyWalletWithdrawlVC: UITextFieldDelegate {
    
    private func initialSetup() {
        self.setFont()
        self.currencyTxtField.delegate = self
        self.amtTxtField.keyboardType = .numberPad
        currencyControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        buttonView.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        currencyTxtField.setButtonToRightView(btn: buttonView, selectedImage: #imageLiteral(resourceName: "icDropdown"), normalImage: #imageLiteral(resourceName: "icDropdown"), size: CGSize(width: 20, height: 20))
        currencyTxtField.text =  self.selectedCurrencyType
    }
    
    private func setFont(){
//        currencyControl.setTitleTextAttributes([NSAttributedString.Key.font: isDeviceIPad ? 20 : 15], for: .normal)
        self.currencyTxtField.font =  isDeviceIPad ? .setCustomFont(name: .medium, size: .x20) : .setCustomFont(name: .medium, size: .x15)
        self.amtTxtField.font =  isDeviceIPad ? .setCustomFont(name: .regular, size: .x28) : .setCustomFont(name: .regular, size: .x24)
        self.addressTxtField.font =  isDeviceIPad ? .setCustomFont(name: .regular, size: .x18) : .setCustomFont(name: .regular, size: .x14)
        self.withdrawlWalletLbl.font =  isDeviceIPad ? .setCustomFont(name: .regular, size: .x20) : .setCustomFont(name: .regular, size: .x16)
        self.addAmtLbl.font =  isDeviceIPad ? .setCustomFont(name: .semiBold, size: .x18) : .setCustomFont(name: .semiBold, size: .x14)
        self.toAddressLbl.font =  isDeviceIPad ? .setCustomFont(name: .semiBold, size: .x18) : .setCustomFont(name: .semiBold, size: .x14)
        self.descLbl.font =  isDeviceIPad ? .setCustomFont(name: .regular, size: .x16) : .setCustomFont(name: .regular, size: .x12)
        self.proceedBtn.titleLabel?.font =  isDeviceIPad ? .setCustomFont(name: .bold, size: .x20) : .setCustomFont(name: .bold, size: .x16)
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            currencyTxtField.setButtonToRightView(btn: buttonView, selectedImage: #imageLiteral(resourceName: "icDropdown"), normalImage: #imageLiteral(resourceName: "icDropdown"), size: CGSize(width: 20, height: 20))
            currencyTxtField.text =  self.selectedCurrencyType
            currencyTxtField.isUserInteractionEnabled = true
            addresstxtView.isHidden = false
        } else {
            addresstxtView.isHidden = true
            currencyTxtField.rightView = nil
            currencyTxtField.inputView = nil
            currencyTxtField.text = " Dollar (USD)"
            currencyTxtField.isUserInteractionEnabled = false
        }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        _ = textField.text?.byRemovingLeadingTrailingWhiteSpaces ?? ""
        self.view.endEditing(true)
        guard let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.ProductSortVC) as? ProductSortVC else { return }
        vc.delegate = self
        vc.usingForSort = .filter
        vc.sortArray = [("ETC",false),("BITCOIN",false)]
        vc.sortTypeApplied = self.selectedCurrencyType
        self.present(vc, animated: true, completion: nil)
    }
      
      func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
          if range.location == 0 && (string == " ") {
              return false
          }
          return true
      }
    
}


//MARK:- Sorting
//==============
extension MyWalletWithdrawlVC: ProductSortVCDelegate{
    
    func sortingApplied(sortType: String){
        self.selectedCurrencyType = sortType
        currencyTxtField.text =  self.selectedCurrencyType
    }
}

