//
//  Country.swift
//  Nowait
//
//  Created by Sergey Nazarov on 18.05.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation
import ObjectMapper

class Country: Mappable{
    
    var id: Int?
    var name: String?
    var mask: String?
    var code: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        mask <- map["mask"]
        code <- map["code"]
    }
    
}
