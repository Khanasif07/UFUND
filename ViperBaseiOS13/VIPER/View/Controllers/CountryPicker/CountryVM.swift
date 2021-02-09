//
//  CountryVM.swift
//  ArabianTyres
//
//  Created by Admin on 07/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

protocol CountryDelegate{
    func sendCountryCode(code: String)
}


class CountryVM{
    enum CountryKeys: String{
       case name = "countryName"
        case code = "phoneCode"
    }
    
    var filteredCountry:[[String:String]] = []
    var searchCountry: String = ""
   

    var searchedCountry:[[String:String]] {
        if searchCountry.isEmpty{
            return filteredCountry
        }
        return filteredCountry.filter { ($0[CountryVM.CountryKeys.name.rawValue]?.localizedCaseInsensitiveContains(searchCountry) ?? false)}
    }
    
    func getCountyData() {
        filteredCountry = countryData.sorted(by: { (country1, country2) -> Bool in
            if let name1 = country1[CountryKeys.name.rawValue],
                let name2 = country2[CountryKeys.name.rawValue] {
                return name1 < name2
            }else{
                return true
            }
        })
    }
    
    func getCountriesArr() -> [String]{
        getCountyData()
        var countryNameArr: [String] = ["All Country"]
        for dict in filteredCountry {
            countryNameArr.append(dict[CountryKeys.name.rawValue] ?? "")
        }
        return countryNameArr
    }
}

