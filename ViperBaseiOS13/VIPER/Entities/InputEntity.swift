//
//  InputEntity.swift
//  ViperBaseiOS13
//
//  Created by Deepika on 02/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import Foundation

import UIKit

struct RegisterParam
{
    
    static let keys = RegisterParam()
    
    let username = "username"
    let password = "password"
    let grant_type = "grant_type"
    let client_id = "client_id"
    let client_secret = "client_secret"
    let user_type = "user_type"
    let mobile = "mobile"
    let last_name = "last_name"
    let name = "name"
    let signup_by = "signup_by"
    let social_id = "social_id"
    let socialId = "socialId"
    let is_manual = "is_manual"
    let email = "email"
    let device_id = "device_id"
    let device_token = "device_token"
    let device_type = "device_type"
    let old_password = "old_password"
    let password_confirmation = "password_confirmation"
    let id = "id"
    let totp = "totp"
    let pin = "pin"

}



struct ProductCreate {
    
    static let keys = ProductCreate()
    
    let payMethod = "payMethod"
    let invest_profit_percentage = "invest_profit_percentage"
    let maturity_count = "maturity_count"
    let product_title = "product_title"
    let category_id = "category_id"
    let product_id = "product_id"
    let product_image = "product_image"
    let product_child_image = "product_child_image"
    let product_description = "product_description"
    let product_value = "product_value"
    let regulatory_investigator = "regulatory_investigator"
    let document = "document"
    let token_image = "token_image"
    let tokenname = "tokenname"
    let tokenId = "tokenId"
    let token_id = "token_id"
    let amount = "amount"
    let receiver_address = "receiver_address"
    let to_eth_address = "to_eth_address"
    let tokenDetail = "Token Details"
    let token = "Token"
    let tokensymbol = "tokensymbol"
    let tokenvalue = "tokenvalue"
    let tokensupply = "tokensupply"
    let decimal = "decimal"
    let asset_title = "asset_title"
    let asset_image = "asset_image"
    let asset_description = "asset_description"
    let asset_amount = "asset_amount"
    let asset_type = "asset_type"
    let asset_child_image = "asset_child_image"
    let brand = "brand"
    let ean_upc_code = "ean_upc_code"
    let ean_code = "ean_code"
    let upc_code = "upc_code"
    let hs_code = "hs_code"
    let products = "products"
    let token_type = "token_type"
    let request_deploy = "request_deploy"
    let start_date = "start_date"
    let end_date = "end_date"
       let investment_date = "investment_date"
    let reward_date = "reward_date"
    let reward = "reward"
    let reward_value = "reward_value"
    let auditor_name = "auditor_name"
    
    //
    let tokens_assets = "Tokens & Assets"
    let category = "category"
    let txn_types = "txn_types"
    let search = "search"
    let min = "min"
    let max = "max"
    let new_products = "new_products"
    let category_type = "category_type"
    let sort_order = "sort_order"
    let sort_by = "sort_by"
    let reward_by = "reward_by"
    let currency = "currency"
    let page = "page"
    let start_from = "start_from"
    let offer_from = "offer_from"
    let offer_to = "offer_to"
    let start_to = "start_to"
    let close_from  = "close_from"
    let close_to = "close_to"
    let end_from = "end_from"
    let end_to = "end_to"
    let status = "status"
    let type = "type"
    let filter_type = "filter_type"
    let min_percentage = "min_percentage"
    let max_percentage = "max_percentage"
    let min_earning = "min_earning"
    let max_earning = "max_earning"
    let maturity_from = "maturity_from"
    let maturity_to = "maturity_to"
    

}


struct ProfileUpdate  {
    
    static let keys = ProfileUpdate()

    let name = "name"
    let last_name = "last_name"
    let picture = "picture"
    let mobile = "mobile"
    let countryCode = "countryCode"
    let address1 = "address1"
    let address2 = "address2"
    let total_annual_revenue = "total_annual_revenue"
    let zip_code = "zip_code"
    let city = "city"
    let state = "state"
    let country  = "country"
    let  bank_name = "bank_name"
    let     account_name = "account_name"
    let   account_number = "account_number"
    let     routing_number = "routing_number"
    let    iban_number = "iban_number"
    let   swift_number = "swift_number"
    let     account_currency = "account_currency"
    let     bank_address = "bank_address"
    //
    let     user_account_type = "user_account_type"
    let     income_type = "income_type"
    let     revenue = "revenue"
    let     company_name = "company_name"
    let     company_email = "company_email"
    let     company_telephone = "company_telephone"
    let     company_address = "company_address"
    let     account_type = "account_type"
}

struct TransactionParam {
    
    static let keys = TransactionParam()
    
    let product_id = "product_id"
    let type = "type"
    let amount = "amount"
    let token_id = "token_id"
    let payment_mode = "payment_mode"
    
}
