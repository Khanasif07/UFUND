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

struct ProductDetailsEntity : Mappable {
    var data : ProductModel?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        data <- map["data"]
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
    var last_page: Int?
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
        last_page <- map["last_page"]
        per_page <- map["per_page"]
        last_page_url <- map["ast_page_url"]
        first_page_url <- map["first_page_url"]
        data <- map["data"]
    }
}
 
 


struct ProductModel: Mappable {
    var id : Int?
    var user_id : Int?
    var avilable_token : Int?
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
    var upc_code : String?
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
    var payment_method_type : [Payment_method]?
    var end_date : String?
    var start_date: String?
    var maturity_date : String?
    var maturity_count : String?
    var token_type : Asset_type?
    //TokenizedAssets Key
    var asset : Asset?
    var tokenrequest : Tokenrequest?
    var tokenname: String?
    var tokensupply: Int?
    var move_to_sale : String?
    var tokensymbol: String?
    var tokenvalue: Double?
    var user: UserProfile?
    var decimal: String?
    var contract_address: String?
//    var token_type: Int?
    var product_status: Int?
    var token_status: Int?
    var user_product: UserProduct?
    //
    var asset_id : Int?
    var token_id : Int?
    var asset_title: String?
    var asset_type : String?
    var asset_amount: Int?
    var asset_description: String?
    var invest_profit_percentage : String?
    var reward : String?
    var reward_value : Int?
    var reward_date: String?
    var investment_date : String?
    var startDate: Date?
    var endDate: Date?
    var investmentDate : Date?
    var rewardDate : Date?
    var auditor_name: String?

    init?(map: Map) {

    }
    
    init(json: [String:Any]){
        
    }

    mutating func mapping(map: Map) {
        auditor_name <- map["auditor_name"]
        reward_value <- map["reward_value"]
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
        tokenrequest <- map["tokenrequest"]
        tokenname <- map["tokenname"]
        tokensupply <- map["tokensupply"]
        tokensymbol <- map["tokensymbol"]
        tokenvalue <- map["tokenvalue"]
        user <- map["user"]
        decimal <- map["decimal"]
        contract_address <- map["contract_address"]
        token_type <- map["token_type"]
        asset <- map["asset"]
        avilable_token <- map["avilable_token"]
//        token_type <- map["token_type"]
        
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
        product_status <- map["product_status"]
        token_status <- map["token_status"]
        user_product <- map["user_product"]
      
    }
    
    public func getDictForAddProduct()->[String:Any]{
        var dict = [String:Any]()
        dict[ProductCreate.keys.product_title] = self.product_title
        dict[ProductCreate.keys.category_id] = self.category_id
        dict[ProductCreate.keys.product_description] = self.product_description
        dict[ProductCreate.keys.products] = self.products
        dict[ProductCreate.keys.product_value] = self.product_value
        dict[ProductCreate.keys.brand] = self.brand
//        dict[ProductCreate.keys.ean_upc_code] = (self.ean_upc_code ?? "") + "/" + (self.upc_code ?? "")
        dict[ProductCreate.keys.ean_code] = (self.ean_upc_code ?? "")
        dict[ProductCreate.keys.upc_code] = (self.upc_code ?? "")
        dict[ProductCreate.keys.hs_code] = self.hs_code
        if let maturityCountValue = self.maturity_count?.components(separatedBy: " ").first{
             dict[ProductCreate.keys.maturity_count] = maturityCountValue
        }
        dict[ProductCreate.keys.start_date] = self.start_date
        dict[ProductCreate.keys.end_date] = self.end_date
        dict[ProductCreate.keys.investment_date] = self.investment_date
        dict[ProductCreate.keys.invest_profit_percentage] = self.invest_profit_per
        dict[ProductCreate.keys.request_deploy] = self.request_deploy
        return dict
    }
    
