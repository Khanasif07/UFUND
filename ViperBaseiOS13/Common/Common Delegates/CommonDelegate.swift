//
//  CommonDelegate.swift
//  Project
//
//  Created by Deepika on 23/08/19.
//  Copyright © 2019 css. All rights reserved.
//

import Foundation
protocol countryDelegate {
    
    func didReceiveUserCountryDetails (countryDetails: Country?)
}

//Store date to default
class CommonUserDefaults {
    
    class func storeUserData(from profile : SignInModel?) {
        User.main.name = profile?.name
        User.main.email = profile?.email
        User.main.accessToken = profile?.access_token
        User.main.g2f_temp = profile?.g2f_status
        User.main.pin_status = profile?.app_pin_status
        User.main.kyc = profile?.kyc
        User.main.picture = profile?.picture
    }
}

struct UserDefaultsKey {
    
    static let key = UserDefaultsKey()
    let isFromInvestor = "isFromInvestor"
    let filterCategories = "filterCategories"
    let minValue = "minValue"
    let maxValue = "maxValue"
    
}


