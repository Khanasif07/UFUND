//
//  SecurityViewController.swift
//  Project
//
//  Created by Deepika on 23/09/19.
//  Copyright © 2019 css. All rights reserved.
//

import UIKit
import ObjectMapper
import LocalAuthentication


class SecurityViewController: UIViewController {
    
    var userDetails: UserDetails?
    var userProfile: UserProfile?
    @IBOutlet weak var backImg: UIImageView!
    @IBOutlet weak var parentView: UIView!
    private var security = [Constants.string.pinAuth.localize(),Constants.string.digitalId.localize()]
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var titleLbl: UILabel!
    private lazy var loader  : UIView = {
        return createActivityIndicator(self.view)
    }()
    var successMsg: SuccessDict?
    var msg = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        self.tableView.register(UINib.init(nibName: XIB.Names.SecurityCell, bundle: nil), forCellReuseIdentifier: XIB.Names.SecurityCell)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        getProfileDetails()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        localize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //MARK: Show Alert
    func showAlertWithTitle( title:String, message:String ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let actionOk = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(actionOk)
        self.present(alert, animated: true, completion: nil)
    }
    
}

//MARK: - Font Custom & Localization.
extension SecurityViewController {
    
    func localize() {
        
        titleLbl.text = Constants.string.security.localize().uppercased()
        titleLbl.textColor = UIColor(hex: darkTextColor)
        
        
    }
}

extension SecurityViewController {
    @IBAction func goBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- Show Custom Toast
extension SecurityViewController {
    private func showToast(string : String?) {
       
    }
}

//MARK: - PresenterOutputProtocol
extension SecurityViewController: PresenterOutputProtocol {
    
    func showSuccess(api: String, dataArray: [Mappable]?, dataDict: Mappable?, modelClass: Any) {
        
        switch api {
       
        case Base.profile.rawValue:
            
            self.loader.isHidden = true
            self.userDetails = dataDict as? UserDetails
            self.userProfile = self.userDetails?.user
            User.main.pin_status =  self.userProfile?.app_pin_status
            
            storeInUserDefaults()
            self.tableView.reloadData()
        
        case nullStringToEmpty(string: Base.disableGoogle.rawValue):
            
            self.loader.isHidden = true
            self.successMsg = dataDict as? SuccessDict
            ToastManager.show(title:  nullStringToEmpty(string: self.successMsg?.success?.msg), state: .success)
          
            storeInUserDefaults()
            loadProfileDetailsREfresh()
            
        case nullStringToEmpty(string: Base.pinstatus.rawValue):
            
            self.loader.isHidden = true
            User.main.pin_status = 0
            storeInUserDefaults()
            self.successMsg = dataDict as? SuccessDict
            ToastManager.show(title:  nullStringToEmpty(string: self.successMsg?.success?.msg), state: .success)
            
        default:
            break
        }
        
    }
    
    func showError(error: CustomError) {
        
        self.loader.isHidden = true
       
               ToastManager.show(title:  nullStringToEmpty(string: error.localizedDescription.trimString()), state: .error)
    }
    
    
    
   func loadProfileDetailsREfresh() {
          
          self.presenter?.HITAPI(api: Base.profile.rawValue, params: nil, methodType: .GET, modelClass: UserDetails.self, token: true)
    }
    
     func getProfileDetails() {
           self.loader.isHidden = false
           self.presenter?.HITAPI(api: Base.profile.rawValue, params: nil, methodType: .GET, modelClass: UserDetails.self, token: true)
    }
    
    func disAbleAuth() {
        
        self.loader.isHidden = false
        self.presenter?.HITAPI(api: Base.disableGoogle.rawValue, params: nil, methodType: .GET, modelClass: SuccessDict.self, token: true)
    }
    
   func disablPin() {
          
          self.loader.isHidden = false
          self.presenter?.HITAPI(api: Base.pinstatus.rawValue, params: nil, methodType: .GET, modelClass: SuccessDict.self, token: true)
      }
    
}

extension SecurityViewController {
    
