//
//  ResultSearchModel.swift
//  Nowait
//
//  Created by Sergey Nazarov on 15.07.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation
import ObjectMapper

class ResultSearchModel: Mappable{
    
    var shop: [String]?
    var address: [String]?
    var dish: [String]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        shop <- map["name"]
        address <- map["address"]
        dish <- map["dish"]
    }

}
