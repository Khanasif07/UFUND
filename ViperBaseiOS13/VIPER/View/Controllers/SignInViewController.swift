//
//  SignInViewController.swift
//  ViperBaseiOS13
//
//  Created by Deepika on 21/11/19.
//  Copyright © 2019 CSS. All rights reserved.
//

import UIKit
import ObjectMapper
import TwitterKit
import FirebaseAnalytics
import Firebase
import LinkedinSwift
import GoogleSignIn


class SignInViewController: UIViewController {
    
    
    var socialLoginType: SocialLoginType = .facebook
    
    @IBOutlet weak var linkedinLbl: UILabel!
    @IBOutlet weak var googleLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var socialBtnStackView: UIStackView!
    @IBOutlet weak var gFDisableButton: UIButton!
    fileprivate var socialLogin = SocialLoginHelper ()
    @IBOutlet weak var twitterLbl: UILabel!
    @IBOutlet weak var facebookLbl: UILabel!
    @IBOutlet weak var socialLoginViews1: UIStackView!
    @IBOutlet weak var socialLoginViews: UIStackView!
    @IBOutlet weak var welcomeLbl: UILabel!
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var emailIdTxtFld: UITextField!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var attributedLbl: UILabel!
    var param = [String: AnyObject]()
    @IBOutlet weak var signInButton: UIButton!
    var fcmToken: String?
    
    @IBOutlet weak var forgetPWButton: UIButton!
    var viewEffect = 0 {
        didSet {
            
            UIView.animate(withDuration: 0.1) {
                for view in self.stackView.subviews {
                    
                    view.applyEffectToView()
                    
                }
            }
        }
    }
    var signUpModel: SignUpModel?
    var signInModel: SignInModel?
    var loginEffect = 0 {
        didSet {
            UIView.animate(withDuration: 0.1) {
                for view in self.socialLoginViews.subviews {
                    view.applyShadow()
                }
                for view in self.socialLoginViews1.subviews {
                    view.applyShadow()
                }
            }
        }
    }
    private lazy var loader  : UIView = {
          return createActivityIndicator(self.view)
    }()
    var socialLoginParams : [String:Any] = [:]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addAppleLoginButtton()
        viewEffect = 0
        loginEffect = 0
        emailIdTxtFld.delegate = self
        passwordTxtFld.delegate = self
        setFont()
        emailIdTxtFld.keyboardType = .emailAddress
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        localize()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
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
    
