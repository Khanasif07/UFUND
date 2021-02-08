//
//  GoogleLoginController.swift
//  ArabianTyres
//
//  Created by Admin on 03/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import GoogleSignIn

class GoogleLoginController : NSObject {
    
    // MARK: Variables and properties...
    static let shared = GoogleLoginController()
    fileprivate(set) var currentGoogleUser: GoogleUser?
    fileprivate weak var contentViewController:UIViewController!
    
    var success : ((_ googleUser : GoogleUser) -> ())?
    var failure : ((_ error : Error) -> ())?
    
    private override init() {}
    
    func configure(withClientId clientId:String){
        GIDSignIn.sharedInstance().clientID = clientId
        GIDSignIn.sharedInstance().delegate = self
    }
    
    func handleUrl(_ url: URL, options: [UIApplication.OpenURLOptionsKey : Any])->Bool{
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    // MARK: - Method for google login...
    // MARK: ============================
    func login(fromViewController viewController : UIViewController = (UIApplication.shared.delegate as! AppDelegate).window!.rootViewController!,
               success : @escaping(_ googleUser : GoogleUser) -> (),
               failure : @escaping(_ error : Error) -> ()) {
        GIDSignIn.sharedInstance()?.presentingViewController = viewController
        contentViewController = viewController
        self.success = success
        self.failure = failure
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    func logout(){
        GIDSignIn.sharedInstance().signOut()
    }
}

// MARK: - GIDSignInUIDelegate and GIDSignInDelegate delegare methods...
// MARK: ===============================================================
extension GoogleLoginController : GIDSignInDelegate {
    
    // MARK: To get user details like name, email etc.
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            let googleUser = GoogleUser(user)
            currentGoogleUser = googleUser
            success?(googleUser)
        } else {
            failure?(error)
        }
        success = nil
        failure = nil
    }
    
    // MARK: - To present to your controller
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        contentViewController.present(viewController, animated: true, completion: nil)
    }
    
    // MARK: - To dismiss from your controller
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        contentViewController.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Model class to store the user information...
// MARK: ==============================================
class GoogleUser {
    
    let id: String
    let name: String
    let email: String
    let image: URL?
    
    required init(_ googleUser: GIDGoogleUser) {
        
        id = googleUser.userID
        name = googleUser.profile.name
        email = googleUser.profile.email
        image = googleUser.profile.imageURL(withDimension: 200)
    }
    
    var dictionaryObject: [String:Any] {
        var dictionary          = [String:Any]()
        dictionary["_id"]       = id
        dictionary["email"]     = email
        dictionary["image"]     = image?.absoluteString ?? ""
        dictionary["name"]      = name
        return dictionary
    }
    
}



