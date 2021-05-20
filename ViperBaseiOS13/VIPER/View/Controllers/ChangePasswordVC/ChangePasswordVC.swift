//
//  ChangePasswordVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 26/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import UIKit
import ObjectMapper

class ChangePasswordVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPassWordTextField: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    // MARK: - Variables
    //===========================
    public lazy var loader  : UIView = {
        return createActivityIndicator(self.view)
    }()
    var userProfile: UserProfile?
    var successDict: SuccessDict?
    var placeHolderArr : [String] = [Constants.string.enterOldPassWord,
                                     Constants.string.enterNewPassWord,
                                     Constants.string.enterConfirmPassWord
    ]
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.containerView.dropShadow(cornerRadius: 10, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 5)
        self.submitBtn.setCornerRadius(cornerR: 5.0)
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.popOrDismiss(animation: true)
    }
    
    @IBAction func submitBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        guard let currentPassword = oldPasswordTextField.text, !currentPassword.isEmpty else {
            ToastManager.show(title:  ErrorMessage.list.enterCurrentPassword.localize(), state: .error)
            return
        }

        guard let newPassword = newPasswordTextField.text, !newPassword.isEmpty else {
            ToastManager.show(title:  ErrorMessage.list.enterNewPassword.localize(), state: .error)
            return
        }

        guard let confirmPassword = confirmPassWordTextField.text, !confirmPassword.isEmpty else {
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
        self.loader.isHidden = false
        self.presenter?.HITAPI(api: Base.changePassword.rawValue, params: param, methodType: .POST, modelClass: SuccessDict.self, token: true)
    }
    
    func getLogout() {
        self.loader.isHidden = false
        var param = [String: AnyObject]()
        param[RegisterParam.keys.id] = User.main.id as AnyObject
        self.presenter?.HITAPI(api: Base.logout.rawValue, params: param, methodType: .POST, modelClass: SuccessDict.self, token: true)
    }
    
    private func setUpFont(){
        self.titleLbl.font = isDeviceIPad ? .setCustomFont(name: .bold, size: .x20) : .setCustomFont(name: .bold, size: .x16)
        self.submitBtn.titleLabel?.font =  isDeviceIPad ? .setCustomFont(name: .semiBold, size: .x18) : .setCustomFont(name: .semiBold, size: .x14)
        [oldPasswordTextField,newPasswordTextField,confirmPassWordTextField].forEach { (textFIeld) in
            textFIeld?.font =  isDeviceIPad ? .setCustomFont(name: .medium, size: .x16) : .setCustomFont(name: .regular, size: .x12)
        }
    }

    
}

// MARK: - Extension For Functions
//===========================
extension ChangePasswordVC {
    
    private func initialSetup() {
        self.setUpTextField()
        self.setUpFont()
    }
    
    func setUpTextField(){
        self.titleLbl.font =  isDeviceIPad ? .setCustomFont(name: .bold, size: .x20) : .setCustomFont(name: .semiBold, size: .x16)
        for (index,txtField) in [oldPasswordTextField,newPasswordTextField,confirmPassWordTextField].enumerated() {
            txtField?.delegate = self
            txtField?.placeholder = placeHolderArr[index]
            txtField?.textColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
            txtField?.setupPasswordTextField()
        }
    }
    
    private func submitBtnStatus()-> Bool{
        return !self.oldPasswordTextField.text!.isEmpty && !self.newPasswordTextField.text!.isEmpty && !self.confirmPassWordTextField.text!.isEmpty
    }

}


// MARK: - TextField Delegate
//===========================
extension ChangePasswordVC : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return (string.checkIfValidCharaters(.password) || string.isEmpty) && newString.length <= 25
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let text = textField.text?.byRemovingLeadingTrailingWhiteSpaces ?? ""
        switch textField {
        case oldPasswordTextField:
            self.oldPasswordTextField.text = text
//            self.submitBtn.isEnabled = submitBtnStatus()
        case newPasswordTextField:
            self.newPasswordTextField.text = text
//            self.submitBtn.isEnabled = submitBtnStatus()
        case confirmPassWordTextField:
            self.confirmPassWordTextField.text = text
//            self.submitBtn.isEnabled = submitBtnStatus()
        default:
            print(text)
        }
        
    }
}


//MARK: - PresenterOutputProtocol
extension ChangePasswordVC: PresenterOutputProtocol {
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        switch api {
        case Base.changePassword.rawValue:
            self.loader.isHidden = true
            self.successDict = dataDict as? SuccessDict
            let popUpVC = EditProfilePopUpVC.instantiate(fromAppStoryboard: .Main)
            popUpVC.titleValue = "Successful Password Reset"
            popUpVC.btnValue = "Go to Log In"
            popUpVC.titleImgValue = #imageLiteral(resourceName: "icInformation")
            popUpVC.descValue = "You can now use you new password to log in to your account"
            popUpVC.editProfileSuccess = { [weak self] (sender) in
                guard let selff = self else { return }
                selff.getLogout()
            }
            self.present(popUpVC, animated: true, completion: nil)
            
        case Base.logout.rawValue:
            self.loader.isHidden = true
            self.drawerController?.closeSide()
            forceLogout(with: SuccessMessage.string.logoutMsg.localize())
            
            
        default:
            break
        }
    }
    
    func showError(error: CustomError) {
        self.loader.isHidden = true
        ToastManager.show(title:  nullStringToEmpty(string: error.localizedDescription.trimString()), state: .error)
    }
}
