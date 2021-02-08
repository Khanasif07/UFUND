
//
//  FacebookController.swift
//  ArabianTyres
//
//  Created by Admin on 03/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Social
import Accounts


class FacebookController {
    
    // MARK:- VARIABLES
    //==================
    static let shared = FacebookController()
    var facebookAccount: ACAccount?
    
    private init() {}
    
    // MARK:- FACEBOOK LOGIN
    //=========================
    func loginWithFacebook(fromViewController viewController: UIViewController,isSilentLogin : Bool = false, completion: @escaping LoginManagerLoginResultBlock) {
        
        if let _ = AccessToken.current , !isSilentLogin {
            facebookLogout()
        }
        let permissions = [ "email", "public_profile" ]
        let login = LoginManager()
//        login.loginBehavior = LoginBehavior.browser
        login.logIn(permissions: permissions, from: viewController, handler: {
            result, error in
            
            if let res = result,res.isCancelled {
                completion(nil,error)
            }else{
                completion(result,error)
            }
            
        })
    }

    
    // MARK:- GET FACEBOOK USER INFO
    //================================
    func getFacebookUserInfo(fromViewController viewController: UIViewController,
                             isSilentLogin : Bool = false,
                             success: @escaping ((FacebookModel) -> Void),
                             failure: @escaping ((Error?) -> Void)) {
        
            self.loginWithFacebook(fromViewController: viewController,isSilentLogin: isSilentLogin, completion: { [weak self] (result, error) in
                
                if error == nil,let _ = result?.token {
                    self?.getInfo(success: { (result) in
                        success(result)
                    }, failure: { (e) in
                        failure(e)
                    })
                    
                }else{
                    failure(error)
                }
            })
    }
    
    private func getInfo(success: @escaping ((FacebookModel) -> Void),
                         failure: @escaping ((Error?) -> Void)){
        // FOR MORE PARAMETERS:- https://developers.facebook.com/docs/graph-api/reference/user
        let params = ["fields": "email, name, gender, first_name, last_name, is_verified, picture.type(large)"]
         let request = GraphRequest(graphPath: "me", parameters: params)
            request.start(completionHandler: {
                connection, result, error in
                
                if let result = result as? [String : Any] {
                    success(FacebookModel(withDictionary: result))
                } else {
                    failure(error)
                }
            })
        
    }

    // MARK:- FACEBOOK LOGOUT
    //=========================
    func facebookLogout(){
        LoginManager().logOut()
        let cooki  : HTTPCookieStorage! = HTTPCookieStorage.shared
        if let strorage = HTTPCookieStorage.shared.cookies{
            for cookie in strorage{
                cooki.deleteCookie(cookie)
            }
        }
    }
    
}

// MARK: FACEBOOK MODEL
//=======================
struct FacebookModel {
    var dictionary : [String:Any]!
    var id = ""
    var email = ""
    var name = ""
    var first_name = ""
    var last_name = ""
    var cover: URL?
    var picture: URL?
    
   
    
    init(withDictionary dict: [String:Any]) {
        self.dictionary = dict
        self.id = "\(dict["id"] ?? "")"
        self.name = "\(dict["name"] ?? "")"
        self.first_name = "\(dict["first_name"] ?? "")"
        self.email = "\(dict["email"] ?? "")"
    
        if let picture = dict["picture"] as? [String:Any],let data = picture["data"] as? [String:Any] {
            self.picture = URL(string: "\(data["url"] ?? "")")
        }
        if let cover = dict["cover"] as? [String:Any] {
            self.picture = URL(string: "\(cover["source"] ?? "")")
        }
        self.last_name = "\(dict["last_name"] ?? "")"
    }

}


