//
//  ProductFilterVM.swift
//  ViperBaseiOS13
//
//  Created by Admin on 16/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import Foundation


protocol ProductFilterVMDelegate: class {
    func updateFiltersTabs()
}


class ProductFilterVM {
    static let shared = ProductFilterVM()
    
    var lastSelectedIndex: Int  = 0
    var defaultMinimumPrice: Double = 0.0
    var defaultMaximumPrice: Double = 0.0
    var defaultSelectedCategoryListing: [CategoryModel] = []
    var defaultSelectedCurrencyListing: [CurrencyModel] = []
    var defaultStatus: [String] = []
    var minimumPrice: Double = 0.0
    var maximumPrice: Double = 0.0
    var categoryListing: [CategoryModel] = []
    var currencyListing: [CurrencyModel] = []
    var selectedCategoryListing: [CategoryModel] = []
    var selectedCurrencyListing: [CurrencyModel] = []
    var status: [String] = []
    var isLocallyReset: Bool = false
    var isFilterAppliedDefault: Bool = false
    let allTabsStr: [String] = [Constants.string.category.localize(), Constants.string.priceRange.localize(),Constants.string.currency.localize(), Constants.string.status.localize()]

    weak var delegate: ProductFilterVMDelegate?
    
    var isFilterApplied: Bool {
        return !(selectedCategoryListing.endIndex == 0 && selectedCurrencyListing.endIndex == 0 && status.endIndex == 0)
    }


    func resetToDefault() {
        self.minimumPrice = 0.0
        self.maximumPrice = 0.0
        self.selectedCategoryListing  = []
        self.selectedCurrencyListing = []
        self.status = []
    }
    
    
    func resetToAllFilter() {
        self.minimumPrice = 0.0
        self.maximumPrice = 0.0
        self.selectedCategoryListing  = []
        self.selectedCurrencyListing = []
        self.status = []
        self.defaultMinimumPrice = 0.0
        self.defaultMaximumPrice = 0.0
        self.defaultSelectedCategoryListing = []
        self.defaultSelectedCurrencyListing = []
        self.defaultStatus = []
    }
    
    func resetToLocally(isFilterApplied:Bool = false) {
        if isFilterApplied {
            self.isLocallyReset = false
            self.minimumPrice =  self.defaultMinimumPrice
            self.maximumPrice = self.defaultMaximumPrice
            self.selectedCategoryListing  = self.defaultSelectedCategoryListing
            self.selectedCurrencyListing = self.defaultSelectedCurrencyListing
            self.status = self.defaultStatus
        } else {
            self.isLocallyReset = true
            self.defaultMinimumPrice = minimumPrice
            self.defaultMaximumPrice = maximumPrice
            self.defaultSelectedCategoryListing = selectedCategoryListing
            self.defaultSelectedCurrencyListing = selectedCurrencyListing
            self.defaultStatus = status
        }
    }
    
    public init() {
        resetToDefault()
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
