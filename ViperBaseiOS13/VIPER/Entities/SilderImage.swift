/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct SilderImage : Mappable {
    
	var id : Int?
	var type : String?
	var title : String?
	var description : String?
	var image : String?
	var created_at : String?
	var updated_at : String?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		id <- map["id"]
		type <- map["type"]
		title <- map["title"]
		description <- map["description"]
		image <- map["image"]
		created_at <- map["created_at"]
		updated_at <- map["updated_at"]
	}

}

struct ContactUsModelEntity : Mappable {
    var data : [ContactUsModel]?
    init?(map: Map) {

    }
    mutating func mapping(map: Map) {
        data <- map["data"]
    }
}

struct ContactUsModel : Mappable {
    var type : Int?
    var status: Int?
    var key : String?
    var id:Int?
    var key_name: String?
    var updated_at: Int?
    var created_at: String?
    var details: String?
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        type <- map["type"]
        status <- map["status"]
        key <- map["key"]
        id <- map["id"]
        key_name <- map["key_name"]
        updated_at <- map["updated_at"]
        created_at <- map["created_at"]
        details <- map["details"]
    }
}

