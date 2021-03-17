//
//  ApiList.swift
//  Centros_Camprios
//
//  Created by imac on 12/18/17.
//  Copyright © 2017 Appoets. All rights reserved.
//

import Foundation

//Http Method Types

enum HttpType : String {
    
    case GET = "GET"
    case POST = "POST"
    case PATCH = "PATCH"
    case PUT = "PUT"
    case DELETE = "DELETE"
    
}

// Status Code

enum StatusCode : Int {
    
    case notreachable = 0
    case success = 200
    case successCode = 201
    case socialSignupSuccessCode = 422
    case multipleResponse = 300
    case unAuthorized = 401
    case notFound = 404
    case ServerError = 500
    case errorServer = 420
    
}



enum Base : String {
    
    case signIn = "/api/login"
    case signUp = "/api/signup"
    case social_signup = "/api/social-signup"
    case profile = "/api/profile"
    case product = "/api/product"
    case category = "/api/category"
    case forgotPassword = "/api/forgot/password"
    case kyc = "/api/kyc"
    case kycUpdate = "/api/kycUpdate"
    case changePassword = "/api/changePassword"
    case assetCreate = "/api/assetcreate"
    case sliderimages = "/api/sliderimages?type=investor"
     case sliderimagesCamp = "/api/sliderimages?type=campaigner"
    case logout = "/api/logout"
    case enableGoogle = "/api/2fa/enable"
    case disableGoogle = "/api/2fa/disable"
    case checkEnable = "/api/g2fotpcheckenable"
    case gfavalidateotp = "/api/gfavalidateotp"
    case pin = "/api/setpin"
    case checkpin = "/api/check-pin"
    case pinstatus = "/api/pinstatus?type=0"
    case disableBeforeLogin = "/api/disable/2fa/before/login"
    case productCreate = "/api/productcreate"
    case approvals = "/api/campaigner/dashboard"
    case myProductList = "/api/campaigner/myproducts"
    case tokenizedAssestList = "/api/campaigner/tokenized-assets"
    case tokenRequests = "/api/campaigner/token-requests"
    case productRequests = "/api/campaigner/product-requests"
    case notificationList = "/api/notifications"
    case productDetails = "/api/product-details"
    case addModey = "/api/add-money"
    case filter = "/api/filter-data?filter_type="
    case tokenDetail = "/api/tokenized-asset-details"
    case details = "?detail="
    case  wallet = "/api/wallet"
    case payHistory = "/api/coinpayment-history"
    
    
   //INVESTOR APIS
    
    case investorAllProducts = "/api/investor/allproducts"
    case investorAllTokens = "/api/investor/alltokens"
    case investerProducts = "/api/investor/myproducts"
    case investorAssets = "/api/investor/myassets"
    case investmentproducts = "/api/investor/investmentproducts"
    case investBuyTransaction = "/api/invest-buy-transaction"
    case sellHistory = "/api/campaigner/sellHistory"
    case buyandinvesthistory = "/api/investor/buyandinvesthistory"
    case walletHistory = "/api/walletHistory"
    case sendAPI = "/api/getCoin"
    case sendCoin = "/api/sendCoin"
    
    //New APi
    case productsCurrencies = "/api/currencies"
    case categories = "/api/categories"
    case investerProductsDefault = "/api/investor/products"
    case tokenized_asset = "/api/get-tokenized-asset-list"
    case myProductInvestment = "/api/product-investment-listing"
    case myTokenInvestment = "/api/tokenized-assets-investment-listing"
    case asset_token_types = "/api/get-tokenized-asset-token-types"
    
    init(fromRawValue: String){
        self = Base(rawValue: fromRawValue) ?? .signUp
    }
    
    static func valueFor(Key : String?)->Base{
        
        guard let key = Key else {
            return Base.signUp
        }
        
        //        for val in iterateEnum(Base.self) where val.rawValue == key {
        //            return val
        //        }
        
        if let base = Base(rawValue: key) {
            return base
        }
        
        return Base.signUp
        
    }
    
}


enum AppendUrlQuery : String {
    
    case category = "?category="
    case min = "&min="
    case max = "&max="
}

enum SocialLoginType: Int {
    case facebook = 1
    case google = 2
    case linkedin = 3
    case twitter = 4
    case apple = 5
    
    var title: String {
        switch self {
        case .facebook:
            return "facebbok"
        case .google:
            return "google"
        case .linkedin:
            return  "linkedin"
        case .twitter:
            return "twitter"
        default:
            return "aaple"
        }
    }
}
