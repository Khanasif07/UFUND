//
//  ForgetViewController.swift
//  ViperBaseiOS13
//
//  Created by Deepika on 22/11/19.
//  Copyright © 2019 CSS. All rights reserved.
//

import UIKit
import ObjectMapper

class ForgetViewController: UIViewController {

    @IBOutlet weak var forgotPwButton: UIButton!
    @IBOutlet weak var emailIdTxtFld: UITextField!
    @IBOutlet weak var emailIdView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descripLbl: UILabel!
    private lazy var loader  : UIView = {
               return createActivityIndicator(self.view)
    }()
    var param = [String: AnyObject]()
    var isFromG2F : Bool?
    var successDict: SuccessDict?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        } 
        emailIdView.applyEffectToView()
        emailIdTxtFld.applyEffectToTextField(placeHolderString: Constants.string.email.localize())
        forgotPwButton.setGradientBackground()
        forgotPwButton.setTitle(Constants.string.confirm.localize().uppercased(), for: .normal)
        setFont()
        if isFromG2F == true {
            descripLbl.text = Constants.string.disableG2FDesc.localize()
            titleLbl.text = Constants.string.disableTwoFactor.localize()
        } else {
            descripLbl.text = Constants.string.recoveryPw.localize()
            titleLbl.text = Constants.string.forgetPas.localize()
        }
        
        
        
    }
}

//MARK: - Button Action
extension ForgetViewController {
    
    func setFont() {
        forgotPwButton.titleLabel?.font = isDeviceIPad ? .setCustomFont(name: .medium, size: .x16) : .setCustomFont(name: .medium, size: .x14)
        self.titleLbl.font =  isDeviceIPad ? .setCustomFont(name: .bold, size: .x20) : .setCustomFont(name: .bold, size: .x14)
        self.emailIdTxtFld.font =  isDeviceIPad ? .setCustomFont(name: .medium, size: .x14) : .setCustomFont(name: .medium, size: .x12)
        descripLbl.font =  isDeviceIPad ? .setCustomFont(name: .medium, size: .x14) : .setCustomFont(name: .medium, size: .x12)
    }
  
    @IBAction func goBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func forgetPasswordClick(_ sender: UIButton) {
        
        guard let email = self.validateEmail() else { return }
         self.loader.isHidden = false
        
         param[RegisterParam.keys.email] =  nullStringToEmpty(string: email) as AnyObject
         
         if isFromG2F == true {
             self.presenter?.HITAPI(api: Base.disableBeforeLogin.rawValue, params: param, methodType: .POST, modelClass: SuccessDict.self, token: false)
         } else {
             self.presenter?.HITAPI(api: Base.forgotPassword.rawValue, params: param, methodType: .POST, modelClass: SuccessDict.self, token: false)
         }

    }
}

//MARK: - PresenterOutputProtocol

extension ForgetViewController: PresenterOutputProtocol {
    
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        
        switch api {
        case Base.forgotPassword.rawValue, Base.disableBeforeLogin.rawValue:
            
              self.loader.isHidden = true
              self.successDict = dataDict as? SuccessDict
              ToastManager.show(title:  nullStringToEmpty(string: self.successDict?.success?.msg), state: .success)
              self.navigationController?.popViewController(animated: true)
         
    
            
        default:
            break
        }
    }
    
    func showError(error: CustomError) {
         self.loader.isHidden = true
         ToastManager.show(title:  nullStringToEmpty(string: error.localizedDescription.trimString()), state: .error)
    }
}

extension ForgetViewController {
    
    private func validateEmail()->String? {
        
        guard let email = emailIdTxtFld.text?.trimmingCharacters(in: .whitespaces), !email.isEmpty else {
           
            ToastManager.show(title:  ErrorMessage.list.enterEmail.localize(), state: .error)
            return nil
        }
        guard Common.isValid(email: email) else {
               ToastManager.show(title:  ErrorMessage.list.enterValidEmail.localize(), state: .error)
           
            return nil
        }
        
        return email
    }
}

