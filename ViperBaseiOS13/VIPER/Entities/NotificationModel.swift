//
//  NotificationModel.swift
//  ViperBaseiOS13
//
//  Created by Deepika on 10/02/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit
import ObjectMapper

struct NotificationList: Mappable {
   
    var title : String?
    var description : String?
    var time_stamp : String?
    var id : Int?
    var created_at : String?
    var updated_at : String?
    
        init?(map: Map)
        {
               
        }
       
       mutating func mapping(map: Map)
       {
           
        title <- map["title"]
        description <-  map["description"]
        time_stamp <- map["time_stamp"]
        id <- map["id"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        
        
        
        
       }
 

}


struct NotificationModel : Mappable {
    
    var notifications : [NotificationList]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        notifications <- map ["notifications"]
        
    }
    
    
}



struct Categories : Mappable {
    var id : Int?
    var category_name : String?
    var type : String?
    var image : String?
    var created_at : String?
    var updated_at : String?
    var deleted_at : String?

    init?(map: Map) {

    }
    
    init(){
        
    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        category_name <- map["category_name"]
        type <- map["type"]
        image <- map["image"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        deleted_at <- map["deleted_at"]
    }

}



struct FilterDataEntity : Mappable {
    
    var categories : [Categories]?
    var range_min : Double?
    var range_max : Double?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        categories <- map["categories"]
        range_min <- map["range_min"]
        range_max <- map["range_max"]
    }

}

struct AssetTokenTypeEntity : Mappable {
    var data : [AssetTokenTypeModel]?
    var message: String?
    var code : Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        data <- map["data"]
        message <- map["message"]
        code <- map["code"]
    }

}

struct AssetTokenTypeModel : Mappable {
    var id : Int?
    var type : String?
    var created_at : String?
    var updated_at : String?
    var name : String?
    var isSelected: Bool = false
    
    init?(map: Map) {

    }
    
    init(){
        
    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        type <- map["type"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        name <- map["name"]
    }
}
