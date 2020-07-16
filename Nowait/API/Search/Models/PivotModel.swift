//
//  PivotModel.swift
//  Nowait
//
//  Created by Sergey Nazarov on 14.07.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation
import ObjectMapper

class PivotModel: Mappable{
    
    var shop_id : Int?
    var kitchen_id : Int?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        shop_id <- map["shop_id"]
        kitchen_id <- map["kitchen_id"]
    }
    
}
