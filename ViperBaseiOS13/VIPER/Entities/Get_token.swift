/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct Get_token : Mappable {
	var id : Int?
	var user_id : Int?
	var tokenname : String?
	var tokensymbol : String?
	var tokenvalue : Double?
	var total_token_value : Double?
	var commission_amount : Double?
	var commission_per : Int?
	var tokensupply : Int?
	var avilable_token : Int?
	var contract_address : String?
	var token_image : String?
	var decimal : String?
	var token_type : Int?
	var security_type : Int?
	var trade_locked : Int?
	var trade_burn : Int?
	var status : Int?
	var request_deploy : Int?
	var created_at : String?
	var updated_at : String?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		id <- map["id"]
		user_id <- map["user_id"]
		tokenname <- map["tokenname"]
		tokensymbol <- map["tokensymbol"]
		tokenvalue <- (map["tokenvalue"],DoubleTransform())
		total_token_value <- (map["total_token_value"],DoubleTransform())
		commission_amount <- (map["commission_amount"],DoubleTransform())
		commission_per <- map["commission_per"]
		tokensupply <- map["tokensupply"]
		avilable_token <- map["avilable_token"]
		contract_address <- map["contract_address"]
		token_image <- map["token_image"]
		decimal <- map["decimal"]
		token_type <- map["token_type"]
		security_type <- map["security_type"]
		trade_locked <- map["trade_locked"]
		trade_burn <- map["trade_burn"]
		status <- map["status"]
		request_deploy <- map["request_deploy"]
		created_at <- map["created_at"]
		updated_at <- map["updated_at"]
	}

}
