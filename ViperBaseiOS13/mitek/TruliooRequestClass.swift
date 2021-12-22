//
//  TruliooRequestClass.swift
//  ViperBaseiOS13
//
//  Created by Admin on 16/08/21.
//  Copyright © 2021 CSS. All rights reserved.
//

import Foundation
import Foundation
import UIKit

public struct PiiInfo{
    public let firstName:String
    public let lastName:String
    public let dayOfBirth:String
    public let monthOfBirth:String
    public let yearOfBirth:String
    public let countryCode:String
    public let documentType:String
    
    public let frontImage:UIImage
    public let backImage:UIImage?
    public let liveImage:UIImage?
    
    public let frontMetaData:String?
    public let backMetaData:String?
    public let liveMetaData:String?
    
    public let city:String?
    public let country:String?
    public let suburb : String?
    public let county: String?
    public let stateProvinceCode:String?
    public let postalCode:String?

    public let buildingNumber:String?
    public let buildingName:String?
    public let unitNumber:String?
    public let streetName:String?
    public let streetType:String?
    public let poBox:String?
    public let address:String?
    public let nationalID:String?
}

class DocumentVerificationRequest: Codable{
    var AcceptTruliooTermsAndConditions: Bool = true
    var ConfigurationName:String = "Identity Verification"
    var CountryCode:String
    var DataFields:DataFields
    var Timeout:Int
    //
   // var CallBackUrl:String = "https://api.globaldatacompany.com/connection/v1/async-callback"
//    var CallBackUrl:String = "https://ufunddevonline.appskeeper.in/trulioo_kyc_response/\(User.main.id ?? 0)"
    var CallBackUrl:String = "\(baseUrl)/trulioo_kyc_response/\(User.main.id ?? 0)"
//    var CallBackUrl:String = "https://webhook.site/23babe19-557f-4c74-8cc3-490de850eac0"
    //
    init(countryCode:String, dataFields:DataFields){
        self.CountryCode = countryCode
        self.DataFields = dataFields
        self.Timeout = 120
    }
}

class DataFields: Codable{
    var PersonInfo: PersonInfo
    var Document: Document
    var Location : Location
    var NationalIds : [NationalIds]
    
    init(personInfo: PersonInfo, documentInfo: Document,locationInfo: Location,nationalIdInfo:[NationalIds]){
        self.PersonInfo = personInfo
        self.Document = documentInfo
        self.Location = locationInfo
        self.NationalIds = nationalIdInfo
    }
}

class PersonInfo: Codable{
    var FirstGivenName:String?
    var FirstSurName:String?
    var DayOfBirth: String?
    var MonthOfBirth: String?
    var YearOfBirth: String?
    //
    
    init(piiInfo:PiiInfo){
        self.FirstGivenName = piiInfo.firstName
        self.FirstSurName = piiInfo.lastName
        self.DayOfBirth = piiInfo.dayOfBirth
        self.MonthOfBirth = piiInfo.monthOfBirth
        self.YearOfBirth = piiInfo.yearOfBirth
    }
}

class Document: Codable{
    var DocumentFrontImage:String?
    var DocumentBackImage:String?
    var LivePhoto:String?
    var DocumentType:String?
    
    init(frontImage:String, backImage:String?, livePhoto:String?, documentType:String){
        self.DocumentType = documentType
        self.DocumentFrontImage = frontImage
        if(backImage != nil){
            self.DocumentBackImage = backImage
        }
        if(livePhoto != nil){
            self.LivePhoto = livePhoto
        }
    }
}

class Location: Codable{
    var City:String?
    var Country: String?
    var StateProvinceCode:String?
    var PostalCode: String?
    var BuildingNumber : String?
    var BuildingName : String?
    var UnitNumber : String?
    var StreetName : String?
    var StreetType : String?
    var Suburb : String?
    var County: String?
    var POBox : String?
    var AdditionalFields: AdditionalFields
   
    init(piiInfo:PiiInfo,additionalFields: AdditionalFields){
        self.City = piiInfo.city
        self.StateProvinceCode = piiInfo.stateProvinceCode
        self.PostalCode = piiInfo.postalCode
        self.BuildingName =  piiInfo.buildingName
        self.BuildingNumber =  piiInfo.buildingNumber
        self.StreetName =  piiInfo.streetName
        self.StreetType =  piiInfo.streetType
        self.Country =  piiInfo.country
        self.County =  piiInfo.county
        self.Suburb = piiInfo.suburb
        self.POBox = piiInfo.poBox
        self.AdditionalFields = additionalFields
    }
}

class AdditionalFields: Codable{
    var Address1:String?
   
    init(piiInfo:PiiInfo){
        self.Address1 = piiInfo.address
    }
}
class NationalIds: Codable {
    var Number:String?
   
    init(piiInfo:PiiInfo){
        self.Number = piiInfo.nationalID
    }
}
