//
//  ProductFilterVM.swift
//  ViperBaseiOS13
//
//  Created by Admin on 16/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import Foundation

enum SortUsing {
    private enum CodingKeys: CodingKey {
        case bestSellers, priceLowToHigh, tripAdvisorRatingHighToLow, starRatingHighToLow, distanceNearestFirst
    }
    
    case BestSellers
    case PriceLowToHigh
    case TripAdvisorRatingHighToLow
    case StartRatingHighToLow
    case DistanceNearestFirst
}

protocol ProductFilterVMDelegate: class {
    func updateFiltersTabs()
}


class ProductFilterVM {
    static let shared = ProductFilterVM()
    
    var defaultRatingCount: [Int] = [0,1,2,3,4,5]
    var defaultTripAdvisorRatingCount: [Int] = [1,2,3,4,5]
    var defaultIsIncludeUnrated: Bool = true
    var defaultDistanceRange: Double = 20
    var defaultLeftRangePrice: Double = 0.0
    var defaultRightRangePrice: Double = 0.0
    var defaultAmenitites: [String] = []
    var defaultRoomMeal: [String] = []
    var defaultRoomCancelation: [String] = []
    var defaultRoomOther: [String] = []
    var defaultSortUsing: SortUsing = .BestSellers
    var defaultPriceType: Price = .Total
    
    var ratingCount: [Int] = [1,2,3,4,5]
    var tripAdvisorRatingCount: [Int] = [1,2,3,4,5]
    var isIncludeUnrated: Bool = true
    var distanceRange: Double = 20
    var minimumPrice: Double = 0.0
    var maximumPrice: Double = 0.0
    var leftRangePrice: Double = 0.0
    var rightRangePrice: Double = 0.0
    var amenitites: [String] = []
    var status: [String] = []
    var roomMeal: [String] = []
    var roomCancelation: [String] = []
    var roomOther: [String] = []
    var sortUsing: SortUsing = .BestSellers
    var priceType: Price = .Total
    var totalHotelCount: Int = 0
    var filterHotelCount: Int = 0
    var lastSelectedIndex: Int = 0
    var isSortingApplied: Bool = false
    let allTabsStr: [String] = [Constants.string.category.localize(), Constants.string.priceRange.localize(),Constants.string.currency.localize(), Constants.string.status.localize()]

    weak var delegate: ProductFilterVMDelegate?
    
    var isFilterApplied: Bool {
        return !(ProductFilterVM.shared.sortUsing == ProductFilterVM.shared.defaultSortUsing && ProductFilterVM.shared.distanceRange == ProductFilterVM.shared.defaultDistanceRange && ProductFilterVM.shared.leftRangePrice == ProductFilterVM.shared.defaultLeftRangePrice && ProductFilterVM.shared.rightRangePrice == ProductFilterVM.shared.defaultRightRangePrice && ProductFilterVM.shared.ratingCount.difference(from: ProductFilterVM.shared.defaultRatingCount).isEmpty &&  ProductFilterVM.shared.tripAdvisorRatingCount.difference(from: ProductFilterVM.shared.defaultTripAdvisorRatingCount).isEmpty && ProductFilterVM.shared.isIncludeUnrated == ProductFilterVM.shared.defaultIsIncludeUnrated && ProductFilterVM.shared.priceType == ProductFilterVM.shared.defaultPriceType && ProductFilterVM.shared.amenitites.difference(from: ProductFilterVM.shared.defaultAmenitites).isEmpty && ProductFilterVM.shared.roomMeal.difference(from: ProductFilterVM.shared.defaultRoomMeal).isEmpty && ProductFilterVM.shared.roomCancelation.difference(from: ProductFilterVM.shared.defaultRoomCancelation).isEmpty && ProductFilterVM.shared.roomOther.difference(from: ProductFilterVM.shared.defaultRoomOther).isEmpty)
    }
    
//    func setData(from: UserInfo.HotelFilter) {
//        ratingCount = from.ratingCount
//        tripAdvisorRatingCount = from.tripAdvisorRatingCount
//        isIncludeUnrated = from.isIncludeUnrated
//        distanceRange = from.distanceRange
//        minimumPrice = from.minimumPrice
//        maximumPrice = from.maximumPrice
//        leftRangePrice = from.leftRangePrice
//        rightRangePrice = from.rightRangePrice
//        amenitites = from.amentities
//        roomMeal = from.roomMeal
//        roomCancelation = from.roomCancelation
//        roomOther = from.roomOther
//        sortUsing = from.sortUsing
//        priceType = from.priceType
//
//        delay(seconds: 0.3) { [weak self] in
//            self?.delegate?.updateFiltersTabs()
//        }
//
        
        
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


extension SortUsing: Codable {
    enum Key: CodingKey {
        case rawValue
    }
    
    enum CodingError: Error {
        case unknownValue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let rawValue = try container.decode(Int.self, forKey: .rawValue)
        switch rawValue {
        case 0:
            self = .BestSellers
        case 1:
            self = .PriceLowToHigh
        case 2:
            self = .TripAdvisorRatingHighToLow
        case 3:
            self = .StartRatingHighToLow
        case 4:
            self = .DistanceNearestFirst
        default:
            throw CodingError.unknownValue
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        switch self {
        case .BestSellers:
            try container.encode(0, forKey: .rawValue)
        case .PriceLowToHigh:
            try container.encode(1, forKey: .rawValue)
        case .TripAdvisorRatingHighToLow:
            try container.encode(2, forKey: .rawValue)
        case .StartRatingHighToLow:
            try container.encode(3, forKey: .rawValue)
        case .DistanceNearestFirst:
            try container.encode(4, forKey: .rawValue)
        }
    }
}

extension Price: Codable {
    enum Key: CodingKey {
        case rawValue
    }
    
    enum CodingError: Error {
        case unknownValue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let rawValue = try container.decode(Int.self, forKey: .rawValue)
        switch rawValue {
        case 0:
            self = .PerNight
        case 1:
            self = .Total
        default:
            throw CodingError.unknownValue
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        switch self {
        case .PerNight:
            try container.encode(0, forKey: .rawValue)
        case .Total:
            try container.encode(1, forKey: .rawValue)
        }
    }
}


enum Price {
    case PerNight
    case Total
}

enum ATAmenity: String, CaseIterable {
    case AirConditioner = "1"
    case BusinessCenter = "2"
    case Coffee_Shop = "3"
    case Gym = "4"
    case Internet = "5"
    case Pool = "6"
    case RestaurantBar = "7"
    case RoomService = "8"
    case Spa = "9"
    case Wifi = "10"
    
    var title: String {
        switch self {
        case .Wifi:
            return self.rawValue
            
        case .RoomService:
            return self.rawValue
            
        case .Internet:
            return self.rawValue
            
        case .AirConditioner:
            return self.rawValue
            
        case .RestaurantBar:
            return self.rawValue
            
        case .Gym:
            return self.rawValue
            
        case .BusinessCenter:
            return self.rawValue
            
        case .Pool:
            return self.rawValue
            
        case .Spa:
            return self.rawValue
            
        case .Coffee_Shop:
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
