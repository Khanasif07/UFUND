//
//  OTPViewController.swift
//  KrytoX
//
//  Created by Deepika on 25/11/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit
import ObjectMapper

protocol GoogleAuthDelegate {
    
    func didReceivePinEnableStatus(isEnable: Bool, backAction: Bool)
}

class OTPViewController: UIViewController {
    
    //MARK: -Declarations.
    var successInfo: ((SuccessDict?)-> Void)?
    var successMsg: SuccessDict?
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var otpTxtFld: UITextField!
    @IBOutlet weak var otpLbl: UILabel!
    @IBOutlet weak var enterPassWordLbl: UILabel!
    @IBOutlet weak var tapGestureView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    var isFromDisableFlow = false
    var delegate: GoogleAuthDelegate?
    private lazy var loader  : UIView = {
        return createActivityIndicator(self.view)
    }()
    let registerParam = RegisterParam()
    var params = [String: AnyObject]()
    
    //MARK: -View life Cycles.
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        tapGestureView.backgroundColor = UIColor(hex: primaryColor)
        innerView.backgroundColor = UIColor.white
        applyShadowView(view: outerView)
        //        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        //        self.view.addGestureRecognizer(tap)
        otpTxtFld.isUserInteractionEnabled = true
        otpTxtFld.delegate = self
        otpTxtFld.keyboardType = .numberPad
        otpTxtFld.setLeftPaddingPoints(8)

    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        localize()
        setCustomFont()
    }
    
}


//MARK: - Custom Font & String Localization.
extension OTPViewController {
    
    func localize() {
        
        otpTxtFld.textColor = UIColor(hex: darkTextColor)
        otpTxtFld.placeholderColor()
        cancelButton.setTitle(Constants.string.Cancel.localize(), for: .normal)
        verifyButton.setTitle(Constants.string.disable.localize(), for: .normal)
        verifyButton.setTitleColor(UIColor(hex: darkTextColor), for: .normal)
        cancelButton.setTitleColor(UIColor(hex: darkTextColor), for: .normal)
        titleLbl.text = Constants.string.disableText.localize()
        titleLbl.textColor = UIColor(hex: darkTextColor)
    }
    
    func setCustomFont() {
        
        Common.setFont(to: titleLbl, isTitle: true, size: 14, fontType: .bold)
        Common.setFont(to: enterPassWordLbl, isTitle: true, size: 14, fontType: .bold)
        Common.setFont(to: otpLbl, isTitle: true, size: 14, fontType: .bold)
        Common.setFont(to: cancelButton, isTitle: true, size: 14, fontType: .bold)
        Common.setFont(to: verifyButton, isTitle: true, size: 14, fontType: .bold)
        Common.setFont(to: otpTxtFld, isTitle: true, size: 12, fontType: .bold)
    }
    
    
}


//MARK: - PresenterOutputProtocol
extension OTPViewController: PresenterOutputProtocol {
    func postGoogleFactor(params: [String: AnyObject]) {
        
        self.loader.isHidden = false
        self.presenter?.HITAPI(api: Base.gfavalidateotp.rawValue, params: params, methodType: .POST, modelClass: SuccessDict.self, token: true)
        
    }
    
    func disableG2F() {
        
        self.loader.isHidden = false
        self.presenter?.HITAPI(api: Base.disableGoogle.rawValue, params: params, methodType: .GET, modelClass: SuccessDict.self, token: true)
        
    }
    
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        
        switch nullStringToEmpty(string: api) {

        case Base.gfavalidateotp.rawValue:
            
              self.loader.isHidden = true
              self.successMsg = dataDict as? SuccessDict
            
            if self.successMsg?.success?.msg != nil
            {
                disableG2F()
                
            } else {
                toastSuccess(UIApplication.shared.keyWindow! , message: "Please check the otp, and try again...", smallFont: true, isPhoneX: true, color: UIColor.red)
            }
            
        case Base.disableGoogle.rawValue:
                   
                     self.loader.isHidden = true
                     self.successMsg = dataDict as? SuccessDict
                   
                   if self.successMsg?.success?.msg != nil
                   {
                       self.successInfo?(self.successMsg)
                       self.dismiss(animated: true, completion: nil)
                       
                   } else {
                       toastSuccess(UIApplication.shared.keyWindow! , message: "Please check the otp, and try again...", smallFont: true, isPhoneX: true, color: UIColor.red)
                   }
            
        default:
            break
        }
        
    }
    
    func showError(error: CustomError) {
        
        self.loader.isHidden = true
         ToastManager.show(title: nullStringToEmpty(string:  error.localizedDescription.trimString()) , state: .error)
    }
   
}


//MARK: - Button Action.
extension OTPViewController {
    
    @IBAction func cancelClickEvent(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func verifyClickEvent(_ sender: UIButton) {
        
        
        
        guard let text = otpTxtFld.text, !text.isEmpty else {
            ToastManager.show(title: nullStringToEmpty(string:  ErrorMessage.list.enterOTP.localize()) , state: .error)
           
            return
            
        }
        
         params[registerParam.totp] = nullStringToEmpty(string: text) as AnyObject
         self.loader.isHidden = false
         postGoogleFactor(params: params)
       
        
    }
}


//MARK: - Tap Gesture
extension OTPViewController {
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        
        if sender?.view != tapGestureView {
            
            self.dismiss(animated: true, completion: nil)
        }
    }
}





extension OTPViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditingForce()
        return true
    }
}

