//
//  ProductModel.swift
//  ViperBaseiOS13
//
//  Created by Deepika on 07/02/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import Foundation
import ObjectMapper

struct ProductListModel : Mappable {
    
    var myproducts : [ProductModel]?
    var product_requests : [ProductModel]?
    var tokenrequests :[TokenRequestModel]?
    var tokenized_assets : [ProductListModel]?

    init?(map: Map)
    {
        
    }
    
    mutating func mapping(map: Map) {
        
        myproducts <- map["myproducts"]
        product_requests <- map["product_requests"]
        tokenrequests <- map["tokenrequests"]
        tokenized_assets <- map["tokenized_assets"]
        
  
    }

    
}

struct ProductModelEntity : Mappable {
    var categories : [Categories]?
    var data : [ProductModel]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        categories <- map["categories"]
        data <- map["data"]
    }
}

struct ProductsModelEntity : Mappable {
    var data : ProductsEntity?
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        data <- map["data"]
    }
}

struct ProductsEntity : Mappable {
    var current_page : Int?
    var from: Int?
    var path : String?
    var total:Int?
    var next_page_url: String?
    var prev_page_url: String?
    var lastPage: Int?
    var per_page: Int?
    var last_page_url: String?
    var first_page_url: String?
    var data: [ProductModel]?
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        current_page <- map["current_page"]
        from <- map["from"]
        path <- map["path"]
        total <- map["total"]
        next_page_url <- map["next_page_url"]
        prev_page_url <- map["prev_page_url"]
        lastPage <- map["lastPage"]
        per_page <- map["per_page"]
        last_page_url <- map["ast_page_url"]
        first_page_url <- map["first_page_url"]
        data <- map["data"]
    }
}
 
 


struct ProductModel: Mappable {
    var id : Int?
    var user_id : Int?
    var product_title : String?
    var product_image : String?
    var products : Int?
    var token_image : String?
    var category_id : Int?
    var product_description : String?
    var product_amount : Double?
    var total_product_value : Double?
    var commission_amount : Int?
    var commission_per : Int?
    var pending_invest_per : Int?
    var final_profit_invest_per : Int?
    var invest_profit_per : Int?
    var product_value : Int?
    var brand : String?
    var ean_upc_code : String?
    var hs_code : String?
    var rating : Double?
    var regulatory_investigator : String?
    var document : String?
    var status : Int?
    var request_deploy : Int?
    var created_at : String?
    var updated_at : String?
    var investment_product_total : Double?
    var category : Category?
    var assettype : String?
    var tokentype : String?
    var product_child_image : [AssetChildImage]?
    var invested_amount: Double?
    var earnings: Double?
    var product_investment_count: Int?
    var payment_method_type : [Payment_method_type]?
    
    var end_date : String?
    var start_date: String?
    
       var maturity_date : String?
    var maturity_count : String?
   
    
        var move_to_sale : String?
   

    init?(map: Map) {

    }
    
    init(json: [String:Any]){
        
    }

    mutating func mapping(map: Map) {
        maturity_date <- map["maturity_date"]
        maturity_count <- map["maturity_count"]
        move_to_sale <- map["move_to_sale"]
        start_date <- map["start_date"]
        end_date <- map["end_date"]
        payment_method_type <- map["payment_method_type"]
        id <- map["id"]
        user_id <- map["user_id"]
        product_title <- map["product_title"]
        product_image <- map["product_image"]
        products <- map["products"]
        token_image <- map["token_image"]
        category_id <- map["category_id"]
        product_description <- map["product_description"]
        product_amount <- map["product_amount"]
        total_product_value <- map["total_product_value"]
        commission_amount <- map["commission_amount"]
        commission_per <- map["commission_per"]
        pending_invest_per <- map["pending_invest_per"]
        final_profit_invest_per <- map["final_profit_invest_per"]
        invest_profit_per <- map["invest_profit_per"]
        product_value <- map["product_value"]
        brand <- map["brand"]
        ean_upc_code <- map["ean_upc_code"]
        hs_code <- map["hs_code"]
        rating <- map["rating"]
        regulatory_investigator <- map["regulatory_investigator"]
        document <- map["document"]
        status <- map["status"]
        request_deploy <- map["request_deploy"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        investment_product_total <- map["investment_product_total"]
        
        if investment_product_total == nil {
            
            var values : String?
              values <- map["investment_product_total"]
            
            investment_product_total = Double(nullStringToEmpty(string: values))
        }
        
        category <- map["category"]
        assettype <- map["assettype"]
        tokentype <- map["tokentype"]
        product_child_image <- map["product_child_image"]
        invested_amount <- map["invested_amount"]
        earnings <- map ["earnings"]
        product_investment_count <- map["product_investment_count"]
      
    }

}


struct ChildImageModel : Mappable {
    
