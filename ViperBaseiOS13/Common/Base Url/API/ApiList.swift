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
    case contact_Us = "/api/contact-us"
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
//    case  wallet = "/api/wallet"
    case payHistory = "/api/coinpayment-history"
    
    
   //INVESTOR APIS
    
    case investorAllProducts = "/api/investor/allproducts"
    case investorAllTokens = "/api/investor/alltokens"
    case investerProducts = "/api/investor/myproducts"
    case investorAssets = "/api/investor/myassets"
    case investmentproducts = "/api/investor/investmentproducts"
    case investBuyTransaction = "/api/invest-buy-transactionn"
    case sellHistory = "/api/campaigner/sellHistory"
    case buyandinvesthistory = "/api/investor/buyandinvesthistory"
    case walletHistory = "/api/walletHistory"
    case sendAPI = "/api/getCoin"
    case sendCoin = "/api/sendToken"
    
    //New APi
    case productsCurrencies = "/api/currencies"
    case categories = "/api/categories"
    case investerProductsDefault = "/api/investor/products"
    case campaignerProductsDefault = "/api/campaigner-my-products"
    case campaignerTokenizedAssetsDefault = "/api/campaigner-tokenized-assets"
    case tokenized_asset = "/api/get-tokenized-asset-list"
    case new_tokenized_asset = "/api/get-new-tokenized-asset-list"
    case myProductInvestment = "/api/product-investment-listing"
    case myTokenInvestment = "/api/tokenized-assets-investment-listing"
    case asset_token_types = "/api/get-tokenized-asset-token-types"
    case investor_dashboard = "/api/investor-dashboard"
    case investor_dashboard_graph = "/api/investor-dashboard-graph"
    case campaigner_dashboard = "/api/campaigner-dashboard"
    case campaigner_create_asset = "/api/campaigner-create-asset"
    case campaigner_create_product = "/api/campaigner-create-product"
    case productsDetail = "api/product-details"
    case tokensDetail = "api/get-tokenized-asset-detail"
    case campaignerTokensDetail = "api/get-campaigner-tokenized-asset-detail"
    case paymentMethods = "/api/pay-methods"
    case wallet = "/api/get-balance"
    case withdraw = "/api/withdraw"
    case deposit_Url = "/api/get-deposit-url"
    case yieldBalance = "/api/yeild-getbalance"
    case yieldBuyInvest = "/api/yieldbuy-invest"
    case get_user_token = "/api/get-user-token"
    case investor_wallet_counts = "/api/wallet-counts"
    case invest_buy_transaction =  "/api/invest-buy-transaction"
    case buyTokens = "/api/buy-tokens"
    case wallet_sell_hisory =  "/api/wallet-sell-history"
    case invester_buy_Invest_hisory =  "/api/investor-buy-invest-history"
//    case campaigner_dashboard_sellHistory = "/api/campaigner-dashboard-sell-history"
    
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

 enum AddProductCell{
     case basicDetailsAssets
     case basicDetailsProduct
     case productSpecifics
     case assetsSpecifics
     case dateSpecificsProducts
     case dateSpecificsAssets
     case documentImage
     
    var sectionCount: Int {
        switch self{
        case .basicDetailsAssets:
            return 7
        case .basicDetailsProduct:
            return 6
        case .productSpecifics:
            return 4
        case .assetsSpecifics:
            return 4
        case .dateSpecificsProducts:
            return 4
        case .dateSpecificsAssets:
            return 4
        case .documentImage:
            return 1
        }
    }
     
     var titleValue: String {
         switch self{
         case .basicDetailsAssets,.basicDetailsProduct:
             return "Basic Details"
         case .productSpecifics:
             return "Product Specifics"
        case .assetsSpecifics:
            return "Asset Specifics"
         case .dateSpecificsProducts,.dateSpecificsAssets:
             return "Date Specifics"
         case .documentImage:
             return "Document & Image"
         }
     }
 }

enum SendCoinCell{
    case tokensListing
    case TransactionHistory
    
    var sectionCount: Int {
        switch self{
        case .tokensListing:
            return 1
        case .TransactionHistory:
            return 1
        }
    }
    
    var titleValue: String {
        switch self{
        case .tokensListing:
            return "Number of Tokens"
        case .TransactionHistory:
            return "Transaction history"
        }
    }
}
