//
//  CategoryModel.swift
//  ViperBaseiOS13
//
//  Created by Deepika on 03/02/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper

struct CategoryModel: Mappable {
    
    var id : Int?
    var category_name : String?
    var created_at : String?
    var updated_at : String?
    var name : String?

    init?(map: Map)
    {
           
     }
       
       mutating func mapping(map: Map)
       {
         
        id <- map["id"]
        category_name <- map["category_name"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        name <- map["name"]

       }

}

struct AdditionsModel : Mappable {
    

    var token_categories : [CategoryModel]?
    var  product_categories : [CategoryModel]?
    var token_type :[CategoryModel]?
    var asset_type : [CategoryModel]?
    var maturity_count : [String]?

    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        
        token_categories <- map["token_categories"]
        product_categories <- map["product_categories"]
        token_type <- map["token_type"]
        asset_type <- map["asset_type"]
        maturity_count <- map["maturity_count"]
        
    }
    

}

struct SuccessResponse : Mappable {
    
    var success : SuccessMsg?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        
        success <- map["success"]
        
    }
    
}
struct SuccessMsg : Mappable {
    
    var msg : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        
        msg <- map["msg"]
        
    }
    
}
