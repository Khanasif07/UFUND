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
    var defaultCurrency: [String] = []
    var minimumPrice: Double = 0.0
    var maximumPrice: Double = 0.0
    var currency: [String] = []
    var currencyListing: [CurrencyModel] = []
    var selectedCurrencyListing: [CurrencyModel] = []
    var status: [String] = []
    var isSortingApplied: Bool = false
    let allTabsStr: [String] = [Constants.string.category.localize(), Constants.string.priceRange.localize(),Constants.string.currency.localize(), Constants.string.status.localize()]

    weak var delegate: ProductFilterVMDelegate?
    
    var isFilterApplied: Bool {
        return !(ProductFilterVM.shared.currency.difference(from: ProductFilterVM.shared.defaultCurrency).isEmpty)
    }

        
        
    }
    
//    func saveDataToUserDefaults() {
//        var filter = UserInfo.HotelFilter()
//        if 1...4 ~= ratingCount.count {
//            filter.ratingCount = ratingCount
//        }
//        else {
//            filter.ratingCount = defaultRatingCount
//        }
//        filter.tripAdvisorRatingCount = tripAdvisorRatingCount
//        filter.isIncludeUnrated = isIncludeUnrated
//        filter.distanceRange = distanceRange
//        filter.minimumPrice = minimumPrice
//        filter.maximumPrice = maximumPrice
//        filter.leftRangePrice = leftRangePrice
//        filter.rightRangePrice = rightRangePrice
//        filter.amentities = amenitites
//        filter.roomMeal = roomMeal
//        filter.roomCancelation = roomCancelation
//        filter.roomOther = roomOther
//        filter.sortUsing = sortUsing
//        filter.priceType = priceType
//
//        UserInfo.hotelFilter = filter
//
//        if let filter = UserInfo.hotelFilter {
//            printDebug(filter)
//        }
//    }
//
//    func resetToDefault() {
//        self.ratingCount = defaultRatingCount
//        self.tripAdvisorRatingCount = defaultTripAdvisorRatingCount
//        self.isIncludeUnrated = defaultIsIncludeUnrated
//        self.distanceRange = defaultDistanceRange
//        self.leftRangePrice = defaultLeftRangePrice
//        self.rightRangePrice = defaultRightRangePrice
//        self.amenitites = defaultAmenitites
//        self.roomMeal = defaultRoomMeal
//        self.roomCancelation = defaultRoomCancelation
//        self.roomOther = defaultRoomOther
//        self.sortUsing = defaultSortUsing
//        self.priceType = defaultPriceType
//    }
    
//    private init() {
//        resetToDefault()
//    }
//
   /* func filterAppliedFor(filterName: String, appliedFilter:  UserInfo.HotelFilter) -> Bool {
        
        switch filterName.lowercased() {
        case Constants.string.category.localize():
            return (appliedFilter.sortUsing == ProductFilterVM.shared.defaultSortUsing) ? false : true
            
        case Constants.string.priceRange.localize():
            return (appliedFilter.distanceRange == ProductFilterVM.shared.defaultDistanceRange) ? false : true
            
        case Constants.string.currency.localize():
            if appliedFilter.rightRangePrice <= 0 {
                return  false
            }else if appliedFilter.leftRangePrice != ProductFilterVM.shared.defaultLeftRangePrice {
                return true
            }
            else if appliedFilter.rightRangePrice != ProductFilterVM.shared.defaultRightRangePrice {
                return  true
            }
            else if appliedFilter.priceType != ProductFilterVM.shared.defaultPriceType {
                return  true
            }
            return  false
        case Constants.string.status.localize():
            
            
            let diff = appliedFilter.ratingCount.difference(from: ProductFilterVM.shared.defaultRatingCount)
            if 1...4 ~= diff.count {
                return true
            }
            else if !appliedFilter.tripAdvisorRatingCount.difference(from: ProductFilterVM.shared.defaultTripAdvisorRatingCount).isEmpty {
                return true
            }
            else if appliedFilter.isIncludeUnrated != ProductFilterVM.shared.defaultIsIncludeUnrated {
                return  true
            }
            return  false
        default:
//            printDebug("not useable case")
            return false
        }
    }*/



enum Currency : String, CaseIterable {
    case USD
    case EUR
    case CAD
    case BHD
    case BRL
    case NHD
    case DKK
    case HKD
    case IDR
    case INR
    
    var title: String {
        switch self {
        case .USD:
            return self.rawValue
        case .EUR:
            return self.rawValue
            
        case .CAD:
            return self.rawValue
            
        case .BHD:
            return self.rawValue
            
        case .BRL:
            return self.rawValue
            
        case .NHD:
            return self.rawValue
            
        case .DKK:
            return self.rawValue
            
        case .HKD:
            return self.rawValue
            
        case .IDR:
            return self.rawValue
            
        case .INR:
            return self.rawValue
        }
    }
}

enum Status: String ,CaseIterable {
    case All = "1"
    case Live = "2"
    case Matured = "3"
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
