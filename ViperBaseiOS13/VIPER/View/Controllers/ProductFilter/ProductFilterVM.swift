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
    var minimumPrice: Double = 0.0
    var maximumPrice: Double = 0.0
    var categoryListing: [CategoryModel] = []
    var currencyListing: [CurrencyModel] = []
    var selectedCategoryListing: [CategoryModel] = []
    var selectedCurrencyListing: [CurrencyModel] = []
    var status: [String] = []
    var isSortingApplied: Bool = false
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
    
    private init() {
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
