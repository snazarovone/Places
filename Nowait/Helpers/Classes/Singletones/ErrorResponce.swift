//
//  ErrorResponce.swift
//  Nowait
//
//  Created by Sergey Nazarov on 02.06.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation

enum ErrorResponce{
    case unauthorized
    case unknow(title: String?, message: String?)
}

extension ErrorResponce: CaseIterable{
    static var allCases: [ErrorResponce] {
        return [.unauthorized, .unknow(title: nil, message: nil)]
    }
    
    typealias AllCases = [ErrorResponce]
    
    var value: String{
        switch self {
        case .unauthorized:
            return "Unauthorized"
        case .unknow(_, _):
            return "unknow"
        }
    }
}
