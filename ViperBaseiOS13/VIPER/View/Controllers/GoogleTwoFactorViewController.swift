//
//  GoogleTwoFactorViewController.swift
//  ViperBaseiOS13
//
//  Created by Deepika on 24/12/19.
//  Copyright © 2019 CSS. All rights reserved.
//

import UIKit
import ObjectMapper

class GoogleTwoFactorViewController: UIViewController {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var qrImg: UIImageView!
    @IBOutlet weak var gAuthTxtFld: UITextField!
    @IBOutlet weak var keytxtFld: UITextField!
    @IBOutlet weak var activeButton: UIButton!
    var viewEffect = 0 {
        didSet {
            
            UIView.animate(withDuration: 0.1) {
                for view in self.stackView.subviews {
                    
                    view.applyEffectToView()
                    
                }
            }
        }
    }
    var secrateKey:  Secret?
    let registerParam = RegisterParam()
    var params = [String: AnyObject]()
    var successInfo: ((SuccessDict?)-> Void)?
    var successMsg: SuccessDict?
    private lazy var loader  : UIView = {
        return createActivityIndicator(self.view)
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewEffect = 0
        activeButton.setGradientBackground()
        activeButton.setTitle(Constants.string.activate.localize(), for: .normal)
        gAuthTxtFld.applyEffectToTextField(placeHolderString: Constants.string.enterPINingoogleAuthentication.localize())
        keytxtFld.applyEffectToTextField(placeHolderString: Constants.string.key.localize())
        titleLbl.text = Constants.string.googleTwoFactor.uppercased().localize()
        getGoogleFactor()
        keytxtFld.isUserInteractionEnabled = false
        gAuthTxtFld.isUserInteractionEnabled = true
        gAuthTxtFld.keyboardType = .decimalPad
        gAuthTxtFld.delegate = self
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        } 
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        //self.navigationController?.popViewController(animated: true)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func copyAddress(_ sender: UIButton) {
        UIPasteboard.general.string =  nullStringToEmpty(string: secrateKey?.secret)
        ToastManager.show(title: nullStringToEmpty(string: Constants.string.copyAddress.localize()), state: .success)
    }
    
    @IBAction func activeGAuth(_ sender: UIButton) {
       
        guard let text = gAuthTxtFld.text, !text.isEmpty else {
             ToastManager.show(title: nullStringToEmpty(string: ErrorMessage.list.enterOTP), state: .error)
            return
        }
        
        params[registerParam.totp] = nullStringToEmpty(string: text) as AnyObject
        self.loader.isHidden = false
        postGoogleFactor(params: params)
        
    }
}


extension GoogleTwoFactorViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == gAuthTxtFld {
            
            textField.becomeFirstResponder()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditingForce()
        return true
    }
}


//MARK: - PresenterOutputProtocol

extension GoogleTwoFactorViewController: PresenterOutputProtocol {
    
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        
        if api == Base.enableGoogle.rawValue {
            
            self.loader.isHidden = true
            self.secrateKey = dataDict as? Secret
            keytxtFld.text = nullStringToEmpty(string: self.secrateKey?.secret)
            let genarateQRString = "otpauth://totp/" + nullStringToEmpty(string: User.main.email) + "?secret=" + nullStringToEmpty(string: self.secrateKey?.secret) + "&issuer=" +  Constants.string.appName
            print(">>>>>.genarateQRString",genarateQRString)
            qrImg.image = Common.CreateQrCodeForyourString(string: genarateQRString)
            
            gAuthTxtFld.isUserInteractionEnabled = true
            
        } else if api == Base.checkEnable.rawValue {
            
            self.loader.isHidden = true
            self.successMsg = dataDict as? SuccessDict
            
            if self.successMsg?.success?.msg != nil {
                
                self.successInfo?(self.successMsg)
                ToastManager.show(title:  SuccessMessage.string.gTwoEnable.localize(), state: .success)
         
                self.dismiss(animated: true, completion: nil)
                
            } else {
                
                ToastManager.show(title: nullStringToEmpty(string: ErrorMessage.list.gtwoError), state: .error)
    
            }
            
        }
    }
    
    func showError(error: CustomError) {
        
        self.loader.isHidden = true
        ToastManager.show(title: nullStringToEmpty(string: error.localizedDescription.trimString()), state: .error)
    }
    
    func getGoogleFactor() {
        
        self.loader.isHidden = false
        self.presenter?.HITAPI(api: Base.enableGoogle.rawValue, params: nil, methodType: .GET, modelClass: Secret.self, token: true)
    }
    
    func postGoogleFactor(params: [String: AnyObject]) {
        
        self.loader.isHidden = false
        self.presenter?.HITAPI(api: Base.checkEnable.rawValue, params: params, methodType: .POST, modelClass: SuccessDict.self, token: true)
        
  }

}
