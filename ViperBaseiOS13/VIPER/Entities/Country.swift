//
//  Country.swift
//  User
//
//  Created by CSS on 20/02/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation


import ObjectMapper

struct Country: Decodable {
    
    var name : String
    var dial_code : String
    var code : String
    
}

//MARK:- Login Screen

struct LoginParameters {
    
    var username: String?
    var password: String?
    var client_id: Int?
    var client_secret: String?
    var device_type: String?
    var device_token: String?
    var device_id: String?
    var grant_type: String?
    
    func toLoginParameters() -> [String : Any] {
        let parameters = [PARAM_USERNAME: self.username ?? "",
                          PARAM_PASSWRD : self.password!,
                          PARAM_CLIENTID:appClientId,
                          PARAM_CLIENTSECRET: appSecretKey,
                          PARAM_DEVICETYPE : "ios",
                          PARAM_DEVICETOKEN : deviceTokenString,
                          PARAM_DEVICEID: UUID().uuidString,
                          PARAM_GRANTTYPE : self.grant_type ?? ""] as [String : Any]
        
        return parameters as [String : Any]
    }
}


let PARAM_FIRSTNAME = "first_name"
let PARAM_LASTNAME = "last_name"
let PARAM_EMAIL = "email"
let PARAM_PASSWRD = "password"
let PARAM_CONFIRMPASSWRD = "password_confirmation"
let PARAM_COUNTRYCODE = "country_code"
let PARAM_MOBILE = "mobile"
let PARAM_GENDER = "gender"
let PARAM_DOB = "dob"
let PARAM_CLIENTID = "client_id"
let PARAM_CLIENTSECRET = "client_secret"
let PARAM_DEVICETYPE = "device_type"
let PARAM_DEVICETOKEN = "device_token"
let PARAM_DEVICEID = "device_id"
let PARAM_LOGINBY = "login_by"
let PARAM_PICTURE = "picture"
let PARAM_USERNAME = "username"
let PARAM_GRANTTYPE = "grant_type"


struct DeleteModel : Mappable {
    var token_type : String?
    var access_token : String?
    var refresh_token : String?
    //   var data : Data?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        token_type <- map["token_type"]
        access_token <- map["access_token"]
        refresh_token <- map["refresh_token"]
        //   data <- map["data"]
    }
    
}



struct SignInModel : Mappable {
    var id : Int?
    var name : String?
    var last_name : String?
    var email : String?
    var address : String?
    var mobile : String?
    var user_type : String?
    var country_id : String?
    var city_id : String?
    var wallet : String?
    var kyc : Int?
    var social_unique_id : String?
    var login_with : String?
    var verified : Int?
    var g2f_temp : String?
    var google2fa_secret : String?
    var push_note_status : Int?
    var referred_by : String?
    var email_token : String?
    var app_pin : String?
    var app_pin_status : Int?
    var send_email_status : String?
    var receive_email_status : String?
    var ip : String?
    var session_id : String?
    var device_type : String?
    var device_id : String?
    var device_token : String?
    var updated_at : String?
    var access_token : String?
    var g2f_status: Int?
    var picture: String?
    var token_type: String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        picture <- map["picture"]
        id <- map["id"]
        name <- map["name"]
        last_name <- map["last_name"]
        email <- map["email"]
        address <- map["address"]
        mobile <- map["mobile"]
        user_type <- map["user_type"]
        country_id <- map["country_id"]
        city_id <- map["city_id"]
        wallet <- map["wallet"]
        kyc <- map["kyc"]
        social_unique_id <- map["social_unique_id"]
        login_with <- map["login_with"]
        verified <- map["verified"]
        g2f_temp <- map["g2f_temp"]
        google2fa_secret <- map["google2fa_secret"]
        push_note_status <- map["push_note_status"]
        referred_by <- map["referred_by"]
        email_token <- map["email_token"]
        app_pin <- map["app_pin"]
        app_pin_status <- map["app_pin_status"]
        send_email_status <- map["send_email_status"]
        receive_email_status <- map["receive_email_status"]
        ip <- map["ip"]
        session_id <- map["session_id"]
        device_type <- map["device_type"]
        device_id <- map["device_id"]
        device_token <- map["device_token"]
        updated_at <- map["updated_at"]
        access_token <- map["access_token"]
        g2f_status <- map["g2f_status"]
        token_type <- map["token_type"]
    }

}



struct SignUpModel : Mappable {
    var id : Int?
    var name : String?
    var last_name : String?
    var email : String?
    var address : String?
    var mobile : String?
    var user_type : String?
    var country_id : String?
    var city_id : String?
    var wallet : String?
    var kyc : Int?
    var social_unique_id : String?
    var login_with : String?
    var verified : Int?
    var g2f_temp : String?
    var google2fa_secret : String?
    var push_note_status : Int?
    var referred_by : String?
    var email_token : String?
    var app_pin : String?
    var app_pin_status : String?
    var send_email_status : String?
    var receive_email_status : String?
    var ip : String?
    var session_id : String?
    var device_type : String?
    var device_id : String?
    var device_token : String?
    var updated_at : String?
    var access_token : String?
    var status: String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        name <- map["name"]
        last_name <- map["last_name"]
        email <- map["email"]
        address <- map["address"]
        mobile <- map["mobile"]
        user_type <- map["user_type"]
        country_id <- map["country_id"]
        city_id <- map["city_id"]
        wallet <- map["wallet"]
        kyc <- map["kyc"]
        social_unique_id <- map["social_unique_id"]
        login_with <- map["login_with"]
        verified <- map["verified"]
        g2f_temp <- map["g2f_temp"]
        google2fa_secret <- map["google2fa_secret"]
        push_note_status <- map["push_note_status"]
        referred_by <- map["referred_by"]
        email_token <- map["email_token"]
        app_pin <- map["app_pin"]
        app_pin_status <- map["app_pin_status"]
        send_email_status <- map["send_email_status"]
        receive_email_status <- map["receive_email_status"]
        ip <- map["ip"]
        session_id <- map["session_id"]
        device_type <- map["device_type"]
        device_id <- map["device_id"]
        device_token <- map["device_token"]
        updated_at <- map["updated_at"]
        access_token <- map["access_token"]
        status <- map["status"]
    }

}


struct SocialLoginEntity : Mappable {
    var access_token : String?
    var message: String?
    var status : String?
    var user_info : SignInModel?
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        message <- map["message"]
        status <- map["status"]
        access_token <- map["access_token"]
        user_info <- map["user_info"]
    }
}

struct InvestorDashboardEntity : Mappable {
    var data : DashboardEntity?
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        data <- map["data"]
    }
}

struct DashboardEntity : Mappable{
    init?(map: Map) {
        
    }
    
    init(){
        
    }
    
    var investments : Int?
    var my_investements : Int?
    var tokenized_assets : Int?
    var total_categories : Int?
    var total_earning : Int?
    var total_products : Int?
    var total_tokenizes_assets : Int?
    var total_wallets: Int?
    
    mutating func mapping(map: Map) {

        investments <- map["investments"]
        my_investements <- map["my_investements"]
        tokenized_assets <- map["tokenized_assets"]
        total_categories <- map["total_categories"]
        total_earning <- map["total_earning"]
        total_products <- map["total_products"]
        total_tokenizes_assets <- map["total_tokenizes_assets"]
        total_tokenizes_assets <- map["total_tokenizes_assets"]
        total_wallets <- map["total_wallets"]
    }
}
