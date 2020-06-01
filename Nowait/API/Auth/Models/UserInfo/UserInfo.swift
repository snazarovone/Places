//
//  UserInfo.swift
//  Nowait
//
//  Created by Sergey Nazarov on 20.05.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation
import ObjectMapper

struct UserInfo : Mappable {
    var id : Int?
    var name : String?
    var last_name : String?
    var image : String?
    var email : String?
    var phone : String?
    var email_verified_at : String?
    var created_at : String?
    var updated_at : String?
    var birth_date: String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        name <- map["name"]
        last_name <- map["last_name"]
        image <- map["image"]
        email <- map["email"]
        phone <- map["phone"]
        email_verified_at <- map["email_verified_at"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        birth_date <- map["birth_date"]
    }

}
