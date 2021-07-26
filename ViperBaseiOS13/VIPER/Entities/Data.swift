/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct DataAssets : Mappable {
	var symbol : String?
	var image : String?
	var coin_name : String?
	var address : String?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		symbol <- map["symbol"]
		image <- map["image"]
		coin_name <- map["coin_name"]
		address <- map["address"]
	}

}

struct WalletBalance : Mappable {
    
    var eth: Double?
    var total_amount : Double?
    var btc : Double?
    var wallet: Double?
    
//    var data : [DataAssets]?

    init?(map: Map) {

    }
    
    init(){
        
    }

    mutating func mapping(map: Map) {

        total_amount <- map["total_amount"]
        wallet <- map["wallet"]
        eth <- map["eth"]
        btc <- map["btc"]
    }

}

struct WalletEntity : Mappable{
    
    var balance: WalletBalance?
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        balance <- map["balance"]
    }
}

struct DepositUrlModel : Mappable{
    
    var code: Int?
    var message: String?
    var url: String?
    init?(map: Map) {
        
    }
    
    init(){}
    
    mutating func mapping(map: Map) {
        code <- map["code"]
        message <- map["message"]
        url <- map["url"]
    }
}

struct WalletModuleEntity : Mappable {
    var data : WalletModule?
    init?(map: Map) {
    }
    mutating func mapping(map: Map) {
        data <- map["data"]
    }
}



struct WalletModule : Mappable {
    
    var buy_histories  : [History]?
    var invest_histories : [History]?
    var wallet_histories : [History]?
    var transaction_histories: [History]?
    var sell_histories: [History]?
    var overall_invest: Double?
    var total_products : Int?
    var total_tokens : Int?
    var wallet: Double?
    
    init?(map: Map) {
    }
    
    init(){
        
    }

    mutating func mapping(map: Map) {

        total_products <- map["total_products"]
        total_tokens <- map["total_tokens"]
        overall_invest <- map["overall_invest"]
        sell_histories <- map["sell_histories"]
        invest_histories <- map["invest_histories"]
        buy_histories <- map["buy_histories"]
        wallet_histories <- map["transaction_histories"]
        transaction_histories <- map["transaction_histories"]
    }

}


struct YieldModuleEntity : Mappable {
    var data : [YieldModule]?
    var message: String?
    var code: Int?
    init?(map: Map) {
    }
    mutating func mapping(map: Map) {
        data <- map["data"]
        message <- map["message"]
        code <- map["code"]
    }
}



struct YieldModule : Mappable {
    var btc: String?
    var eth: String?
    var usd: String?
    var categories  : [Category]?
    var currencies:Yield?

    init?(map: Map) {
    }

    init(){

    }

    mutating func mapping(map: Map) {
        categories <- map["categories"]
        btc <- map["btc"]
        eth <- map["eth"]
        usd <- map["usd"]
        currencies <- map["currencies"]
    }

}


struct Yield : Mappable {
    var btc: String?
    var eth: String?
    var usd: String?

    init?(map: Map) {
    }

    init(){
    }

    mutating func mapping(map: Map) {
        btc <- map["btc"]
        eth <- map["eth"]
        usd <- map["usd"]
    }

}


struct YieldsHistoryEntity : Mappable {
    var data : YieldsHistory?
    var message: String?
    var recordsTotal: Int?
    init?(map: Map) {

    }
    mutating func mapping(map: Map) {
        data <- map["data"]
        recordsTotal <- map["recordsTotal"]
        message <- map["message"]
    }
}

struct YieldsHistory : Mappable {
    var yeildBuyInvestorArray:  YeildBuyInvestorArray?
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        yeildBuyInvestorArray <- map["YeildBuyInvestorArray"]
    }
}

struct YeildBuyInvestorArray: Mappable {
    var current_page : Int?
    var from: Int?
    var path : String?
    var total:Int?
    var next_page_url: String?
    var prev_page_url: String?
    var last_page: Int?
    var per_page: Int?
    var last_page_url: String?
    var first_page_url: String?
    var data: [History]?
    
    init?(map: Map) {

      }
    
    mutating func mapping(map: Map) {
           current_page <- map["current_page"]
           from <- map["from"]
           path <- map["path"]
           total <- map["total"]
           next_page_url <- map["next_page_url"]
           prev_page_url <- map["prev_page_url"]
           last_page <- map["last_page"]
           per_page <- map["per_page"]
           last_page_url <- map["ast_page_url"]
           first_page_url <- map["first_page_url"]
           data <- map["data"]
       }
}
