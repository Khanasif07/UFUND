//
//  UserProfileVC+Enum.swift
//  ViperBaseiOS13
//
//  Created by Admin on 18/02/21.
//  Copyright © 2021 CSS. All rights reserved.
//
import UIKit
import Foundation

enum UserProfileAttributes: String,CaseIterable{
    case name
    case last_name
    case mobile
    case address1
    case address2
    case zip_code
    case city
    case state
    case country
    
//    case bank_name
//    case account_name
//    case account_number
//    case routing_number
//    case iban_number
//    case swift_number
//    case account_currency
//    
    var title :String{
        switch self {
        case .name:
            return "First Name"
        case .last_name:
            return "Last Name"
        case .mobile:
            return "Phone Number"
        case .address1:
            return "Address Line1"
        case .address2:
            return "Address Line 2"
        case .zip_code:
            return "ZipCode"
        case .city:
            return "City"
        case .state:
            return "State"
        case .country:
            return "Country"
        }
    }
}