    func disableGoogleAuth() {
           
           let customAlertViewController = OTPViewController(nibName: "OTPViewController", bundle: nil)
           customAlertViewController.successInfo = {sucess in
               self.successMsg = sucess
               
               self.disAbleAuth()
           }
           customAlertViewController.providesPresentationContextTransitionStyle = true;
           customAlertViewController.definesPresentationContext = true;
           customAlertViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
           customAlertViewController.view.backgroundColor = UIColor(white: 0, alpha: 0.25)
           self.present(customAlertViewController, animated: false, completion: nil)
           
           
       }
}

//MARK: - UITableViewDelegate & UITableViewDataSource
extension SecurityViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return security.count > 0 ? security.count : 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.SecurityCell, for: indexPath) as! SecurityCell
        
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.darkTheme()
        cell.switchToogle.tag = indexPath.row
        cell.switchToogle.addTarget(self, action: #selector(switchEnableAction), for: .touchUpInside)
        cell.securityTitle.text = nullStringToEmpty(string: security[indexPath.row])
        
        if  self.userProfile != nil {
            switch indexPath.row {
           
            case 0:
                cell.hiddenButton.isHidden = true
                if  self.userProfile?.app_pin_status == 0 {
                    cell.switchToogle.isOn = false
                    cell.switchToogle.setOn(false, animated: true)
                } else {
                    cell.switchToogle.isOn = true
                    cell.switchToogle.setOn(true, animated: true)
                }
            default:
                break
            }
        }
        
          
        if indexPath.row == 1 {
                
                cell.hiddenButton.isHidden = false
                cell.hiddenButton.tag = indexPath.row
                cell.hiddenButton.addTarget(self, action: #selector(enableDigitalId), for: .touchUpInside)
                
                if let digitalId =  UserDefaults.standard.value(forKey: "digitalId") as? Int {

                    if digitalId == 0 {
                        cell.switchToogle.isOn = false
                        cell.switchToogle.setOn(false, animated: true)
                    } else {
                        cell.switchToogle.isOn = true
                        cell.switchToogle.setOn(true, animated: true)
                    }
                } else {
                    cell.switchToogle.isOn = false
                    cell.switchToogle.setOn(false, animated: true)
                }
        }
        
        return  cell
    }

    @objc func enableDigitalId(sender: UIButton) {
        
      
        
        switch sender.tag {
        case 0:
        
          break
            
            
        case 1:
            if let digitalId =  UserDefaults.standard.value(forKey: "digitalId") as? Int {
                
                if digitalId == 1 {
                    
                    UserDefaults.standard.set(0, forKey: "digitalId")
                    ToastManager.show(title: nullStringToEmpty(string: "Digital Id Disable Successfully"), state: .success)
                   
                    self.tableView.reloadData()
                    
                } else {
                    
                    self.Authenticate { (success) in
                        print(">>>>>>>",success)
                        
                    }
                    
                }
            } else {
                self.Authenticate { (success) in
                    print(">>>>>>>",success)
                    
                }
            }
            
            
        default:
            break
        }
        
    }
    
    @objc func switchEnableAction(sender: UISwitch) {
        
        if security.count > sender.tag {
            
            
            switch sender.tag {
          
                       case 0:
                           if (sender.isOn == true) {
                               
                               let vc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.OtpController) as! OtpController
                               vc.successInfo = {sucess in
                                   self.successMsg = sucess
                                   self.getProfileDetails()
                               }
                               self.navigationController?.pushViewController(vc, animated: true)
                           } else {
                               disablPin()
                           }
            default:
             
                
                if (sender.isOn == true) {
                    
                    let result = isFaceIdSupported()
                    print("result***",result)
                    if result == true {
                        
                        self.Authenticate { (success) in
                            print(">>>>>>>",success)
                            
                            UserDefaults.standard.set(1, forKey: "digitalId")
                            
                        }
                        
                        DispatchQueue.main.async {
        
                            self.tableView.reloadData()
                            
                        }
                        
                    } else {
                        
                        UserDefaults.standard.set(0, forKey: "digitalId")
                        DispatchQueue.main.async {
                            
                            self.tableView.reloadData()
                        }
                        
                    }
                } else {
                    UserDefaults.standard.set(0, forKey: "digitalId")
                    DispatchQueue.main.async {
                          ToastManager.show(title: nullStringToEmpty(string: "DigitalId Disable Successfully"), state: .success)
                        
                        self.tableView.reloadData()
                    }
                }
            }
            
        }
    }
}


func isFaceIdSupported() -> Bool {
    
    let localAuthenticationContext = LAContext()
    if #available(iOS 11.0, *) {
        if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            return localAuthenticationContext.biometryType == LABiometryType.touchID || localAuthenticationContext.biometryType == LABiometryType.faceID
        }
    }
    
    return false
}



extension SecurityViewController {
    
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
                            UserDefaults.standard.set(1, forKey: "digitalId")
                        
                              ToastManager.show(title: nullStringToEmpty(string: "Digital Id Enable Successfully"), state: .success)
                             self.tableView.reloadData()
                        }
                         
                        print("******success",success)
                    } else {
                        //If not recognized then
                        print("******not reconise",error?.localizedDescription)
                        if let error = error {
                            print(">>>>>>>>>ERRO",error._code)
                        
                        }
                       
                              
                        DispatchQueue.main.async {
                                                   UserDefaults.standard.set(0, forKey: "digitalId")
                            self.tableView.reloadData()
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
    
}

