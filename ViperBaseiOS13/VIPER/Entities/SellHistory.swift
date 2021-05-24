/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct SellHistoryEntity : Mappable {
    var history : [History]?
    var walletHistory : [History]?
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        history <- map["history"]
        walletHistory <- map["wallet_history"]
    }
    
}


struct History : Mappable {
    var id : Int?
    var user_id : Int?
    var payment_type : String?
    var type : String?
    var status : String?
    var amount : Double?
    var exchange_usd_value : Int?
    var btc_amount : Double?
    var eth_amount : Double?
    var via : String?
    var tx_hash : String?
    var token_id : Int?
    var product_id : Int?
    var created_at : String?
    var updated_at : String?
    var user : UserHistory?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        user_id <- map["user_id"]
        payment_type <- map["payment_type"]
        type <- map["type"]
        status <- map["status"]
        amount <- map["amount"]
        exchange_usd_value <- map["exchange_usd_value"]
        btc_amount <- map["btc_amount"]
        eth_amount <- map["eth_amount"]
        via <- map["via"]
        tx_hash <- map["tx_hash"]
        token_id <- map["token_id"]
        product_id <- map["product_id"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        user <- map["user"]
    }

}


struct UserHistory : Mappable {
    var id : Int?
    var name : String?
    var last_name : String?
    var email : String?
    var picture : String?
    var address : String?
    var bch_address : String?
    var btc_address : String?
    var eth_address : String?
    var wallet_eth_address : String?
    var mobile : String?
    var user_type : String?
    var country_id : String?
    var city_id : String?
    var wallet : Double?
    var eth : Double?
    var btc : Double?
    var btc_wallet : Int?
    var eth_wallet : Int?
    var kyc : Int?
    var social_unique_id : String?
    var login_with : String?
    var verified : Int?
    var disable_2fa_unique_str : String?
    var g2f_temp : String?
    var google2fa_secret : String?
    var g2f_status : Int?
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

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        name <- map["name"]
        last_name <- map["last_name"]
        email <- map["email"]
        picture <- map["picture"]
        address <- map["address"]
        bch_address <- map["bch_address"]
        btc_address <- map["btc_address"]
        eth_address <- map["eth_address"]
        wallet_eth_address <- map["wallet_eth_address"]
        mobile <- map["mobile"]
        user_type <- map["user_type"]
        country_id <- map["country_id"]
        city_id <- map["city_id"]
        wallet <- map["wallet"]
        eth <- map["eth"]
        btc <- map["btc"]
        btc_wallet <- map["btc_wallet"]
        eth_wallet <- map["eth_wallet"]
        kyc <- map["kyc"]
        social_unique_id <- map["social_unique_id"]
        login_with <- map["login_with"]
        verified <- map["verified"]
        disable_2fa_unique_str <- map["disable_2fa_unique_str"]
        g2f_temp <- map["g2f_temp"]
        google2fa_secret <- map["google2fa_secret"]
        g2f_status <- map["g2f_status"]
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
    }

}


struct BuyInvestHistory : Mappable {
    var buyhistory : [Buyhistory]?
    var invest_history : [Invest_history]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        buyhistory <- map["buyhistory"]
        invest_history <- map["invest_history"]
    }

}


struct Invest_history : Mappable {
    var id : Int?
    var user_id : Int?
    var payment_type : String?
    var type : String?
    var status : String?
    var amount : Double?
    var exchange_usd_value : Int?
    var btc_amount : Double?
    var eth_amount : Double?
    var via : String?
    var tx_hash : String?
    var token_id : Int?
    var product_id : Int?
    var created_at : String?
    var updated_at : String?
    var user : UserHistory?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        user_id <- map["user_id"]
        payment_type <- map["payment_type"]
        type <- map["type"]
        status <- map["status"]
        amount <- map["amount"]
        exchange_usd_value <- map["exchange_usd_value"]
        btc_amount <- map["btc_amount"]
        eth_amount <- map["eth_amount"]
        via <- map["via"]
        tx_hash <- map["tx_hash"]
        token_id <- map["token_id"]
        product_id <- map["product_id"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        user <- map["user"]
    }

}

struct Buyhistory : Mappable {
    var id : Int?
    var user_id : Int?
    var payment_type : String?
    var type : String?
    var status : String?
    var amount : Double?
    var exchange_usd_value : Int?
    var btc_amount : Double?
    var eth_amount : Double?
    var via : String?
    var tx_hash : String?
    var token_id : Int?
    var product_id : Int?
    var created_at : String?
    var updated_at : String?
    var user : User?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        user_id <- map["user_id"]
        payment_type <- map["payment_type"]
        type <- map["type"]
        status <- map["status"]
        amount <- map["amount"]
        exchange_usd_value <- map["exchange_usd_value"]
        btc_amount <- map["btc_amount"]
        eth_amount <- map["eth_amount"]
        via <- map["via"]
        tx_hash <- map["tx_hash"]
        token_id <- map["token_id"]
        product_id <- map["product_id"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        user <- map["user"]
    }

}
