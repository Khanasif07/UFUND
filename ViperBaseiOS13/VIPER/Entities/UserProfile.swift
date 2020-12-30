/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct UserProfile : Mappable {
    
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
    var g2f_status : Int?
    var picture : String?
    

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
        g2f_status <- map["g2f_status"]
        picture <- map["picture"]
	}

}

struct UserDetails : Mappable {
    var user : UserProfile?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        user <- map["user"]
    }

}

struct SuccessDict : Mappable {
    var success : Success?
    var url : String?
       var amount: Double?
       var merchant: String?
       var item_name:String?
       var currency : String?
    init?(map: Map) {

    }

    
    
    mutating func mapping(map: Map) {
        currency <- map["currency"]
             item_name <- map["item_name"]
             merchant <- map["merchant"]
             amount <- map["amount"]
         print("**amount",amount)
        if amount == nil {
            
            var str : String?
            str <- map["amount"]
            amount = Double(str ?? "")
        }
        
        print("**amount2",amount)
        success <- map["success"]
          url <- map["url"]
    }

}
struct Success : Mappable {
    var msg : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        msg <- map["msg"]
    }

}


struct Secret : Mappable {
    var secret : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        secret <- map["secret"]
    }
    
}
struct PayHistory : Mappable {
    var id : Int?
    var user_id : Int?
    var request_type : String?
    var request_id : Int?
    var request : String?
    var type : String?
    var transaction_id : String?
    var amount : Double?
    var status : String?
    var created_at : String?
    var updated_at : String?
    var payment_details : Payment_details?
    var user : UserIdEntity?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        user_id <- map["user_id"]
        request_type <- map["request_type"]
        request_id <- map["request_id"]
        request <- map["request"]
        type <- map["type"]
        transaction_id <- map["transaction_id"]
        amount <- map["amount"]
        status <- map["status"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        payment_details <- map["payment_details"]
        user <- map["user"]
    }

}
struct Coinpayment : Mappable {
    var id : Int?
    var txn_id : String?
    var address : String?
    var amount : String?
    var amountf : String?
    var coin : String?
    var confirms_needed : Int?
    var payment_address : String?
    var qrcode_url : String?
    var received : String?
    var receivedf : String?
    var recv_confirms : String?
    var status : String?
    var status_text : String?
    var status_url : String?
    var timeout : String?
    var type : String?
    var payload : String?
    var deleted_at : String?
    var created_at : String?
    var updated_at : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        txn_id <- map["txn_id"]
        address <- map["address"]
        amount <- map["amount"]
        amountf <- map["amountf"]
        coin <- map["coin"]
        confirms_needed <- map["confirms_needed"]
        payment_address <- map["payment_address"]
        qrcode_url <- map["qrcode_url"]
        received <- map["received"]
        receivedf <- map["receivedf"]
        recv_confirms <- map["recv_confirms"]
        status <- map["status"]
        status_text <- map["status_text"]
        status_url <- map["status_url"]
        timeout <- map["timeout"]
        type <- map["type"]
        payload <- map["payload"]
        deleted_at <- map["deleted_at"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
    }

}

struct UserIdEntity : Mappable {
    var id : Int?
    var name : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        name <- map["name"]
    }

}
struct Payment_details : Mappable {
    var id : Int?
    var txn_id : String?
    var address : String?
    var amount : String?
    var amountf : String?
    var coin : String?
    var confirms_needed : Int?
    var payment_address : String?
    var qrcode_url : String?
    var received : String?
    var receivedf : String?
    var recv_confirms : String?
    var status : String?
    var status_text : String?
    var status_url : String?
    var timeout : String?
    var type : String?
    var payload : String?
    var deleted_at : String?
    var created_at : String?
    var updated_at : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        txn_id <- map["txn_id"]
        address <- map["address"]
        amount <- map["amount"]
        amountf <- map["amountf"]
        coin <- map["coin"]
        confirms_needed <- map["confirms_needed"]
        payment_address <- map["payment_address"]
        qrcode_url <- map["qrcode_url"]
        received <- map["received"]
        receivedf <- map["receivedf"]
        recv_confirms <- map["recv_confirms"]
        status <- map["status"]
        status_text <- map["status_text"]
        status_url <- map["status_url"]
        timeout <- map["timeout"]
        type <- map["type"]
        payload <- map["payload"]
        deleted_at <- map["deleted_at"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
    }

}