    //MARK: - Action
    //===================
    @IBAction func googleBtnAction(_ sender: UIButton) {
        socialLoginType = .google
        GoogleLoginController.shared.login(fromViewController: self, success: { [weak self] (model) in
            guard let _ = self else {return}
            print(model)
            self?.hitSocialLoginAPI(name: model.name, email: model.email, socialId: model.id, socialType: self!.socialLoginType)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    @IBAction func linkedinBtnAction(_ sender: UIButton) {
        socialLoginType = .linkedin
        self.linkedLogin(vc: self)
    }
    
    @IBAction func twiiterRedirection(_ sender: UIButton) {
        socialLoginType = .twitter
        TWTRTwitter.sharedInstance().logIn { (session, error) in
            if (session != nil) {
                
                let client = TWTRAPIClient.withCurrentUser()
                print("session",session)
                print("error",error)
                print("session?.userName",session?.userName)
                print("session?.userID",session?.userID)
                print("session?.accessToken",session?.authToken)
                
                client.requestEmail { email, error in
                    print("email",email)
                    print("error",error)
                    
                    if (email != nil) {
                        print("signed in as \(String(describing: session?.userName))");
                        let firstName = session?.userName ?? ""   // received first name
                        let lastName = session?.userName ?? ""  // received last name
                        let recivedEmailID = email ?? ""   // received email
                        self.hitSocialLoginAPI(name: firstName, email: recivedEmailID, socialId: session?.userID ?? "", socialType: self.socialLoginType)
                        
                    }else {
                        let firstName = session?.userName ?? ""   // received first name
                        let recivedEmailID = email ?? ""   // received email
                        self.hitSocialLoginAPI(name: firstName, email: recivedEmailID, socialId: session?.userID ?? "", socialType: self.socialLoginType)
                        print("error: \(String(describing: error?.localizedDescription))");
                    }
                }
            }else {
                print("error: \(String(describing: error?.localizedDescription))");
            }
        }
    }
    
    @IBAction func redirectToFacebook(_ sender: UIButton) {
        socialLoginType = .facebook
        FacebookController.shared.getFacebookUserInfo(fromViewController: self, isSilentLogin: false, success: { [weak self] (model) in
            guard let _ = self else {return}
            print(model)
            self?.hitSocialLoginAPI(name: model.name, email: model.email, socialId: model.id, socialType: self!.socialLoginType)
            }, failure: { (error) in
                print(error?.localizedDescription.description ?? "")
        })
    }
    
    
}

//MARK: - Localization
extension SignInViewController {
    
    private func addAppleLoginButtton(){
        AppleLoginController.shared.delegate = self
        AppleLoginController.shared.apploginButton(stackAppleLogin: self.socialBtnStackView, vc: self)
    }
    
    func linkedLogin(vc: UIViewController) {
           
           let linkedinHelper = LinkedinSwiftHelper(
               configuration: LinkedinSwiftConfiguration(clientId: AppConstants.linkedIn_Client_Id, clientSecret: AppConstants.linkedIn_ClientSecret, state: AppConstants.linkedIn_States, permissions: AppConstants.linkedIn_Permissions, redirectUrl: AppConstants.linkedIn_redirectUri)
           )
           
           linkedinHelper.authorizeSuccess({ [weak self] (lsToken)  -> Void in
               //Login success lsToken
               //https://api.linkedin.com/v2/emailAddress?q=members&projection=(elements*(handle~))
            //https://api.linkedin.com/v2/me?projection=(id,firstName,lastName,profilePicture(displayImage~:playableStreams))
            
            guard let _ = self else { return }
            linkedinHelper.requestURL("https://api.linkedin.com/v2/me?projection=(id,firstName,lastName)", requestType: LinkedinSwiftRequestGet, success: { [weak self] (response) -> Void in
                guard let _ = self else { return }
                guard let data = response.jsonObject else {return}
                if  let linkedinId = data["id"] as? String{
                    if  let firstNameDict = data["firstName"] as? [String:Any]{
                        if let firstName = firstNameDict["localized"] as?  [String:Any]{
                            let name = firstName["en_US"] as? String
                            print(name ?? "")
                            linkedinHelper.requestURL("https://api.linkedin.com/v2/emailAddress?q=members&projection=(elements*(handle~))", requestType: LinkedinSwiftRequestGet, success: { [weak self] (responsee) -> Void in
                                guard let _ = self else { return }
                                guard let data = responsee.jsonObject else {return}
                                if  let emailAddresDictArray = data["elements"] as? [[String:Any]]{
                                    if let emailAddresDict = emailAddresDictArray.first {
                                        if let emailAdress = emailAddresDict["handle~"] as? [String:Any]{
                                            let email = emailAdress["emailAddress"] as? String
                                            self?.hitSocialLoginAPI(name: name ?? "", email: email ?? "", socialId: linkedinId, socialType: self!.socialLoginType)
                                            print(email ?? "")
                                        }
                                    }
                                }
                            }) { (error) -> Void in
                                print(error.localizedDescription)
                            }
                        }
                    }
                }
                print(response)
//                linkedinHelper.logout()
               }) { (error) -> Void in
                   //                completionBlock?(false)
                   //Encounter error
                   print(error.localizedDescription)
               }
               
           }, error: { (error) -> Void in
               //Encounter error: error.localizedDescription
               //            completionBlock?(false)
               print(error.localizedDescription)
           }, cancel: { () -> Void in
               //User Cancelled!
               //            completionBlock?(false)
           })
       }
    
    func localize() {
        
        twitterLbl.text = Constants.string.google.localize()
        facebookLbl.text = Constants.string.facebook.localize()
        
        emailIdTxtFld.applyEffectToTextField(placeHolderString: Constants.string.email.localize())
        passwordTxtFld.applyEffectToTextField(placeHolderString: Constants.string.password.localize())
        welcomeLbl.text = Constants.string.signIn.localize()
        
        welcomeLbl.textColor = UIColor(hex: darkTextColor)
        
        signInButton.setGradientBackground()
        
        attributedLbl.halfTextColorChange(fullText: Constants.string.donotHaveAccount.localize(), changeText: Constants.string.signUp.localize())
        
        signInButton.titleLabel?.textColor = UIColor(hex: appBGColor)
        signInButton.setTitle(Constants.string.signIn.localize().uppercased(), for: .normal)
        forgetPWButton.setTitle(Constants.string.forgotPassword.localize(), for: .normal)
        forgetPWButton.setTitleColor(UIColor(hex: placeHolderColor), for: .normal)
        gFDisableButton.setTitle(Constants.string.disableTwoFactor.localize(), for: .normal)
        gFDisableButton.setTitleColor(UIColor(hex: placeHolderColor), for: .normal)
        
    }
    
    func setFont() {
        attributedLbl.textAlignment = .center
        passwordTxtFld.setupPasswordTextField()
        forgetPWButton.titleLabel?.font = isDeviceIPad ? .setCustomFont(name: .medium, size: .x16) : .setCustomFont(name: .medium, size: .x12)
        signInButton.titleLabel?.font = isDeviceIPad ? .setCustomFont(name: .medium, size: .x18) : .setCustomFont(name: .medium, size: .x14)
        self.welcomeLbl.font =  isDeviceIPad ? .setCustomFont(name: .bold, size: .x20) : .setCustomFont(name: .bold, size: .x14)
        [emailIdTxtFld,passwordTxtFld].forEach { (txtfield) in
            txtfield.font =  isDeviceIPad ? .setCustomFont(name: .medium, size: .x16) : .setCustomFont(name: .medium, size: .x12)
        }
        [googleLbl,twitterLbl,facebookLbl,linkedinLbl].forEach { (lbl) in
            lbl.font =  isDeviceIPad ? .setCustomFont(name: .medium, size: .x16) : .setCustomFont(name: .medium, size: .x12)
        }
    }
}

//MARK: - Button Action
extension SignInViewController {
    
    @IBAction func signInRedirectToHome(_ sender: UIButton) {
        
        guard let email = self.validateEmail() else { return }
        guard let password = passwordTxtFld.text, !password.isEmpty else {
            ToastManager.show(title:  ErrorMessage.list.enterPassword.localize(), state: .error)
            return
        }
        
        self.loader.isHidden = false
        param[RegisterParam.keys.email] = nullStringToEmpty(string: email) as AnyObject
        param[RegisterParam.keys.password] = nullStringToEmpty(string: password) as AnyObject
        param[RegisterParam.keys.device_token] = nullStringToEmpty(string: fcmToken) as AnyObject
        param[RegisterParam.keys.device_id] =  nullStringToEmpty(string: deviceIds) as AnyObject
        self.presenter?.HITAPI(api: Base.signIn.rawValue, params: param, methodType: .POST, modelClass: SignInModel.self, token: false)
    }
    
    @IBAction func redirectToSignUp(_ sender: UIButton) {
        guard let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.SignUpViewController) as? SignUpViewController else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func forgetPasswordClick(_ sender: UIButton) {
        guard let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.ForgetViewController) as? ForgetViewController else { return }
        vc.isFromG2F = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func disableG2F(_ sender: UIButton) {
       guard let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.ForgetViewController) as? ForgetViewController else { return }
         vc.isFromG2F = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - PresenterOutputProtocol

extension SignInViewController: PresenterOutputProtocol {
    
     
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
    }
    
    func showSuccessWithParams(statusCode: Int, params: [String : Any], api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        //
        switch api {
        case Base.signIn.rawValue:
            self.loader.isHidden = true
            self.signInModel = dataDict as? SignInModel
            CommonUserDefaults.storeUserData(from: self.signInModel)
            storeInUserDefaults()
            switch User.main.trulioo_kyc_status {
            case 0:
                let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.KYCMatiViewController) as! KYCMatiViewController
                self.navigationController?.pushViewController(vc, animated: true)
            case 1:
                let vc =  Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.DrawerController)
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.KYCMatiViewController) as! KYCMatiViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case  Base.social_signup.rawValue:
            self.loader.isHidden = true
            if statusCode == StatusCode.success.rawValue {
                self.signInModel = (dataDict as? SocialLoginEntity)?.user_info
                ToastManager.show(title:  nullStringToEmpty(string: (dataDict as? SocialLoginEntity)?.message), state: .error)
                CommonUserDefaults.storeUserData(from: self.signInModel)
                User.main.accessToken = (dataDict as? SocialLoginEntity)?.access_token
                storeInUserDefaults()
                switch User.main.trulioo_kyc_status ?? -1{
                case 0:
                    let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.KYCMatiViewController) as! KYCMatiViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                    return
                case 1:
                    let vc =  Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.DrawerController)
                    self.navigationController?.pushViewController(vc, animated: true)
                    return
                default:
                    print("Do Nothing")
                }
            } else {
                if  statusCode == StatusCode.socialSignupSuccessCode.rawValue{
                    let vc = LoginWithEmailVC.instantiate(fromAppStoryboard: .Products)
                    vc.socialLoginSuccess = { [weak self] in
                        guard let selff = self else { return }
                        switch User.main.trulioo_kyc_status {
                        case 0:
                            let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.KYCMatiViewController) as! KYCMatiViewController
                            self?.navigationController?.pushViewController(vc, animated: true)
                        case 1:
                            let vc =  Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.DrawerController)
                            self?.navigationController?.pushViewController(vc, animated: true)
                        default:
                            let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.KYCMatiViewController) as! KYCMatiViewController
                            self?.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                    vc.socialLoginFailure = { [weak self] in
                    guard let selff = self else { return }
                        //Sonu will let us know
                        print("")
                    }
                    vc.socialLoginType = self.socialLoginType
                    vc.name = params[RegisterParam.keys.name] as? String ?? ""
                    vc.email = params[RegisterParam.keys.email] as? String ?? ""
                    vc.socialId = params[RegisterParam.keys.social_id] as? String ?? ""
                    self.present(vc, animated: true, completion: nil)
                } else{
                    ToastManager.show(title:  nullStringToEmpty(string: (dataDict as? SocialLoginEntity)?.message), state: .error)
                }
            }
        default:
            break
        }
        //
        
    }
    
    func showError(error: CustomError) {
        self.loader.isHidden = true
        if error.statusCode == StatusCode.socialSignupSuccessCode.rawValue {
            let vc = LoginWithEmailVC.instantiate(fromAppStoryboard: .Products)
            vc.socialLoginSuccess = { [weak self] in
                guard let selff = self else { return }
                switch User.main.trulioo_kyc_status {
                case 0:
                    let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.KYCMatiViewController) as! KYCMatiViewController
                    selff.navigationController?.pushViewController(vc, animated: true)
                case 1:
                    let vc =  Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.DrawerController)
                    selff.navigationController?.pushViewController(vc, animated: true)
                default:
                    let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.KYCMatiViewController) as! KYCMatiViewController
                    selff.navigationController?.pushViewController(vc, animated: true)
                }
            }
            vc.socialLoginFailure = { [weak self] in
            guard let selff = self else { return }
                //Sonu will let us know
                print(selff)
            }
            vc.socialLoginType = socialLoginType
            vc.name = socialLoginParams[RegisterParam.keys.name] as? String ?? ""
            vc.email = socialLoginParams[RegisterParam.keys.email] as? String ?? ""
            vc.socialId = socialLoginParams[RegisterParam.keys.social_id] as? String ?? ""
            self.present(vc, animated: true, completion: nil)
            return
        }
        ToastManager.show(title:  nullStringToEmpty(string: error.localizedDescription.trimString()), state: .error)
    }
}

