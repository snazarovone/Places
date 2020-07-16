//
//  TokenModel.swift
//  Nowait
//
//  Created by Sergey Nazarov on 20.05.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation
import ObjectMapper

class TokenModel: BaseResponseModel {
    
    var token: String?
    var token_type: String?
    
    init(token: String?, token_type: String?){
        super.init()
        self.token = token
        self.token_type = token_type
    }
 
    required init(success: Bool?, message: String?, error: String?, statusCode: Int?) {
        super.init(success: success, message: message, error: error, statusCode: statusCode)
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    required init() {
        super.init()
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        token <- map["token"]
        token_type <- map["token_type"]
    }
}