    var id : Int?
    var product_id : Int?
    var  image : String?
 
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
   
    id <- map["id"]
    product_id <- map["product_id"]
    image <- map["image"]
    
        
    }
    
    
}


struct TokenAssetsNewEntity : Mappable {
    
    var categories : [Categories]?
    var data : [TokenRequestModel]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        categories <- map["categories"]
        data <- map["data"]
    }

}


struct TokenRequestModel : Mappable {
    
    var id : Int?
    var user_id : Int?
    var tokenname : String?
    var tokensymbol : String?
    var tokenvalue : Double?
    var total_token_value : Int?
    var commission_amount : Int?
    var commission_per : Int?
    var tokensupply : Int?
    var decimal : String?
    var contract_address : String?
    var token_image : String?
    var token_request_id : Int?
    var security_type : Int?
    var token_type : Int?
    var trade_locked : Int?
    var trade_burn : Int?
    var issued_by : Int?
    var status : Int?
    var request_deploy : Int?
    var tokenrequest : Tokenrequest?
var asset : Asset?
    
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        user_id <- map["user_id"]
        tokenname <- map["tokenname"]
        tokensymbol <- map["tokensymbol"]
        tokenvalue <- map["tokenvalue"]
        total_token_value <- map["total_token_value"]
        commission_amount <- map["commission_amount"]
        commission_per <- map["commission_per"]
        tokensupply <- map["tokensupply"]
        decimal <- map["decimal"]
        contract_address <- map["contract_address"]
        token_image <- map["token_image"]
        token_request_id <- map["token_request_id"]
        security_type <- map["security_type"]
        token_type <- map["token_type"]
        trade_locked <- map["trade_locked"]
        trade_burn <- map["trade_burn"]
        issued_by <- map["issued_by"]
        status <- map["status"]
        request_deploy <- map["request_deploy"]
        tokenrequest <- map["tokenrequest"]
         asset <- map["asset"]
    }

}

struct  TokenRequest : Mappable {
    
    var id : Int?
    var user_id : Int?
    var tokenname : String?
    var tokensymbol : String?
    var tokenvalue : Double?
    var tokensupply : Double?
    var decimal : String?
    var contract_address : String?
    var tokenimage : String?
    var token_request_id : Int?
    var security_type : Int?
    var token_type : Int?
    var trade_locked : Int?
    var trade_burn : Int?
    var issued_by : Int?
    var status : Int?
    var user : String?
    var tokenrequest : Tokenrequest?
    
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        user_id <- map["user_id"]
        tokenname <- map["tokenname"]
        tokensymbol <- map["tokensymbol"]
        tokenvalue <- map["total_token_value"]
        tokensupply <- map["tokensupply"]
        decimal <- map["decimal"]
        contract_address <- map["contract_address"]
        tokenimage <- map["tokenimage"]
        token_request_id <- map["token_request_id"]
        security_type <- map["security_type"]
        token_type <- map["token_type"]
        trade_locked <- map["trade_locked"]
        trade_burn <- map["trade_burn"]
        issued_by <- map["issued_by"]
        status <- map["status"]
        user <- map["user"]
        tokenrequest <- map["tokenrequest"]
    }
    
}


struct TokenDetailsEntity : Mappable {
    
    var avilable_token: Double?
    var id : Int?
    var user_id : Int?
    var tokenname : String?
    var tokensymbol : String?
    var tokenvalue : Double?
    var tokensupply : Int?
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
    var detail : String?
    var asset : Asset?
    var tokenrequest: Tokenrequest?
    var payment_method_type : [Payment_method_type]?
    

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
       payment_method_type <- map["payment_method_type"]
        print("**payment_method_type",payment_method_type)
avilable_token <- map["avilable_token"]
        id <- map["id"]
        user_id <- map["user_id"]
        tokenname <- map["tokenname"]
        tokensymbol <- map["tokensymbol"]
        tokenvalue <- map["total_token_value"]
        tokensupply <- map["tokensupply"]
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
        detail <- map["detail"]
        asset <- map["asset"]
        tokenrequest <- map[""]
    }

}




