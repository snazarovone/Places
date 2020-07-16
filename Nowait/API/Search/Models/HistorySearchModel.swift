//
//  HistorySearchModel.swift
//  Nowait
//
//  Created by Sergey Nazarov on 15.07.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation
import ObjectMapper

class HistorySearchModel: Mappable{
    
    var id : Int?
    var text : String?
    var user_id : Int?
    var date : String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        text <- map["text"]
        user_id <- map["user_id"]
        date <- map["date"]
    }
}
