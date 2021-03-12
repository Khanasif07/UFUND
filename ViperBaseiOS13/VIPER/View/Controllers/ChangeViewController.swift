//
//  ChangeViewController.swift
//  ViperBaseiOS13
//
//  Created by Deepika on 22/11/19.
//  Copyright © 2019 CSS. All rights reserved.
//

import UIKit
import ObjectMapper

class ChangeViewController: UIViewController {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var currentPwTxFld: UITextField!
    @IBOutlet weak var cureentView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var newPasswordTxtFld: UITextField!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var confirmPasswordTxtFld: UITextField!
    @IBOutlet weak var changePWButton: UIButton!
    private lazy var loader  : UIView = {
                return createActivityIndicator(self.view)
     }()
    var userProfile: UserProfile?
    var successDict: SuccessDict?
    @IBOutlet weak var passwordView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        
        emailView.applyEffectToView()
        passwordView.applyEffectToView()
        cureentView.applyEffectToView()
        
        newPasswordTxtFld.isSecureTextEntry = true
        confirmPasswordTxtFld.isSecureTextEntry = true
        
        newPasswordTxtFld.delegate = self
        confirmPasswordTxtFld.delegate = self
        currentPwTxFld.delegate = self
        
        profilePic.setCornerRadius()
        
        applyButton.setGradientBackground()
        cancelButton.setGradientBackground()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        localize()
    }
}


//MARK: - Localization
extension ChangeViewController {
    
    func localize() {
        
        nameLbl.textColor = UIColor(hex: darkTextColor)
        nameLbl.text = nullStringToEmpty(string: userProfile?.name)
        currentPwTxFld.applyEffectToTextField(placeHolderString: Constants.string.currentPassword.localize())
        newPasswordTxtFld.applyEffectToTextField(placeHolderString: Constants.string.newPassword.localize())
        
        confirmPasswordTxtFld.applyEffectToTextField(placeHolderString: Constants.string.confirmPassword.localize())
        titleLbl.textColor = UIColor(hex: darkTextColor)
        
        let url = URL.init(string: baseUrl + "/" +  nullStringToEmpty(string: self.userProfile?.picture))
        self.profilePic.sd_setImage(with: url , placeholderImage: #imageLiteral(resourceName: "profile"))
        self.profilePic.cornerRadius = profilePic.frame.height / 2
        self.profilePic.maskToBounds = true
        self.profilePic.backgroundColor = UIColor(hex: primaryColor)
        
        titleLbl.text = Constants.string.changePassword.localize().uppercased()
        changePWButton.setTitle(Constants.string.changePassword.localize().uppercased(), for: .normal)
        changePWButton.setGradientBackground()
        
        cancelButton.setTitle(Constants.string.Cancel.localize().uppercased(), for: .normal)
        applyButton.setTitle(Constants.string.apply.localize().uppercased(), for: .normal)
        
    }
    
}


//MARK: - Button Action
extension ChangeViewController {
    
    @IBAction func changePasswordClick(_ sender: UIButton) {
        
        
        guard let currentPassword = currentPwTxFld.text, !currentPassword.isEmpty else {
            ToastManager.show(title:  ErrorMessage.list.enterCurrentPassword.localize(), state: .error)
            return
        }
        
        guard let newPassword = newPasswordTxtFld.text, !newPassword.isEmpty else {
            ToastManager.show(title:  ErrorMessage.list.enterNewPassword.localize(), state: .error)
            return
        }
        
        guard let confirmPassword = confirmPasswordTxtFld.text, !confirmPassword.isEmpty else {
            ToastManager.show(title:  ErrorMessage.list.enterConfirmPwd.localize(), state: .error)
            return
        }
        
        guard confirmPassword == newPassword else {
            ToastManager.show(title:  ErrorMessage.list.misMatch.localize(), state: .error)
            return
        }
        var param = [String: AnyObject]()
        param[RegisterParam.keys.old_password] = nullStringToEmpty(string: currentPassword) as AnyObject
        param[RegisterParam.keys.password] = nullStringToEmpty(string: newPassword) as AnyObject
        param[RegisterParam.keys.password_confirmation] = nullStringToEmpty(string: confirmPassword) as AnyObject
        print(">>>param",param)
        self.loader.isHidden = true
        self.presenter?.HITAPI(api: Base.changePassword.rawValue, params: param, methodType: .POST, modelClass: SuccessDict.self, token: true)
        
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelClickEvent(_ sender: UIButton) {
         self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func applyClickEvent(_ sender: UIButton) {
          self.navigationController?.popViewController(animated: true)
    }
    
    
}

//MARK: - UITextField Delegate
extension ChangeViewController: UITextFieldDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        view.endEditingForce()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditingForce()
        return true
    }
}

//MARK: - PresenterOutputProtocol

extension ChangeViewController: PresenterOutputProtocol {
    
  
    
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        
        switch api {
       
        
        case Base.changePassword.rawValue:
            
            self.loader.isHidden = true
            self.successDict = dataDict as? SuccessDict
            ToastManager.show(title:  nullStringToEmpty(string: successDict?.success?.msg), state: .success)
            
        default:
            break
        }
    }
    
    func showError(error: CustomError) {
         self.loader.isHidden = true
         ToastManager.show(title:  nullStringToEmpty(string: error.localizedDescription.trimString()), state: .error)
    }
}
