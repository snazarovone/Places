//
//  UDID.swift
//  Nowait
//
//  Created by Sergey Nazarov on 20.05.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation

enum UDID{
    case token
    case token_type
}

extension UDID{
    var id: String{
        switch self {
        case .token:
            return "token"
        case .token_type:
            return "token_type"
        }
    }
}
