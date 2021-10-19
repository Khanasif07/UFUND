//
//  AppConstants.swift
//  ViperBaseiOS13
//
//  Created by Admin on 08/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import Foundation
import Foundation

enum AppConstants {
    
    static let kAppName = "UFUND"
    static let kGoogleClientID = ""
    static let kGoogleUrlScheme = ""
    static let kGoogleApiKey = ""
    static let kFacebookAppID = "508134256488944"
    static let fb_login_protocol_scheme = "fb508134256488944"
    static let kMe = "Me"
    
    static let googleId = "550857412683-2p2fttifu2k4unt6rphtrm15rquktve8.apps.googleusercontent.com"
    static let fbUrl = "fb1368229543515063"
    static let googleUrl = "com.googleusercontent.apps.175392921069-agcdbrcffqcbhl1cbeatvjafd35335gm"
//    static let linkedIn_Client_Id = "78bm410fe1zr9i"
//    static let linkedIn_ClientSecret = "cB6mIrb4NmN0qhvE"
    static let linkedIn_States = "linkedin\(Int(NSDate().timeIntervalSince1970))"
    static let linkedIn_Permissions = ["r_liteprofile", "r_emailaddress"]
//    static let linkedIn_redirectUri = "http://ufund.linkedin.com/redirect"
    
    static let TWITTER_APP_ID = "20061008"
//    static let TWITTER_API_KEY = "i9VUBLUWBBLg4tg2XBbXoTh5a"
//    static let TWITTER_API_SECRET = "ljpBRbkrAZvt9B8akWDzIKVewLlXAOw8ZqVzICM2kiHu4ZbIfx"
    static let TWITTER_BEARER_TOKEN = "AAAAAAAAAAAAAAAAAAAAAFAbMgEAAAAAhXyX8TO%2Fo9CsguJKmkGUte7DS2w%3D8cZOeaPtFFeaviDNoL257kWr7mWqhAhllZgmPBZQfE94OLLhNW"
    
    //MARK:- Twitter
    static let TWITTER_API_KEY = "IYruAGYhsN3xM5Ef4NvOImso9"
    static let TWITTER_API_SECRET = "Fc54prvuIBpgnIcyoZ3shMTdlyc7zBk4Q2nldV48PqPgkTdL4O"
    static let CALLBACK_URL = "https://ufundqaonline.appskeeper.in/social-signup/twitter"
    //
    
    //MARK:- Linkedin
    static let linkedIn_Client_Id = "77ue796477p0qt"
    static let linkedIn_ClientSecret = "FnHDWxiFMAcp6IhG"
    static let linkedIn_redirectUri = "https://ufundqaonline.appskeeper.in/social-signup/linkedin"
    static let linkedIn_AUTHURL = "https://www.linkedin.com/oauth/v2/authorization"
    static let linkedIn_TOKENURL = "https://www.linkedin.com/oauth/v2/accessToken"


    static var defaultDate          = "0000-00-00"
    static var emptyString          = ""
    static var awss3PoolId          = "us-east-1:30b832a4-eacb-44ca-84e7-2abad1501218"
        //"us-east-1:b1f250f2-66a7-4d07-96e9-01817149a439"
    static var AWS_BUCKET         = "ufund-env"
        //"appinventiv-development"
    static var AWS_DEFAULT_REGION          = "us-east-1"
    static var AWS_SECRET_ACCESS_KEY          = "Vs2iIUpFZkSdkXSxLc4g+CWS/iunhq4Ex/gnf15e"
    static var AWS_URL = "https://ufund-env.s3.amazonaws.com/env.production"
        //"https://appinventiv-development.s3.amazonaws.com/"
    static var AWS_ACCESS_KEY_ID = "AKIA6DQMUBGGZSBCXSFA"
     // Identity pool ID
//        Regions.US_EAST_1 // Region
//    ufund-env // bucket



}


func delay(seconds: Double, completion: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
        completion()
    }
}
//us-east-1:b1f250f2-66a7-4d07-96e9-01817149a439
