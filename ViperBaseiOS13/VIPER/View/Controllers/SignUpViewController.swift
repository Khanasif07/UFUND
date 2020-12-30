//
//  SignUpViewController.swift
//  ViperBaseiOS13
//
//  Created by Deepika on 21/11/19.
//  Copyright © 2019 CSS. All rights reserved.
//

import UIKit
import ObjectMapper
import TwitterKit
import AuthenticationServices

enum UserType: String {
    
    case investor = "1"
    case campaigner = "2"
    
    
}
class SignUpViewController: UIViewController {

    var appleButton = ASAuthorizationAppleIDButton()
    fileprivate var socialLogin = SocialLoginHelper ()
    @IBOutlet weak var twitterLbl: UILabel!
    @IBOutlet weak var facebookLbl: UILabel!
    @IBOutlet weak var socialLoginViews: UIStackView!
    @IBOutlet weak var lastNameTxtFld: UITextField!
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var phoneNumberTxtFld: UITextField!
    @IBOutlet weak var nameTxtFld: UITextField!
    @IBOutlet weak var attributedLbl: UILabel!
    @IBOutlet weak var faceBookButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var emailIdTxtFld: UITextField!
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
                }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginEffect = 0
        viewEffect = 0
        nameTxtFld.delegate = self
        lastNameTxtFld.delegate = self
        phoneNumberTxtFld.delegate = self
        emailIdTxtFld.delegate = self
        passwordTxtFld.delegate = self
        passwordTxtFld.isSecureTextEntry = true
        emailIdTxtFld.keyboardType = .emailAddress
        phoneNumberTxtFld.keyboardType = .numberPad
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
    
}

//MARK: - Localization
extension SignUpViewController {
    
    func localize() {
        
        twitterLbl.text = Constants.string.google.localize()
        facebookLbl.text = Constants.string.facebook.localize()
        titleLbl.text = Constants.string.signUp.localize().uppercased()
        signUpButton.setGradientBackground()
       
        attributedLbl.halfTextColorChange(fullText: Constants.string.donotHaveSignInAccount.localize(), changeText: Constants.string.signIn.localize())
        signUpButton.titleLabel?.textColor = UIColor(hex: appBGColor)
        signUpButton.setTitle(Constants.string.signUp.localize().uppercased(), for: .normal)
        emailIdTxtFld.applyEffectToTextField(placeHolderString: Constants.string.emailId.localize())
        nameTxtFld.applyEffectToTextField(placeHolderString: Constants.string.firstName.localize())
        lastNameTxtFld.applyEffectToTextField(placeHolderString: Constants.string.lastName.localize())
        phoneNumberTxtFld.applyEffectToTextField(placeHolderString: Constants.string.phoneNumber.localize())
        passwordTxtFld.applyEffectToTextField(placeHolderString: Constants.string.password.localize())
    
    }
    
    func setFont() {
        attributedLbl.textAlignment = .center
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
    @IBAction func facebookRedirection(_ sender: UIButton) {
        
        socialLogin.loginThroughFacebook(fromViewController: self, helperDelegate: self)
    }
    @IBAction func googleRedirection(_ sender: UIButton) {
        
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


                    }else {
                        print("error: \(String(describing: error?.localizedDescription))");
                    }
                }
            }else {
                print("error: \(String(describing: error?.localizedDescription))");
            }
        }
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
            
        default:
            break
        }
    }
    
    func showError(error: CustomError) {
         self.loader.isHidden = true
         ToastManager.show(title:  nullStringToEmpty(string: error.localizedDescription.trimString()), state: .error)
    }
}

// MARK: - Social login helper delegate methods
extension SignUpViewController : SocialLoginHelperDelegate {

    func didReceiveFacebookLoginUser(detail: FacebookUserDetail) {
        
        print("Name: \(detail.name)")
        print("UserName: \(detail.userName)")
        print("Email: \(detail.email)")
        print("UserId: \(detail.userId)")
    }
    
    func didReceiveFacebookLoginError(message: String) {
        
        print("******* didReceiveFacebookLoginError: \(message)")
    }
}