    public func getDictForAddAsset()->[String:Any]{
        var param = [String:Any]()
        param[ProductCreate.keys.tokenname] = self.tokenname
        param[ProductCreate.keys.tokensymbol] = self.tokensymbol
        param[ProductCreate.keys.tokenvalue] = self.tokenvalue
        param[ProductCreate.keys.tokensupply] = self.tokensupply
        param[ProductCreate.keys.decimal] = decimal
        param[ProductCreate.keys.asset_title] = self.asset_title
        param[ProductCreate.keys.asset_description] = self.asset_description
        param[ProductCreate.keys.asset_amount] = self.asset_amount
        param[ProductCreate.keys.category_id] = self.category_id
        param[ProductCreate.keys.asset_type] = self.asset_id
        param[ProductCreate.keys.token_type] = self.token_id
        param[ProductCreate.keys.request_deploy] = self.request_deploy
        param[ProductCreate.keys.start_date] = self.start_date
        param[ProductCreate.keys.end_date] = self.end_date
        param[ProductCreate.keys.reward_date] = self.reward_date
        param[ProductCreate.keys.reward] = self.reward == "Interest" ? 2 : (self.reward == "Good" ? 1 : 3)
        param[ProductCreate.keys.reward_value] = self.reward_value
        param[ProductCreate.keys.auditor_name] = self.auditor_name
        
        return param
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
//        print("**payment_method_type",payment_method_type)
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
    var avilable_token: Int?
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
    var token_type : Asset_type?
    var security_type : Int?
    var trade_locked : Int?
    var trade_burn : Int?
    var status : Int?
    var description : String?
    var request_deploy : Int?
    var created_at : String?
    var updated_at : String?
    var asset : Asset?

    init?(map: Map) {

    }
    
    init(json: [String:Any]){
        
    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        user_id <- map["user_id"]
        avilable_token <- map["avilable_token"]
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
        description <- map["description"]
    }

}


struct Asset : Mappable {
    var id : Int?
    var token_id : Int?
    var avilable_token: Int?
    var tokensupply: Int?
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
    var reward: Int?
    var offer_start: String?
    var offer_end : String?
    var reward_date : String?
    
    init?(map: Map) {

    }
    
    init(json: [String:Any]){
        
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
        reward <- map["reward"]
        tokensupply <- map["tokensupply"]
        avilable_token <- map["avilable_token"]
        offer_start <- map["offer_start"]
        offer_end <- map["offer_end"]
        reward_date <- map["reward_date"]
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

struct UserProduct : Mappable{
    var amount : Int?
    var created_at : String?
    var id : Int?
    var payment_id : String?
    var product_id : String?
    var product_type : String?
    var quantity : Int?
    var updated_at : String?
    var user_id : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        amount <- map["amount"]
        created_at <- map["created_at"]
        id <- map["id"]
        payment_id <- map["payment_id"]
        product_id <- map["product_id"]
        product_type <- map["product_type"]
        quantity <- map["quantity"]
        updated_at <- map["updated_at"]
        user_id <- map["user_id"]
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


struct Payment_method : Mappable {
    var key : String?
    var name : String?
    var value : String?
    var id : Int?
    var isSelected: Bool = false

    init(json: [String:Any]){
        
    }
    
    init(value: String){
        self.value = value
        self.key = value
    }
    
    init(){}
    init?(map: Map) {

    }
    mutating func mapping(map: Map) {
        key <- map["key"]
        value <- map["value"]
        id <- map["id"]
        name <- map["name"]
    }

}
struct Payment_method_Entity : Mappable {
    var data : [Payment_method]?
    init?(map: Map) {

    }
    mutating func mapping(map: Map) {
        data <- map["data"]
    }
}
  

struct BuyInvestHistoryEntity : Mappable {
    var data : BuyInvestEntity?
    init?(map: Map) {

    }
    mutating func mapping(map: Map) {
        data <- map["data"]
    }
}

struct BuyInvestEntity : Mappable {
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
 
