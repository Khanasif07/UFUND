//
//  ProductFilterVM.swift
//  ViperBaseiOS13
//
//  Created by Admin on 16/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import Foundation
import UIKit

protocol ProductFilterVMDelegate: class {
    func updateFiltersTabs()
}


class ProductFilterVM {
    static let shared = ProductFilterVM()
    
    
    var lastSelectedIndex: Int  = 0
    //Product
    var minimumPrice: CGFloat = 0.0
    var maximumPrice: CGFloat = 800000.0
    var categoryListing: [CategoryModel] = []
    var currencyListing: [CurrencyModel] = []
    var selectedCategoryListing: [CategoryModel] = []
    var selectedCurrencyListing: [CurrencyModel] = []
    var status: [String] = []
    let allTabsStr: [String] = [Constants.string.category.localize(), Constants.string.priceRange.localize(),Constants.string.currency.localize(), Constants.string.status.localize()]
    let allTabsStrWithoutCategory: [String] = [ Constants.string.priceRange.localize(),Constants.string.currency.localize(), Constants.string.status.localize()]
    //Assets
    var start_from : String = ""
    var start_to : String = ""
    var close_from : String = ""
    var close_to : String = ""
    var types : [String] = []
    var byRewards : [String] = []
    let allTabsStrForAssets: [String] = [Constants.string.category.localize(), Constants.string.type.localize(),Constants.string.price.localize(), Constants.string.startDate.localize(),Constants.string.closingDate.localize(),Constants.string.byReward.localize()]
    let allTabsStrForAssetsWithoutCategory: [String] = [Constants.string.type.localize(),Constants.string.price.localize(), Constants.string.startDate.localize(),Constants.string.closingDate.localize(),Constants.string.byReward.localize()]
    //Investment
    var investmentStart_from = ""
    var investmentStart_to = ""
    var investmentClose_from = ""
    var investmentClose_to = ""
    var investmentMaturity_from = ""
    var investmentMaturity_to = ""
    var minimumEarning: CGFloat = 0.0
    var maximumEarning: CGFloat = 0.0
    var minimumYield: CGFloat = 0.0
    var maximumYield: CGFloat = 0.0
    let allTabsStrForInvestments: [String] = [Constants.string.category.localize(), Constants.string.startDate.localize(),Constants.string.priceRange.localize(), Constants.string.earning.localize(),Constants.string.yield.localize(),Constants.string.endDate.localize(),Constants.string.maturityDate.localize()]

    weak var delegate: ProductFilterVMDelegate?
    
    var isFilterApplied: Bool {
        return !(selectedCategoryListing.endIndex == 0 && selectedCurrencyListing.endIndex == 0 && status.endIndex == 0 && self.types.endIndex == 0 && self.byRewards.endIndex == 0 && self.start_from.isEmpty && self.start_to.isEmpty && self.close_from.isEmpty && self.close_to.isEmpty && self.investmentStart_from.isEmpty && self.investmentStart_to.isEmpty && self.investmentClose_from.isEmpty && self.investmentClose_to.isEmpty && self.investmentMaturity_from.isEmpty && self.investmentMaturity_to.isEmpty && self.minimumPrice == 0.0 && self.maximumPrice == 0.0)
    }

    func resetToAllFilter() {
        //Product
        self.minimumPrice = 0.0
        self.maximumPrice = 0.0
        self.selectedCategoryListing  = []
        self.selectedCurrencyListing = []
        self.status = []
        //Assets
        self.byRewards = []
        self.types = []
        self.start_from = ""
        self.start_to = ""
        self.close_from = ""
        self.close_to = ""
        //Investment
        self.maximumYield = 0.0
        self.minimumYield = 0.0
        self.minimumEarning = 0.0
        self.maximumEarning = 0.0
        self.investmentStart_from = ""
        self.investmentStart_to = ""
        self.investmentClose_to = ""
        self.investmentClose_from = ""
        self.investmentMaturity_to = ""
        self.investmentMaturity_from = ""
        
    }
    
