//
//  BaseResponseModel.swift
//  Nowait
//
//  Created by Sergey Nazarov on 20.05.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation
import ObjectMapper

class BaseResponseModel: Mappable{
    
    var success: Bool?
    var message: String?
    var error: String?
    var statusCode: Int?
    
    required init() {
    }
   
    required init(success: Bool?, message: String?, error: String?, statusCode: Int?) {
        self.success = success
        self.message = message
        self.error = error
        self.statusCode = statusCode
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        success <- map["success"]
        message <- map["message"]
        error <- map["error"]
    }
    
}
