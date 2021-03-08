//
//  LoginWithEmailVC.swift
//  ViperBaseiOS13
//
//  Created by Admin on 04/03/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import ObjectMapper
import UIKit
import Firebase

class LoginWithEmailVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var signInBtn: UIButton!
    // MARK: - Variables
    //===========================
    var socialLoginSuccess: (()->())?
    private lazy var loader  : UIView = {
          return createActivityIndicator(self.view)
      }()
    var fcmToken: String?
    var signInModel: SignInModel?
    var socialLoginType: SocialLoginType = .facebook
    var name: String = ""
    var email: String = ""
    var socialId:String = ""
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("deviceTokenString",deviceTokenString)
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                self.fcmToken = nullStringToEmpty(string: result.token)
                // self.instanceIDTokenMessage.text  = "Remote InstanceID token: \(result.token)"
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
           super.viewDidLayoutSubviews()
           self.signInBtn.setCornerRadius(cornerR: self.signInBtn.frame.height / 2)
           self.dataContainerView.dropShadow(cornerRadius: 10, color: UIColor.black16, offset: CGSize(width: 0.5, height: 0.5), opacity: 1, shadowRadius: 5)
       }
    
    // MARK: - IBActions
    //===========================
    @IBAction func signInBtnAction(_ sender: UIButton) {
        if email.isEmpty{
            ToastManager.show(title:  Constants.string.pleaseEnterEmailAddress.localize(), state: .error)
            return
        }
        self.hitSocialLoginAPI(name: name,email: email, socialId: socialId, socialType: socialLoginType)
    }
    
    
}

// MARK: - Extension For Functions
//===========================
extension LoginWithEmailVC {
    
    private func initialSetup() {
        emailTxtField.applyEffectToView()
        emailTxtField.delegate = self
    }
    
    func hitSocialLoginAPI(name : String , email : String , socialId : String , socialType : SocialLoginType){
        self.loader.isHidden = false
        let params: [String:Any] = [RegisterParam.keys.name: name,RegisterParam.keys.email: email,RegisterParam.keys.signup_by: socialType.rawValue,RegisterParam.keys.social_id: socialId,RegisterParam.keys.is_manual: 1,RegisterParam.keys.device_token: nullStringToEmpty(string: fcmToken) as AnyObject,
                                    RegisterParam.keys.device_id: nullStringToEmpty(string: deviceIds) as AnyObject, RegisterParam.keys.device_type: nullStringToEmpty(string: deviceType.rawValue) as AnyObject]
        self.presenter?.HITAPI(api: Base.social_signup.rawValue, params: params, methodType: .POST, modelClass: SocialLoginEntity.self, token: false)
        
    }
}


//MARK: - PresenterOutputProtocol

extension LoginWithEmailVC: PresenterOutputProtocol {
    
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        
        switch api {
        case Base.social_signup.rawValue:
            self.loader.isHidden = true
            self.signInModel = (dataDict as? SocialLoginEntity)?.user_info
            CommonUserDefaults.storeUserData(from: self.signInModel)
            User.main.accessToken = (dataDict as? SocialLoginEntity)?.access_token
            storeInUserDefaults()
            self.dismiss(animated: true) {
                if let handle = self.socialLoginSuccess{
                    handle()
                }
            }
//            if self.signInModel?.kyc == 0 {
//                guard let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.KYCMatiViewController) as? KYCMatiViewController  else { return }
//                self.navigationController?.pushViewController(vc, animated: true)
//            } else {
//                if User.main.g2f_temp == 1 || User.main.pin_status == 1  {
//                    guard let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.OtpController) as? OtpController else { return }
//                    vc.changePINStr = "changePINStr"
//                    self.navigationController?.pushViewController(vc, animated: true)
//
//                } else {
//                    ToastManager.show(title:  SuccessMessage.string.loginSucess.localize(), state: .success)
//                    self.push(id: Storyboard.Ids.DrawerController, animation: true)
//                }
//            }
            
        default:
            break
        }
    }
    func showError(error: CustomError) {
        self.loader.isHidden = true
        ToastManager.show(title:  nullStringToEmpty(string: error.localizedDescription.trimString()), state: .error)
    }
}


// MARK: - Extension For TextField Delegate
//====================================
extension LoginWithEmailVC : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        let text = textField.text?.byRemovingLeadingTrailingWhiteSpaces ?? ""
        self.email = text
    }
      
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return (string.checkIfValidCharaters(.email) || string.isEmpty) && newString.length <= 50
    }
}
    
