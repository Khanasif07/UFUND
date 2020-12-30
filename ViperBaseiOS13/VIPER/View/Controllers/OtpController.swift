//
//  OtpController.swift
//  GoJekUser
//
//  Created by CSS15 on 30/09/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import LocalAuthentication

protocol PinEnableDelegate {
    
    func didReceivePinEnable(isEnable: Bool?)
}
public enum passcodeStatus: String {
    case new = "SET PIN"
    case verify = "RE-ENTER PIN"
    case ready = "Verified"
    case wrong = "Wrong passcode"
}

class OtpController: UIViewController {
    
    @IBAction func biometricCheck(_ sender: UIButton) {
        self.view.endEditingForce()
        let result = isFaceIdSupported()
        print("result***",result)
        if result == true {
            
            self.Authenticate { (success) in
                print(">>>>>>>",success)
                
              
            }
    
        }
        
    }
    
    @IBOutlet weak var biometricView: UIView!
    @IBOutlet weak var unlockLbl: UILabel!
    @IBOutlet weak var fingerPrintImg: UIImageView!
    @IBOutlet weak var headerText: UILabel!
    @IBAction func goBack(_ sender: UIButton) {
      
        if changePINStr == "changePINStr" {
          logout()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    @IBOutlet weak var trxtLabel: GradientLabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thirdTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var fourthTextField: UITextField!
    @IBOutlet weak var otpVerifyButton: UIButton!
    @IBOutlet weak var sixTextField: UITextField!
    @IBOutlet weak var fiveTextField: UITextField!
    
    var isprofile = false
    var countryCode = ""
    var phoneNumber = ""
    var successInfo: ((SuccessDict?)-> Void)?
    var successMsg: SuccessDict?
    var pinEnableDelegate : PinEnableDelegate?
    var passcode: String = ""
      var repeatedPasscode: String = ""
      var status: passcodeStatus = .new
      var changePINStr = ""
      let registerParam = RegisterParam()
      var params = [String: AnyObject]()
      var successMsgPin:  SuccessDict?
      var isFromLogin: String?
    private lazy var loader  : UIView = {
               return createActivityIndicator(self.view)
      }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initalLoads()
        themeAppearence()
        overrideUserInterfaceStyle = .light 
    }
    
    func themeAppearence() {
           
           if changePINStr != "" {
              
                if User.main.pin_status == 1 {
                    titleLabel.text = Constants.string.enterPins.localize()
               } else {
                     titleLabel.text = Constants.string.loginPassCode.localize()
               }
            
            if let digitalId = UserDefaults.standard.value(forKey: "digitalId")  as? Int {
                                  print(">>>>digitalId",digitalId)
                                  switch digitalId {
                                  case 1:
                                       biometricView.isHidden = true
                                   let result = isFaceIdSupported()
                                          print("result***",result)
                                          if result == true {
                                              
                                              self.Authenticate { (success) in
                                                  print(">>>>>>>",success)
                                                  
                                                
                                              }
                                      
                                          }
                                  default:
                                      biometricView.isHidden = true
                                  }
                              } else {
                                  biometricView.isHidden = true
                              }
            
           } else {
            biometricView.isHidden = true
               titleLabel.text = Constants.string.passCodeHeaderStr.localize()
           }
       }
}

extension OtpController {
   
    func changePasscodeStatus(_ newStatus: passcodeStatus) {
           
        status = newStatus
        
        if status == .wrong {
            
            ToastManager.show(title:  nullStringToEmpty(string: ErrorMessage.list.wrongPinMessage.localize()), state: .error)
            repeatedPasscode = ""
            changeNumsIcons(0)
            firstTextField.text = ""
            secondTextField.text = ""
            thirdTextField.text = ""
            fourthTextField.text = ""
            fiveTextField.text = ""
            sixTextField.text = ""
            
        } else if status == .ready {
            
            
            if changePINStr == "" {
                let inputDisablePinParam = [registerParam.pin:  repeatedPasscode]
                enablePin(params: inputDisablePinParam as [String : AnyObject])
            } else {
                
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: SideMenuController.self) {
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                }
            }
            
        } else if status == .verify {
            
            titleLabel.text = Constants.string.confirmPin.localize()
            firstTextField.text = ""
            secondTextField.text = ""
            thirdTextField.text = ""
            fourthTextField.text = ""
            fiveTextField.text = ""
            sixTextField.text = ""
            changeNumsIcons(0)
            
        }
        
    }
    
    
       func changeNumsIcons(_ nums: Int) {

       }
}

