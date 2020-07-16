//
//  HistorySearchData.swift
//  Nowait
//
//  Created by Sergey Nazarov on 15.07.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation
import ObjectMapper

class HistorySearchData: BaseResponseModel{
    
    var data : [HistorySearchModel]?
    
    required init() {
        super.init()
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    required init(success: Bool?, message: String?, error: String?, statusCode: Int?) {
        super.init(success: success, message: message, error: error, statusCode: statusCode)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map["data"]
    }
}