    var paramsDictForInvestment: [String:Any]{
        var params : [String:Any] = [:]
        if self.selectedCategoryListing.endIndex > 0{
            let category =  self.selectedCategoryListing.map { (model) -> String in
                return String(model.id ?? 0)
            }.joined(separator: ",")
            params[ProductCreate.keys.category] = category
        }
        if self.minimumPrice != 0.0{
            params[ProductCreate.keys.min] = self.minimumPrice
        }
        if self.maximumPrice != 0.0{
            params[ProductCreate.keys.max] = self.maximumPrice
            params[ProductCreate.keys.min] = self.minimumPrice
        }
        if self.maximumYield != 0.0 {
             params[ProductCreate.keys.max_percentage] = self.maximumYield
        }
        if  self.minimumYield != 0.0{
             params[ProductCreate.keys.min_percentage] = self.minimumYield
        }
        if    self.minimumEarning != 0.0{
             params[ProductCreate.keys.min_earning] = self.minimumEarning
        }
        if  self.maximumEarning != 0.0{
             params[ProductCreate.keys.max_earning] = self.maximumEarning
        }
        if !self.investmentMaturity_from.isEmpty {
            params[ProductCreate.keys.maturity_from] = self.investmentMaturity_from
        }
        if !self.investmentMaturity_to.isEmpty {
            params[ProductCreate.keys.maturity_to] = self.investmentMaturity_to
        }
        if !self.investmentStart_from.isEmpty {
            params[ProductCreate.keys.start_from] = self.investmentStart_from
        }
        if !self.investmentStart_to.isEmpty {
            params[ProductCreate.keys.start_to] = self.investmentStart_to
        }
        if !self.investmentClose_from.isEmpty {
            params[ProductCreate.keys.end_from] = self.investmentClose_from
        }
        if !self.investmentClose_to.isEmpty {
            params[ProductCreate.keys.end_to] = self.investmentClose_to
        }
        return params
    }
    
    var paramsDictForAssets: [String:Any]{
        
        var params : [String:Any] = [:]
        if self.selectedCategoryListing.endIndex > 0{
            let category =  self.selectedCategoryListing.map { (model) -> String in
                return String(model.id ?? 0)
            }.joined(separator: ",")
            params[ProductCreate.keys.category] = category
        }
        if self.minimumPrice != 0{
            params[ProductCreate.keys.min] = self.minimumPrice
        }
        if self.maximumPrice != 0{
            params[ProductCreate.keys.max] = self.maximumPrice
        }
        if self.types.endIndex > 0{
            if self.types.contains(AssetsType.All.title){
            }
            else if self.types.contains(AssetsType.Token.title){
                params[ProductCreate.keys.token_type] = AssetsType.Token.rawValue
            }
            else if self.types.contains(AssetsType.Assets.title){
                params[ProductCreate.keys.token_type] = AssetsType.Assets.rawValue
            }
        }
        if self.byRewards.endIndex > 0{
            if !self.byRewards.contains(AssetsByReward.All.title){
                let byRewards =  self.byRewards.map { (model) -> String in
                    return model
                }.joined(separator: ",")
                params[ProductCreate.keys.reward_by] = byRewards
            }
        }
        if !self.start_from.isEmpty{ params[ProductCreate.keys.start_from] = self.start_from }
        if !self.start_to.isEmpty{ params[ProductCreate.keys.start_to] = self.start_to }
        if !self.close_from.isEmpty{ params[ProductCreate.keys.close_from] = self.close_from }
        if !self.close_to.isEmpty{ params[ProductCreate.keys.close_to] = self.close_to }
        return params
    }
    
    public init() {
        resetToAllFilter()
    }
}
   
enum Status: String ,CaseIterable {
    case All = "3"
    case Live = "1"
    case Matured = "2"
    var title: String {
        switch self {
        case .All:
            return "All"
        case .Live:
            return "Live"
        case .Matured:
            return "Matured"
        }
    }
}

enum AssetsType : String ,CaseIterable {
    case All = "3"
    case Token = "1"
    case Assets = "2"
    var title: String {
        switch self {
        case .All:
            return "All"
        case .Token:
            return "Token"
        case .Assets:
            return "Assets"
        }
    }
}

enum AssetsByReward : String ,CaseIterable {
    case All = "4"
    case Interest = "1"
    case Share = "2"
    case Goods = "3"
    var title: String {
        switch self {
        case .Interest:
            return "Interest"
        case .Share:
            return "Share"
        case .Goods:
            return "Goods"
        case .All:
            return "All"
        }
    }
}
