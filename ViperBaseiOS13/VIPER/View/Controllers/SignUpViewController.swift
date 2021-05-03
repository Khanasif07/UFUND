//
//  SignUpViewController.swift
//  ViperBaseiOS13
//
//  Created by Deepika on 21/11/19.
//  Copyright © 2019 CSS. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper
import Firebase
import TwitterKit
import LinkedinSwift
import AuthenticationServices

enum UserType: String {
    
    case investor = "1"
    case campaigner = "2"
    
    
}
class SignUpViewController: UIViewController {
    
     
    var fcmToken: String?
    var socialLoginType: SocialLoginType = .facebook
//    var appleButton = ASAuthorizationAppleIDButton()
    fileprivate var socialLogin = SocialLoginHelper ()
    var signInModel: SignInModel?
    
    
    
    @IBOutlet weak var twitterLbl: UILabel!
    @IBOutlet weak var facebookLbl: UILabel!
    @IBOutlet weak var socialLoginViews1: UIStackView!
    @IBOutlet weak var socialLoginViews: UIStackView!
    @IBOutlet weak var lastNameTxtFld: UITextField!
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var phoneNumberTxtFld: UITextField!
    @IBOutlet weak var linkedinBtn: UIButton!
    @IBOutlet weak var nameTxtFld: UITextField!
    @IBOutlet weak var attributedLbl: UILabel!
    @IBOutlet weak var faceBookButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var TwitterBtn: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var emailIdTxtFld: UITextField!
    @IBOutlet weak var socialBtnStackView: UIStackView!
    @IBOutlet weak var privacyAttributedLbl: UILabel!
    
    
    var param = [String: AnyObject]()
    private lazy var loader  : UIView = {
        return createActivityIndicator(self.view)
    }()
    var signUpModel: SignUpModel?
    var viewEffect = 0 {
        didSet {
            
            UIView.animate(withDuration: 0.1) {
                for view in self.stackView.subviews {
                    
                    view.applyEffectToView()
                    
                }
            }
        }
    }
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addAppleLoginButtton()
        loginEffect = 0
        viewEffect = 0
        nameTxtFld.delegate = self
        lastNameTxtFld.delegate = self
        phoneNumberTxtFld.delegate = self
        emailIdTxtFld.delegate = self
        passwordTxtFld.delegate = self
        setFont()
        emailIdTxtFld.keyboardType = .emailAddress
        phoneNumberTxtFld.keyboardType = .numberPad
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        localize()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
    }
    
    @IBAction func privacyUrlBtnTapped(_ sender: UIButton) {
    }
    
    @IBAction func faceBookBtnAction(_ sender: UIButton) {
        self.socialLoginType = .facebook
        FacebookController.shared.getFacebookUserInfo(fromViewController: self, isSilentLogin: false, success: { [weak self] (model) in
            guard let _ = self else {return}
            print(model)
            self?.hitSocialLoginAPI(name: model.name, email: model.email, socialId: model.id, socialType: self!.socialLoginType)
            }, failure: { (error) in
                print(error?.localizedDescription.description ?? "")
        })
    }
    
    @IBAction func twitterBtnAction(_ sender: UIButton) {
        self.socialLoginType = .twitter
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
                        let recivedEmailID = email ?? ""   // received email
                        self.hitSocialLoginAPI(name: firstName, email: recivedEmailID, socialId: session?.userID ?? "", socialType: self.socialLoginType)
                        
                    }else {
                        print("error: \(String(describing: error?.localizedDescription))");
                        let firstName = session?.userName ?? ""   // received first name
                        let recivedEmailID = email ?? ""   // received email
                        self.hitSocialLoginAPI(name: firstName, email: recivedEmailID, socialId: session?.userID ?? "", socialType: self.socialLoginType)
                    }
                }
            }else {
                print("error: \(String(describing: error?.localizedDescription))");
            }
        }
    }
    
    @IBAction func googleBtnAction(_ sender: UIButton) {
        self.socialLoginType = .google
        GoogleLoginController.shared.login(fromViewController: self, success: { [weak self] (model) in
            guard let _ = self else {return}
            print(model)
            self?.hitSocialLoginAPI(name: model.name, email: model.email, socialId: model.id, socialType: self!.socialLoginType)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    @IBAction func linkedinBtnAction(_ sender: UIButton) {
        self.socialLoginType = .linkedin
        self.linkedLogin(vc: self)
    }
    
}

//MARK: - Localization
extension SignUpViewController {
    
    func localize() {
        
        twitterLbl.text = Constants.string.google.localize()
        facebookLbl.text = Constants.string.facebook.localize()
        titleLbl.text = Constants.string.signUp.localize().uppercased()
        signUpButton.setGradientBackground()
        attributedLbl.halfTextColorChange(fullText: Constants.string.donotHaveSignInAccount.localize(), changeText: Constants.string.signIn.localize())
        self.setUpAttributedString()
        signUpButton.titleLabel?.textColor = UIColor(hex: appBGColor)
        signUpButton.setTitle(Constants.string.signUp.localize().uppercased(), for: .normal)
        emailIdTxtFld.applyEffectToTextField(placeHolderString: Constants.string.emailId.localize())
        nameTxtFld.applyEffectToTextField(placeHolderString: Constants.string.firstName.localize())
        lastNameTxtFld.applyEffectToTextField(placeHolderString: Constants.string.lastName.localize())
        phoneNumberTxtFld.applyEffectToTextField(placeHolderString: Constants.string.phoneNumber.localize())
        passwordTxtFld.applyEffectToTextField(placeHolderString: Constants.string.password.localize())
        
    }
    
    private func setUpAttributedString(){
        let attributedString = NSMutableAttributedString(string: Constants.string.by_signing_up_you_agree_to_ufund_privacy_policy.localize(), attributes: [
            .font: UIFont.systemFont(ofSize: 12.0),
            .foregroundColor: UIColor.black
        ])
        let privactAttText = (NSAttributedString(string: Constants.string.privacy.localize(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.red,NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 13.0)]))
        attributedString.append(privactAttText)
        attributedString.append(NSAttributedString(string: "&", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black,NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0)]))
        attributedString.append(NSAttributedString(string: Constants.string.terms.localize(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.red,NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 13.0)]))
        privacyAttributedLbl.attributedText = attributedString
        privacyAttributedLbl.isUserInteractionEnabled = true
        privacyAttributedLbl.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.tapLabel(_:))))
        
    }
    
    @objc func tapLabel(_ gesture: UITapGestureRecognizer) {
        let string = "\(self.privacyAttributedLbl.text ?? "")"
        let termsAndCondition = Constants.string.terms.localize()
        let privacyPolicy = Constants.string.privacy.localize()
        if let range = string.range(of: privacyPolicy) {
            if gesture.didTapAttributedTextsInLabel(label: self.privacyAttributedLbl, inRange: NSRange(range, in: string)) {
                let vc = WebViewControllerVC.instantiate(fromAppStoryboard: .Products)
                vc.webViewType = .privacyPolicy
                self.navigationController?.pushViewController(vc, animated: true)
//                guard let url = URL(string: baseUrl + "/" + "privacy-policy") else { return }
//                UIApplication.shared.open(url)
            } else if let range = string.range(of: termsAndCondition)  {
                if gesture.didTapAttributedTextsInLabel(label: self.privacyAttributedLbl, inRange: NSRange(range, in: string)) {
                    let vc = WebViewControllerVC.instantiate(fromAppStoryboard: .Products)
                    vc.webViewType = .termsCondition
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    func setFont() {
        attributedLbl.textAlignment = .center
        passwordTxtFld.setupPasswordTextField()
    }
    
    
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
            
            
            linkedinHelper.requestURL("https://api.linkedin.com/v2/me?projection=(id,firstName,lastName,profilePicture(displayImage~:playableStreams))", requestType: LinkedinSwiftRequestGet, success: { (response) -> Void in
                
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
}

//MARK: - Button Actions
extension SignUpViewController {
    
    @IBAction func redirectToSignIn(_ sender: UIButton) {
        guard let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.SignInViewController) as? SignInViewController else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func signUpClickEvent(_ sender: UIButton) {
        guard let email = self.validateEmail() else { return }
        
        guard let firstName = nameTxtFld.text, !firstName.isEmpty else {
            ToastManager.show(title:  ErrorMessage.list.enterName.localize(), state: .error)
            return
        }
        
        guard let lastName = lastNameTxtFld.text, !lastName.isEmpty else {
            ToastManager.show(title:  ErrorMessage.list.enterLastName.localize(), state: .error)
            return
        }
        
        guard let phoneNumber = phoneNumberTxtFld.text, !phoneNumber.isEmpty else {
            ToastManager.show(title:  ErrorMessage.list.enterPhoneNumber.localize(), state: .error)
            return
        }
        
        
        guard let password = passwordTxtFld.text, !password.isEmpty else {
            ToastManager.show(title:  ErrorMessage.list.enterPassword.localize(), state: .error)
            return
        }
        
        let userType = UserDefaults.standard.value(forKey: UserDefaultsKey.key.isFromInvestor) as? String
        self.loader.isHidden = false
        param[RegisterParam.keys.device_type] = nullStringToEmpty(string: deviceType.rawValue) as AnyObject
        param[RegisterParam.keys.email] =  nullStringToEmpty(string: email) as AnyObject
        param[RegisterParam.keys.password] = nullStringToEmpty(string: password) as AnyObject
        param[RegisterParam.keys.name] =  nullStringToEmpty(string: firstName) as AnyObject
        param[RegisterParam.keys.last_name] = nullStringToEmpty(string: lastName) as AnyObject
        param[RegisterParam.keys.mobile] =  nullStringToEmpty(string: phoneNumber) as AnyObject
        param[RegisterParam.keys.user_type] = nullStringToEmpty(string: userType) as AnyObject
        self.presenter?.HITAPI(api: Base.signUp.rawValue, params: param, methodType: .POST, modelClass: SignUpModel.self, token: false)
        
    }
 
}

//MARK: - UITextField Delegate
extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        view.endEditingForce()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditingForce()
        return true
    }
}
extension SignUpViewController {
    
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


//MARK: - PresenterOutputProtocol

extension SignUpViewController: PresenterOutputProtocol {
    
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        
        switch api {
        case Base.signUp.rawValue:
            
            self.loader.isHidden = true
            self.signUpModel = dataDict as? SignUpModel
            ToastManager.show(title:  SuccessMessage.string.emailVerifySuccess.localize(), state: .success)
            self.navigationController?.popViewController(animated: true)
            
        case Base.social_signup.rawValue:
            self.loader.isHidden = true
            self.signInModel = (dataDict as? SocialLoginEntity)?.user_info
            CommonUserDefaults.storeUserData(from: self.signInModel)
            User.main.accessToken = (dataDict as? SocialLoginEntity)?.access_token
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
//            }
            
        default:
            break
        }
    }
    
    func showSuccessWithParams(statusCode: Int, params: [String : Any], api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        if statusCode == StatusCode.socialSignupSuccessCode.rawValue {
            let vc = LoginWithEmailVC.instantiate(fromAppStoryboard: .Products)
            vc.socialLoginType = socialLoginType
            vc.name = params[RegisterParam.keys.name] as? String ?? ""
            vc.email = params[RegisterParam.keys.email] as? String ?? ""
            vc.socialId = params[RegisterParam.keys.social_id] as? String ?? ""
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func showError(error: CustomError) {
        self.loader.isHidden = true
        ToastManager.show(title:  nullStringToEmpty(string: error.localizedDescription.trimString()), state: .error)
    }
}



extension SignUpViewController: AppleSignInProtocal {
    
    func getAppleLoginData(loginData: [String:Any]) {
        self.socialLoginType = .apple
        print(loginData)
        self.hitSocialLoginAPI(name: loginData[RegisterParam.keys.name] as? String ?? "", email: loginData[RegisterParam.keys.email] as? String ?? "" , socialId: loginData[RegisterParam.keys.socialId] as? String ?? "", socialType: self.socialLoginType)
    }
    
    func hitSocialLoginAPI(name : String , email : String , socialId : String , socialType : SocialLoginType){
        let params: [String:Any] = [RegisterParam.keys.name: name,RegisterParam.keys.email: "",RegisterParam.keys.signup_by: socialType.rawValue,RegisterParam.keys.social_id: socialId,RegisterParam.keys.is_manual: 0,RegisterParam.keys.device_token: nullStringToEmpty(string: fcmToken) as AnyObject,
                                    RegisterParam.keys.device_id: nullStringToEmpty(string: deviceIds) as AnyObject, RegisterParam.keys.device_type: nullStringToEmpty(string: deviceType.rawValue) as AnyObject]
        self.presenter?.HITAPI(api: Base.social_signup.rawValue, params: params, methodType: .POST, modelClass: SignUpModel.self, token: false)
        
    }
}