//MARK: - UITextField Delegate
extension SignInViewController: UITextFieldDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        view.endEditingForce()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditingForce()
        return true
    }
    
}


extension SignInViewController {
    
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



extension SignInViewController: AppleSignInProtocal {
    func getAppleLoginData(loginData: [String:Any]) {
         socialLoginType = .apple
         self.hitSocialLoginAPI(name: loginData[RegisterParam.keys.name] as? String ?? "", email: loginData[RegisterParam.keys.email] as? String ?? "" , socialId: loginData[RegisterParam.keys.socialId] as? String ?? "", socialType: self.socialLoginType)
    }
    
    func hitSocialLoginAPI(name : String , email : String , socialId : String , socialType :SocialLoginType){
        self.loader.isHidden = false
        let params: [String:Any] = [RegisterParam.keys.name: name,RegisterParam.keys.email: "",RegisterParam.keys.signup_by: socialType.rawValue,RegisterParam.keys.social_id: socialId,RegisterParam.keys.is_manual: 0,RegisterParam.keys.device_token: nullStringToEmpty(string: fcmToken) as AnyObject,
                                    RegisterParam.keys.device_id: nullStringToEmpty(string: deviceIds) as AnyObject, RegisterParam.keys.device_type: nullStringToEmpty(string: deviceType.rawValue) as AnyObject]
        self.socialLoginParams = params
        self.presenter?.HITAPI(api: Base.social_signup.rawValue, params: params, methodType: .POST, modelClass: SocialLoginEntity.self, token: false)
        
    }
}