extension OtpController {
    
    private func initalLoads() {
        
        headerText.text = Constants.string.twoFA.localize().uppercased()
        trxtLabel.text = Constants.string.appName.localize().uppercased()
        trxtLabel.gradientColors = [UIColor(hex: "#E30000").cgColor, UIColor(hex: "#CC4343").cgColor]
             
        titleLabel.text = Constants.string.PleasePIN.localize().uppercased()
        otpVerifyButton.setGradientBackground()
        
        otpVerifyButton.addTarget(self, action: #selector(tapOtpVerify), for: .touchUpInside)
        
        otpVerifyButton.setTitle(Constants.string.Done.localize().uppercased(), for: .normal)
       
        
        
        otpVerifyButton.setTitleColor(.white, for: .normal)
        otpVerifyButton.titleLabel?.font = .setCustomFont(name: .bold, size: .x20)
        titleLabel.font = .setCustomFont(name: .bold, size: .x22)
        
        firstTextField.delegate = self
        secondTextField.delegate = self
        thirdTextField.delegate = self
        fourthTextField.delegate = self
        sixTextField.delegate = self
        fiveTextField.delegate = self
        
        
        firstTextField.keyboardType = .decimalPad
        secondTextField.keyboardType = .decimalPad
        thirdTextField.keyboardType = .decimalPad
        fourthTextField.keyboardType = .decimalPad
        sixTextField.keyboardType = .decimalPad
        fiveTextField.keyboardType = .decimalPad
        
        
        firstTextField.becomeFirstResponder()
        addTextEditChangedAction()
        
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        firstTextField.textAlignment = .center
        secondTextField.textAlignment = .center
        thirdTextField.textAlignment = .center
        fourthTextField.textAlignment = .center
        sixTextField.textAlignment = .center
        fiveTextField.textAlignment = .center
    }
    
    func addTextEditChangedAction() {
        firstTextField.addTarget(self, action: #selector(textEditChanged(_:)), for: .editingChanged)
        secondTextField.addTarget(self, action: #selector(textEditChanged(_:)), for: .editingChanged)
        thirdTextField.addTarget(self, action: #selector(textEditChanged(_:)), for: .editingChanged)
        fourthTextField.addTarget(self, action: #selector(textEditChanged(_:)), for: .editingChanged)
        fiveTextField.addTarget(self, action: #selector(textEditChanged(_:)), for: .editingChanged)
        sixTextField.addTarget(self, action: #selector(textEditChanged(_:)), for: .editingChanged)
    }
    @objc func tapOtpVerify() {
        
        self.view.endEditing(true)
        
        guard let otp1 = firstTextField.text, !otp1.isEmpty else {
            ToastManager.show(title: Constants.string.InvalidOTP.localize() , state: .error)
            return
        }
        
        guard let otp2 = secondTextField.text, !otp2.isEmpty else {
            ToastManager.show(title: Constants.string.InvalidOTP.localize() , state: .error)
            return
        }
        
        guard let otp3 = thirdTextField.text, !otp3.isEmpty else {
            ToastManager.show(title: Constants.string.InvalidOTP.localize() , state: .error)
            return
        }
        
        guard let otp4 = fourthTextField.text, !otp4.isEmpty else {
            ToastManager.show(title: Constants.string.InvalidOTP.localize() , state: .error)
            return
        }
        
        guard let otp5 = fiveTextField.text, !otp5.isEmpty else {
            ToastManager.show(title: Constants.string.InvalidOTP.localize() , state: .error)
            return
        }
        
        
        guard let otp6 = sixTextField.text, !otp6.isEmpty else {
            ToastManager.show(title: Constants.string.InvalidOTP.localize() , state: .error)
            return
        }
        
        var otp: [String] = []
        otp.append(otp1)
        otp.append(otp2)
        otp.append(otp3)
        otp.append(otp4)
        otp.append(otp5)
        otp.append(otp6)
        
         print(">>>otp",otp)
        let checkOtp = otp.joined()
        
        
        print(">>>checkOtp",checkOtp)
        
        print(">>status",status)
        if status == .new {
                   passcode += checkOtp
                   
                   changeNumsIcons(passcode.count)
                   
                   if passcode.count == 6 {
                       let newStatus: passcodeStatus = .verify
                       
                       if changePINStr != "" {
                        
                            params[registerParam.totp] =  nullStringToEmpty(string: passcode) as AnyObject
                           
                       
                               postCheckPin(params: params)
                           
                           
                           
                       } else {
                           changePasscodeStatus(newStatus)
                       }
                       
                   }
               } else if status == .verify {
                   repeatedPasscode += checkOtp
                   changeNumsIcons(repeatedPasscode.count)
                   if repeatedPasscode.count == 6 {
                       let newStatus: passcodeStatus = repeatedPasscode == passcode ? .ready : .wrong
                       changePasscodeStatus(newStatus)
                   }
               } else if status == .wrong {
                   changePasscodeStatus(.verify)
                   repeatedPasscode += checkOtp
                   changeNumsIcons(repeatedPasscode.count)
               }
        
    }

}

extension OtpController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField.textAlignment = .center
 
        textField.text = ""
        if textField.text == ""
        {
            print("Backspace has been pressed")
        }
        
        if string == "" {
            print("Backspace was pressed")
            switch textField {
                
            case secondTextField:
                firstTextField.becomeFirstResponder()
            case thirdTextField:
                secondTextField.becomeFirstResponder()
            case fourthTextField:
                thirdTextField.becomeFirstResponder()
                
                case fiveTextField:
                             fourthTextField.becomeFirstResponder()
                
            case sixTextField:
                fiveTextField.becomeFirstResponder()
                
            default:
                print("default")
            }
            textField.text = ""
            
            return false
        }
        return true
    }
    
    @objc func textEditChanged(_ sender: UITextField) {
         
        print("textEditChanged has been pressed")
        let count = sender.text?.count
        
        print("textFieldCpunt",count)
        if count == 1{
            switch sender {
            case firstTextField:
                secondTextField.becomeFirstResponder()
                 sender.textAlignment = .center
            case secondTextField:
                thirdTextField.becomeFirstResponder()
                 sender.textAlignment = .center
            case thirdTextField:
                fourthTextField.becomeFirstResponder()
                 sender.textAlignment = .center
            case fourthTextField:
               
                fiveTextField.becomeFirstResponder()
                 sender.textAlignment = .center
                
            case fiveTextField:
                sixTextField.becomeFirstResponder()
                 sender.textAlignment = .center
            
            case sixTextField:
                 sixTextField.resignFirstResponder()
                 sender.textAlignment = .center
                
            default:
                print("default")
            }
        }
      
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
          textField.textAlignment = .center
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
          textField.textAlignment = .center
        if !(textField.text?.isEmpty)!{
            //textField.selectAll(self)
        }else{
            print("Empty")
            textField.text = " "
        }
    }
}


extension OtpController {
    
    func enablePin(params: [String: AnyObject]) {
        
      self.loader.isHidden = false
        self.presenter?.HITAPI(api: Base.pin.rawValue, params: params, methodType: .POST, modelClass: SuccessDict.self, token: true)
        
    }
}


//MARK: - PresenterOutputProtocol

extension OtpController: PresenterOutputProtocol {
   
    
    
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        
        if api == Base.pin.rawValue {

            self.loader.isHidden =  true
            self.successMsg = dataDict as? SuccessDict

            self.successInfo?(self.successMsg)

            ToastManager.show(title: nullStringToEmpty(string: self.successMsg?.success?.msg), state: .success)
          

            self.navigationController?.popViewController(animated: true)

        } else if api == Base.gfavalidateotp.rawValue {

            self.successMsg = dataDict as? SuccessDict

            if self.successMsg?.success != nil {
                self.loader.isHidden =  true
                self.push(id: Storyboard.Ids.DrawerController, animation: true)
            } else {

                postCheckPin(params: params)
            }
        } else if api == Base.checkpin.rawValue {

            self.successMsgPin = dataDict as? SuccessDict

            if self.successMsgPin?.success != nil {
                self.loader.isHidden =  true
                self.push(id: Storyboard.Ids.DrawerController, animation: true)
            } else {

                self.loader.isHidden =  true
                self.passcode.removeAll()
                self.changeNumsIcons(self.passcode.count)
                ToastManager.show(title: nullStringToEmpty(string: "Pin Not Matched"), state: .error)
                firstTextField.text = ""
                secondTextField.text = ""
                thirdTextField.text = ""
                fourthTextField.text = ""
                fiveTextField.text = ""
                sixTextField.text = ""
            }


        } else if api == Base.logout.rawValue {

            self.loader.isHidden =  true
            clearUserDefaults()
            let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.TutorialViewController) as! TutorialViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func showError(error: CustomError) {
        
        self.loader.isHidden =  true
        self.passcode.removeAll()
        self.changeNumsIcons(self.passcode.count)
        
        if nullStringToEmpty(string: error.localizedDescription.trimString()) == "Please check the otp, and try again..." {
             postCheckPin(params: params)
        } else {
            firstTextField.text = ""
            secondTextField.text = ""
            thirdTextField.text = ""
            fourthTextField.text = ""
            fiveTextField.text = ""
            sixTextField.text = ""
            ToastManager.show(title: nullStringToEmpty(string: error.localizedDescription.trimString()), state: .error)
        }
       
    }
    
    
    func postGoogleFactor(params: [String: AnyObject]) {
        
      self.loader.isHidden = false
        
        self.presenter?.HITAPI(api: Base.gfavalidateotp.rawValue, params: params, methodType: .POST, modelClass: SuccessDict.self, token: true)
        
    }
    
    func postCheckPin(params: [String: AnyObject]) {
       
        self.presenter?.HITAPI(api: Base.checkpin.rawValue, params: params, methodType: .POST, modelClass: SuccessDict.self, token: true)
        
    }
    func logout() {
        
            self.loader.isHidden = false
            var param = [String: AnyObject]()
            param[RegisterParam.keys.id] = User.main.id as AnyObject
            self.presenter?.HITAPI(api: Base.logout.rawValue, params: param, methodType: .POST, modelClass: SuccessDict.self, token: true)
    }
    
    
    
}



extension OtpController {
    
    //MARK: TouchID error
    func errorMessage(errorCode:Int) -> String{
        
        var strMessage = ""
        
        switch errorCode {
            
        case LAError.Code.authenticationFailed.rawValue:
            strMessage = "Authentication Failed"
            
        case LAError.Code.userCancel.rawValue:
            strMessage = "User Cancel"
            
        case LAError.Code.systemCancel.rawValue:
            strMessage = "System Cancel"
            
        case LAError.Code.passcodeNotSet.rawValue:
            strMessage = "Please goto the Settings & Turn On Passcode"
            
            
        case LAError.Code.appCancel.rawValue:
            strMessage = "App Cancel"
            
        case LAError.Code.invalidContext.rawValue:
            strMessage = "Invalid Context"
            
            
        default:
            strMessage = "Application retry limit exceeded."
            
        }
        return strMessage
    }
    
    func Authenticate(completion: @escaping ((Bool) -> ())){
        
        //Create a context
        let authenticationContext = LAContext()
        var error:NSError?
        
        //Check if device have Biometric sensor
        let isValidSensor : Bool = authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        
        if isValidSensor {
            //Device have BiometricSensor
            //It Supports TouchID
            
            authenticationContext.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: "Touch / Face ID authentication",
                reply: { [unowned self] (success, error) -> Void in
                    
                    if(success) {
                        // Touch / Face ID recognized success here
                        completion(true)
                       DispatchQueue.main.async {
                                         self.push(id: Storyboard.Ids.DrawerController, animation: true)
                                     }
                    } else {
                        //If not recognized then
                        print("******not reconise",error?.localizedDescription)
                        if let error = error {
                            print(">>>>>>>>>ERRO",error._code)
                         
                        }
                        completion(false)
                    }
            })
        } else {
            
            let strMessage = self.errorMessage(errorCode: (error?._code)!)
            if strMessage != ""{
                self.showAlertWithTitle(title: "Error", message: strMessage)
            }
        }
        
    }
    
    //MARK: Show Alert
       func showAlertWithTitle( title:String, message:String ) {
           let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
           
           let actionOk = UIAlertAction(title: "OK", style: .default, handler: nil)
           alert.addAction(actionOk)
           self.present(alert, animated: true, completion: nil)
       }
}

