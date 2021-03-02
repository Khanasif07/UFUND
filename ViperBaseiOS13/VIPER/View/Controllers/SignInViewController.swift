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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addAppleLoginButtton()
        viewEffect = 0
        loginEffect = 0
        emailIdTxtFld.delegate = self
        passwordTxtFld.delegate = self
        passwordTxtFld.isSecureTextEntry = true
        emailIdTxtFld.keyboardType = .emailAddress
        overrideUserInterfaceStyle = .light 
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        localize()
        setFont()
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
           
           linkedinHelper.authorizeSuccess({ (lsToken) -> Void in
               //Login success lsToken
               
               
               linkedinHelper.requestURL("https://api.linkedin.com/v1/people/~:(id,first-name,last-name,email-address,headline,picture-url,public-profile-url)?format=json", requestType: LinkedinSwiftRequestGet, success: { (response) -> Void in
                   
                   guard let data = response.jsonObject else {return}
                   
                   if let email = data["emailAddress"] as? String, email.isEmpty {
                       //show toast
                       //                        AppToast.default.showToastMessage(message: LocalizedString.AllowEmailInLinkedIn.localized)
                       linkedinHelper.logout()
                   }
                   else {
                       //                        self.userData.authKey     = linkedinHelper.lsAccessToken?.accessToken ?? ""
                       //                        self.userData.firstName  = data["firstName"] as? String ?? ""
                       //                        self.userData.lastName  = data["lastName"]  as? String ?? ""
                       //                        self.userData.id            = data["id"] as? String ?? ""
                       //                        self.userData.service   = "linkedin_oauth2"
                       //                        self.userData.email      =  data["emailAddress"] as? String ?? ""
                       //                        self.userData.picture   = data["pictureUrl"] as? String ?? ""
                       
                       print(response)
                       //                    completionBlock?(true)
                       //                        self.webserviceForSocialLogin()
                       //                        linkedinHelper.logout()
                   }
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
        
        switch api {
        case Base.signIn.rawValue:
            
            self.loader.isHidden = true
            self.signInModel = dataDict as? SignInModel
            CommonUserDefaults.storeUserData(from: self.signInModel)
            storeInUserDefaults()
            
//            if self.signInModel?.kyc == 0 {
//                guard let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.KYCMatiViewController) as? KYCMatiViewController  else { return }
//                self.navigationController?.pushViewController(vc, animated: true)
//            } else {
                
                if User.main.g2f_temp == 1 || User.main.pin_status == 1  {

                   guard let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.OtpController) as? OtpController else { return }
                    vc.changePINStr = "changePINStr"
                    self.navigationController?.pushViewController(vc, animated: true)

                } else {
                    ToastManager.show(title:  SuccessMessage.string.loginSucess.localize(), state: .success)
                    self.push(id: Storyboard.Ids.DrawerController, animation: true)
                }
            
        case Base.social_signup.rawValue:
            self.loader.isHidden = true
            self.signInModel = (dataDict as? SocialLoginEntity)?.user_info
            CommonUserDefaults.storeUserData(from: self.signInModel)
            User.main.accessToken = (dataDict as? SocialLoginEntity)?.access_token
            storeInUserDefaults()
            if User.main.g2f_temp == 1 || User.main.pin_status == 1  {
                
                guard let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.OtpController) as? OtpController else { return }
                vc.changePINStr = "changePINStr"
                self.navigationController?.pushViewController(vc, animated: true)
                
            } else {
                ToastManager.show(title:  SuccessMessage.string.loginSucess.localize(), state: .success)
                self.push(id: Storyboard.Ids.DrawerController, animation: true)
            }
            
            // }
            
            
        default:
            break
        }
    }
    
    func showError(error: CustomError) {
         self.loader.isHidden = true
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
         self.hitSocialLoginAPI(name: loginData[RegisterParam.keys.name] as? String ?? "", email: loginData[RegisterParam.keys.email] as? String ?? "" , socialId: loginData[RegisterParam.keys.social_id] as? String ?? "", socialType: self.socialLoginType)
    }
    
    func hitSocialLoginAPI(name : String , email : String , socialId : String , socialType :SocialLoginType){
        self.loader.isHidden = false
        let params: [String:Any] = [RegisterParam.keys.name: name,RegisterParam.keys.email: email,RegisterParam.keys.signup_by: socialType.rawValue,RegisterParam.keys.social_id: socialId,RegisterParam.keys.is_manual: 0,RegisterParam.keys.device_token: nullStringToEmpty(string: fcmToken) as AnyObject,
                                    RegisterParam.keys.device_id: nullStringToEmpty(string: deviceIds) as AnyObject, RegisterParam.keys.device_type: nullStringToEmpty(string: deviceType.rawValue) as AnyObject]
        self.presenter?.HITAPI(api: Base.social_signup.rawValue, params: params, methodType: .POST, modelClass: SocialLoginEntity.self, token: false)
        
    }
}
