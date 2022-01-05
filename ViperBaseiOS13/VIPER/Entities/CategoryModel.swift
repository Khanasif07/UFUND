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
    var type: String?
    var image : String?
    var isSelected: Bool = false

    init?(map: Map)
    {
           
     }
    
    init(){
        
    }
       
       mutating func mapping(map: Map)
       {
         
        id <- map["id"]
        image <- map["image"]
        category_name <- map["category_name"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        name <- map["name"]

       }

}

struct AdditionsModel : Mappable {
    

    var token_categories : [CategoryModel]?
    var product_categories : [CategoryModel]?
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


struct CategoriesModel : Mappable {

    var data : [CategoryModel]?

    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        data <- map["data"]
    }
    

}


struct AdminCommissionModel : Mappable {

    var data : CommissionModel?
    var code: Int?
    var  message: String?

    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        data <- map["data"]
        code <- map["code"]
        message <- map["message"]
    }
    

}

struct CommissionModel: Mappable {
    
    var btcdeposit_commission : String?
    var ethdeposit_commission : String?
    var min_eth : String?
    var product_buy_comission : String?
    var token_buy_comission: String?
    
    init?(map: Map)
    {
           
     }
    
    init(){
        
    }
       
       mutating func mapping(map: Map){
        btcdeposit_commission <- map["btcdeposit_commission"]
        ethdeposit_commission <- map["ethdeposit_commission"]
        min_eth <- map["min_eth"]
        product_buy_comission <- map["product_buy_comission"]
        token_buy_comission <- map["token_buy_comission"]
       }

}
