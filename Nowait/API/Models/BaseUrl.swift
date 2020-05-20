//
//  BaseUrl.swift
//  Nowait
//
//  Created by Sergey Nazarov on 20.05.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation

enum BaseUrl {
    case url
}

extension BaseUrl{
    var value: URL{
        switch self {
        case .url:
            return URL(string: "http://msofter.com/nowait/api")!
        }
    }
    
    var valueStr: String{
        switch self {
        case .url:
            return "http://msofter.com/nowait/api"
        }
    }
}