struct Tokenrequest : Mappable {
    var id : Int?
    var user_id : Int?
    var tokenname : String?
    var tokensymbol : String?
    var tokenvalue : Double?
    var total_token_value : Double?
    var commission_amount : Int?
    var commission_per : Int?
    var tokensupply : Int?
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
    var asset : Asset?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        user_id <- map["user_id"]
        tokenname <- map["tokenname"]
        tokensymbol <- map["tokensymbol"]
        tokenvalue <- map["tokenvalue"]
        total_token_value <- map["total_token_value"]
        commission_amount <- map["commission_amount"]
        commission_per <- map["commission_per"]
        tokensupply <- map["tokensupply"]
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
        asset <- map["asset"]
    }

}


struct Asset : Mappable {
    var id : Int?
    var token_id : Int?
    var asset_title : String?
    var asset_image : String?
    var description : String?
    var asset_value : Double?
    var rating : Int?
    var category_id : Int?
    var asset_type : Asset_type?
    var regulatory_investigator : String?
    var document : String?
    var created_at : String?
    var updated_at : String?
    var category : Category?
    var asset_child_image : [AssetChildImage]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        token_id <- map["token_id"]
        asset_title <- map["asset_title"]
        asset_image <- map["asset_image"]
        description <- map["description"]
        asset_value <- map["asset_value"]
        rating <- map["rating"]
        category_id <- map["category_id"]
        asset_type <- map["asset_type"]
        regulatory_investigator <- map["regulatory_investigator"]
        document <- map["document"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        category <- map["category"]
        asset_child_image <- map["asset_child_image"]
    }

}



struct Asset_type : Mappable {
    var id : Int?
    var name : String?
    var type : Int?
    var created_at : String?
    var updated_at : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        name <- map["name"]
        type <- map["type"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
    }

}


struct AssetChildImage : Mappable {
    
    var image : String?
    init?(map: Map) {

       }

       mutating func mapping(map: Map) {

           image <- map["image"]
           
       }
}



struct SendEntity : Mappable {
    var user : UserHistory?
    var eth_balance : Double?
    var tokens : [Tokens]?
var transactions : [Transactions]?
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        user <- map["user"]
        eth_balance <- map["eth_balance"]
        tokens <- map["tokens"]
        transactions <- map["transactions"]
    }

}


struct Token_details : Mappable {
    var id : Int?
    var user_id : Int?
    var tokenname : String?
    var tokensymbol : String?
    var tokenvalue : Double?
    var total_token_value : Double?
    var commission_amount : Double?
    var commission_per : Int?
    var tokensupply : Int?
    var decimal : String?
    var contract_address : String?
    var token_image : String?
    var token_request_id : Int?
    var security_type : Int?
    var token_type : Int?
    var trade_locked : Int?
    var trade_burn : Int?
    var issued_by : Int?
    var status : Int?
    var request_deploy : Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        user_id <- map["user_id"]
        tokenname <- map["tokenname"]
        tokensymbol <- map["tokensymbol"]
        tokenvalue <- map["tokenvalue"]
        total_token_value <- map["total_token_value"]
        commission_amount <- map["commission_amount"]
        commission_per <- map["commission_per"]
        tokensupply <- map["tokensupply"]
        decimal <- map["decimal"]
        contract_address <- map["contract_address"]
        token_image <- map["token_image"]
        token_request_id <- map["token_request_id"]
        security_type <- map["security_type"]
        token_type <- map["token_type"]
        trade_locked <- map["trade_locked"]
        trade_burn <- map["trade_burn"]
        issued_by <- map["issued_by"]
        status <- map["status"]
        request_deploy <- map["request_deploy"]
    }

}


struct Tokens : Mappable {
    var id : Int?
    var user_id : Int?
    var user_contract_id : Int?
    var token_acquire : Double?
    var created_at : String?
    var updated_at : String?
    var token_details : Token_details?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        user_id <- map["user_id"]
        user_contract_id <- map["user_contract_id"]
        token_acquire <- map["token_acquire"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        token_details <- map["token_details"]
    }

}

struct Payment_method_type : Mappable {
    var name : String?
    var value : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        name <- map["name"]
        value <- map["value"]
    }

}
