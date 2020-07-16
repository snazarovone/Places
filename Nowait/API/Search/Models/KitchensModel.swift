//
//  KitchensModel.swift
//  Nowait
//
//  Created by Sergey Nazarov on 14.07.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation
import ObjectMapper

class KitchensModel: Mappable {
    
    var id : Int?
    var title : String?
    var pivot : PivotModel?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        pivot <- map["pivot"]
    }
}
