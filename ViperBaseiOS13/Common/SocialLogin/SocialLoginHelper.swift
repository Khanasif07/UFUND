//
//  SocialLoginHelper.swift
//
//
//  Created by Deepika Prakash
//


protocol SocialLoginHelperDelegate {
    
    /**
     This delegate will be called when facebook login success.
     - parameter detail: Facebook user detail will be passed as details.
     */
    func didReceiveFacebookLoginUser (detail: FacebookUserDetail)
    

    
    /**
     This delegate will be called when facebook login fails with error.
     - parameter message: Facebook login failed error message.
     */
    func didReceiveFacebookLoginError (message: String)
    
    
}

import UIKit
import FBSDKLoginKit


class SocialLoginHelper: NSObject {

    // MARK: - Declarations
    
    fileprivate var delegate: SocialLoginHelperDelegate!
    fileprivate var mainViewController: UIViewController!
    
    // MARK: - Facebook login methods
    
    /**
     To login through facebook authentication.
     - parameter fromViewController: Viewcontroller from which needs to be handled.
     - parameter helperDelegate: SocialLoginHelperDelegate to handle success or failure in view controller.
     */
    func loginThroughFacebook (fromViewController: UIViewController, helperDelegate: SocialLoginHelperDelegate) {
        
        var userDetail: [String: AnyObject] = [:]
        delegate = helperDelegate
        mainViewController = fromViewController
        
        let fbLoginManager : LoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["email", "public_profile"], from: fromViewController) { (result, error) in
            if (error == nil){
                let fbloginresult : LoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email")) {
                        if((AccessToken.current) != nil){
                            GraphRequest(graphPath: "me", parameters: ["fields": "email,name"]).start(completionHandler: { (connection, result, error) -> Void in
                                if (error == nil){
                                    userDetail = result as! [String : AnyObject]
                                    print("userDetail",userDetail)
                                    let facebookUserDetail = FacebookUserDetail(dictionary: userDetail)
                                    self.delegate.didReceiveFacebookLoginUser(detail: facebookUserDetail)
                                }
                                else { //Couldn't able to fetch final result of login details
                                    self.delegate.didReceiveFacebookLoginError(message: ERROR_MESSAGE.fbGeneralError)
                                }
                            })
                        }
                        else { //Access token is empty
                            self.delegate.didReceiveFacebookLoginError(message: ERROR_MESSAGE.fbNoToken)
                        }
                    }
                    else { //Doesn't contain email after getting permission
                        self.delegate.didReceiveFacebookLoginError(message: ERROR_MESSAGE.fbNoEmail)
                    }
                }
                else { //Permission not granted for facebook login access
                    self.delegate.didReceiveFacebookLoginError(message: ERROR_MESSAGE.fbPermissionDenied)
                }
            }
            else { //Couldn't able to get read permission for email or public_profile
                self.delegate.didReceiveFacebookLoginError(message: ERROR_MESSAGE.fbDeniedEmailAccess)
            }
        }
    }
    
    
    
    
}

// MARK: - Facebook user detail entity

class FacebookUserDetail {
    
    // MARK: - Declarations
    var userName = ""
    var name = ""
    var email = ""
    var userId = ""
    
    init (dictionary: [String: AnyObject]) {
        
        userName = getValueFrom(dictionary: dictionary, key: "username") as! String
        name = getValueFrom(dictionary: dictionary, key: "name") as! String
        email = getValueFrom(dictionary: dictionary, key: "email") as! String
        userId = getValueFrom(dictionary: dictionary, key: "id") as! String
    }
    
}

// MARK: - Common error messages

public struct ERROR_MESSAGE {
    static let noInternet = "No internet connection available, please check your internet connection."
    static let enterEmailId = "Please enter the email."
    static let enterValidEmailId = "Please enter valid email id."
    static let enterValidPhone = "Please enter valid phone number."
    static let enterPassword = "Please enter your password."
    static let removeSpaceInPassword = "Please enter password without spaces."
    static let fbDeniedEmailAccess = "Sorry, you do not have email id in your facebook account. Please try with different account, that has email id."
    static let fbGeneralError = "Sorry, Couldn't able to fetch details from your facebook account. Please try again."
    static let fbNoToken = "Sorry, couldn't able to get access token from facebook. please try again."
    static let fbPermissionDenied = "Permission denied for facebook access"
    static let fbNoEmail = "Sorry, you do not have email id in your facebook account. Please try with different account, that has email id."
    
    static let editErrorMsg = "Please select any one review to edit"
}

public func getValueFrom( dictionary: [String: AnyObject], key:String) -> Any
{
    if let val = dictionary[key]
    {
        //        if val is String
        //        {
        
//        if  val is NSNumber {
//            return  (val as AnyObject).stringValue as AnyObject
//
//        } else {
//            return val as Any
//        }
        return "" as Any
        //        }
        //        return COMMON_STRING.empty as Any
    } else {
        return "" as Any
    }
}

