//
//  User.swift
//  User
//
//  Created by CSS on 17/01/18.
//  Copyright © 2018 Appoets. All rights reserved.
//


import Foundation

class User : NSObject, NSCoding, JSONSerializable {
    
    static var main = User()
    
    //@objc dynamic var id = 0
    
  
    var kyc: Int?
    var transactionID : String = ""
    var is_document_submitted: Bool?
    var trulioo_kyc_status : Int?
    var token : String?
    var balance : String?
    var buy_price : Double?
    var sell_price : Double?
    var usd_bstk : Double?
    var id : Int?
    var name : String?
    var accessToken : String?
    var latitude : Double?
    var lontitude : Double?
    var firstName : String?
    var lastName :String?
    var picture : String?
    var email : String?
    var mobile : String?
    var email_token: String?
    var g2f_temp : Int?
    var pin_status : Int?
    var eth_address : String?
    var btc_address : String?
    var min_eth : Double?
    //
    var social_email_verify :Bool?
    var signup_by :String?
   
    
    init(id : Int?, name : String?, accessToken: String?, latitude: Double?, lontitude: Double?, firstName: String?, lastName : String?, email : String?, phoneNumber: String?,picture: String?,token : String?, balance : String?, buy_price : Double?, sell_price : Double?, kyc: Int?,trulioo_kyc_status: Int?, usd_bstk : Double?, email_token: String?,  g2f_temp : Int?, pin_status : Int?,eth_address : String?,btc_address : String?,is_document_submitted: Bool?,social_email_verify:Bool?,signup_by:String?){
        
        self.id = id
        self.name = name
        self.accessToken = accessToken
        self.latitude = latitude
        self.lontitude = lontitude
        self.firstName = firstName
        self.lastName = lastName
        self.mobile = phoneNumber
        self.email = email
        self.picture = picture
        self.token =  token
        self.balance = balance
        self.buy_price = buy_price
        self.sell_price = sell_price
        self.kyc = kyc
        self.trulioo_kyc_status = trulioo_kyc_status
        self.usd_bstk = usd_bstk
        self.email_token = email_token
        self.g2f_temp = g2f_temp
        self.pin_status = pin_status
        
        self.eth_address = eth_address
        self.btc_address = btc_address
        self.is_document_submitted = is_document_submitted
        self.social_email_verify = social_email_verify
        self.signup_by = signup_by
    }
    
