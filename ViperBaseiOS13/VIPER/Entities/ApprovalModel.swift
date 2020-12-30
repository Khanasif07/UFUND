//
//  ApprovalModel.swift
//  ViperBaseiOS13
//
//  Created by Deepika on 06/02/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper

struct ApprovalModel: Mappable {

    var total_request_token : Int?
    var total_approve_token : Int?
    var total_product_request : Int?
    var total_approve_product : Int?
    
    
        init?(map: Map)
        {
              
        }
      
      mutating func mapping(map: Map) {
        
        total_approve_token <- map["total_approve_token"]
        total_request_token <- map["total_request_token"]
        total_product_request <- map["total_product_request"]
        total_approve_product <- map["total_approve_product"]
          
      }

}



struct InvestementEntity : Mappable {
    var id : Int?
    var user_id : Int?
    var product_title : String?
    var product_image : String?
    var products : Int?
    var token_image : String?
    var category_id : Int?
    var product_description : String?
    var product_amount : Double?
    var product_value : Double?
    var brand : String?
    var ean_upc_code : String?
    var hs_code : String?
    var rating : Double?
    var regulatory_investigator : String?
    var document : String?
    var status : Int?
    var created_at : String?
    var updated_at : String?
    var product_investment_count : Int?
    var investment_product_total : Int?
    var invested_amount : Double?
    var category : Category?
    var assettype : String?
    var tokentype : String?
    var product_child_image : [Product_child_image]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        user_id <- map["user_id"]
        product_title <- map["product_title"]
        product_image <- map["product_image"]
        products <- map["products"]
        token_image <- map["token_image"]
        category_id <- map["category_id"]
        product_description <- map["product_description"]
        product_amount <- map["product_amount"]
        product_value <- map["total_product_value"]
        brand <- map["brand"]
        ean_upc_code <- map["ean_upc_code"]
        hs_code <- map["hs_code"]
        rating <- map["rating"]
        regulatory_investigator <- map["regulatory_investigator"]
        document <- map["document"]
        status <- map["status"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        product_investment_count <- map["product_investment_count"]
        investment_product_total <- map["investment_product_total"]
        invested_amount <- map["invested_amount"]
        category <- map["category"]
        assettype <- map["assettype"]
        tokentype <- map["tokentype"]
        product_child_image <- map["product_child_image"]
    }

}

struct Product_child_image : Mappable {
    var id : Int?
    var product_id : Int?
    var image : String?
    var created_at : String?
    var updated_at : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        product_id <- map["product_id"]
        image <- map["image"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
    }

}


struct Category : Mappable {
    var id : Int?
    var category_name : String?
    var image : String?
    var created_at : String?
    var updated_at : String?
    var deleted_at : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        category_name <- map["category_name"]
        image <- map["image"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        deleted_at <- map["deleted_at"]
    }

}
