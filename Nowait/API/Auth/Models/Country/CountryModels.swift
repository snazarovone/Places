//
//  CountryModels.swift
//  Nowait
//
//  Created by Sergey Nazarov on 20.05.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation
import ObjectMapper

class CountryModels: BaseResponseModel{
    
    var data: [Country]?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    required init(success: Bool?, message: String?, error: String?, statusCode: Int?) {
        super.init(success: success, message: message, error: error, statusCode: statusCode)
    }
    
    required init() {
        super.init()
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map["data"]
    }
}