    convenience
    override init() {
        
        self.init(id: nil, name: nil, accessToken: nil, latitude: nil, lontitude: nil, firstName: nil, lastName: nil, email: nil, phoneNumber:  nil, picture: nil, token: nil, balance: nil, buy_price: nil, sell_price: nil, kyc: nil,trulioo_kyc_status : nil, usd_bstk: nil, email_token: nil, g2f_temp: nil,pin_status: nil,eth_address: nil,btc_address : nil, is_document_submitted: nil,social_email_verify: nil,signup_by:nil)
        
    }
    
    
    required convenience init?(coder aDecoder: NSCoder) {
        let min_eth = aDecoder.decodeObject(forKey: Keys.list.min_eth) as? Double
        let transactionID = aDecoder.decodeObject(forKey: Keys.list.transactionID) as? String
        let trulioo_kyc_status = aDecoder.decodeObject(forKey: Keys.list.trulioo_kyc_status) as? Int
        let kyc = aDecoder.decodeObject(forKey: Keys.list.kyc) as? Int
        let id = aDecoder.decodeObject(forKey: Keys.list.id) as? Int
        let name = aDecoder.decodeObject(forKey: Keys.list.name) as? String
        let accessToken = aDecoder.decodeObject(forKey: Keys.list.accessToken) as? String
        let latitude = aDecoder.decodeObject(forKey: Keys.list.latitude) as? Double
        let lontitude = aDecoder.decodeObject(forKey: Keys.list.lontitude) as? Double
        let firstNmae = aDecoder.decodeObject(forKey: Keys.list.firstName) as? String
        let lastName = aDecoder.decodeObject(forKey: Keys.list.lastName) as? String
        let email = aDecoder.decodeObject(forKey: Keys.list.email) as? String
        let phoneNumber = aDecoder.decodeObject(forKey: Keys.list.mobile) as? String
        let picture = aDecoder.decodeObject(forKey: Keys.list.picture) as? String
        let token = aDecoder.decodeObject(forKey: Keys.list.token) as? String
        let balance = aDecoder.decodeObject(forKey: Keys.list.balance) as? String
        let buy_price = aDecoder.decodeObject(forKey: Keys.list.buy_price) as? Double
        let sell_price = aDecoder.decodeObject(forKey: Keys.list.sell_price) as? Double
        let usd_bstk = aDecoder.decodeObject(forKey: Keys.list.usd_bstk) as? Double
        let email_token = aDecoder.decodeObject(forKey: Keys.list.email_token) as? String
        
        
        let pin_status = aDecoder.decodeObject(forKey: Keys.list.pin_status) as? Int
        let g2f_temp = aDecoder.decodeObject(forKey: Keys.list.g2f_temp) as? Int
        
        let eth_address = aDecoder.decodeObject(forKey: Keys.list.eth_address) as? String
        let btc_address = aDecoder.decodeObject(forKey: Keys.list.btc_address) as? String
        let is_document_submitted = aDecoder.decodeObject(forKey: Keys.list.is_document_submitted) as? Bool
        //
        let signup_by = aDecoder.decodeObject(forKey: Keys.list.signup_by) as? String
        let social_email_verify = aDecoder.decodeObject(forKey: Keys.list.social_email_verify) as? Bool
        
        self.init(id: id, name: name, accessToken: accessToken, latitude: latitude, lontitude: lontitude, firstName: firstNmae, lastName: lastName, email: email, phoneNumber: phoneNumber, picture: picture,token: token, balance: balance,buy_price: buy_price, sell_price: sell_price, kyc: kyc,trulioo_kyc_status: trulioo_kyc_status, usd_bstk: usd_bstk, email_token: email_token, g2f_temp: g2f_temp, pin_status: pin_status,eth_address: eth_address,btc_address : btc_address, is_document_submitted: is_document_submitted,social_email_verify:social_email_verify, signup_by:signup_by)
    }
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.is_document_submitted,forKey: Keys.list.is_document_submitted)
        aCoder.encode(self.transactionID,forKey: Keys.list.transactionID)
        aCoder.encode(self.min_eth,forKey: Keys.list.min_eth)
        aCoder.encode(self.trulioo_kyc_status,forKey: Keys.list.trulioo_kyc_status)
        aCoder.encode(self.kyc, forKey: Keys.list.kyc)
        aCoder.encode(self.id, forKey: Keys.list.id)
        aCoder.encode(self.name, forKey: Keys.list.name)
        aCoder.encode(self.accessToken, forKey: Keys.list.accessToken)
        aCoder.encode(self.lontitude, forKey: Keys.list.lontitude)
        aCoder.encode(self.latitude, forKey: Keys.list.latitude)
        aCoder.encode(self.firstName, forKey: Keys.list.firstName)
        aCoder.encode(self.lastName, forKey: Keys.list.lastName)
        aCoder.encode(self.email, forKey: Keys.list.email)
        aCoder.encodeConditionalObject(self.mobile, forKey: Keys.list.mobile)
        aCoder.encode(self.picture, forKey: Keys.list.picture)
        aCoder.encode(self.usd_bstk, forKey: Keys.list.usd_bstk)
        aCoder.encode(self.token, forKey: Keys.list.token)
        aCoder.encode(self.balance, forKey: Keys.list.balance)
        aCoder.encode(self.buy_price, forKey: Keys.list.buy_price)
        aCoder.encode(self.sell_price, forKey: Keys.list.sell_price)
        aCoder.encode(self.email_token, forKey: Keys.list.email_token)
        aCoder.encode(self.g2f_temp, forKey: Keys.list.g2f_temp)
        aCoder.encode(self.pin_status, forKey: Keys.list.pin_status)
        aCoder.encode(self.eth_address, forKey: Keys.list.eth_address)
        aCoder.encode(self.btc_address, forKey: Keys.list.btc_address)
        //
        aCoder.encode(self.eth_address, forKey: Keys.list.social_email_verify)
        aCoder.encode(self.btc_address, forKey: Keys.list.signup_by)
    }
    
}









