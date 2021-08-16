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
    public let countryCode:String
    public let documentType:String
    
    public let frontImage:UIImage
    public let backImage:UIImage?
    public let liveImage:UIImage?
    
    public let frontMetaData:String?
    public let backMetaData:String?
    public let liveMetaData:String?
}

class DocumentVerificationRequest: Codable{
    var AcceptTruliooTermsAndConditions: Bool = true
    var ConfigurationName:String = "Identity Verification"
    var CountryCode:String
    var DataFields:DataFields
    var Timeout:Int
    
    init(countryCode:String, dataFields:DataFields){
        self.CountryCode = countryCode
        self.DataFields = dataFields
        self.Timeout = 120
    }
}

class DataFields: Codable{
    var PersonInfo: PersonInfo
    var Document: Document
    
    init(personInfo: PersonInfo, documentInfo: Document){
        self.PersonInfo = personInfo
        self.Document = documentInfo
    }
}

class PersonInfo: Codable{
    var FirstGivenName:String?
    var FirstSurName:String?
    
    init(piiInfo:PiiInfo){
        self.FirstGivenName = piiInfo.firstName
        self.FirstSurName = piiInfo.lastName
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
