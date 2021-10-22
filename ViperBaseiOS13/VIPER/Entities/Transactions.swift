/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct Transactions : Mappable {
	var id : Int?
	var sender : Int?
	var receiver : Int?
	var user_token_id : Int?
	var address : String?
	var txHash : String?
	var amount : Double?
	var status : Int?
	var created_at : String?
	var updated_at : String?
	var get_token : Get_token?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		id <- map["id"]
		sender <- map["sender"]
		receiver <- map["receiver"]
		user_token_id <- map["user_token_id"]
		address <- map["address"]
		txHash <- map["txHash"]
		amount <- (map["amount"],DoubleTransform())
		status <- map["status"]
		created_at <- map["created_at"]
		updated_at <- map["updated_at"]
		get_token <- map["get_token"]
	}

}
