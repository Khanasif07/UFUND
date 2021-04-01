//
//  AddProductModel.swift
//  ViperBaseiOS13
//
//  Created by Admin on 01/04/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import Foundation
struct AddProductModel {
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
    //TokenizedAssets Key
    var tokenrequest : Tokenrequest?
    var tokenname: String?
    var tokensupply: Int?
    var move_to_sale : String?
    var tokensymbol: String?
    var tokenvalue: Int?
    var user: UserProfile?
    var decimal: Int?
    var contract_address: String?
    var token_type: Int?
    var product_status: Int?
    var token_status: Int?
    
    init(json: [String:Any]){
        
    }
    
    init(){
        
    }
}
