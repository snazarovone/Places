//
//  SearchType.swift
//  Nowait
//
//  Created by Sergey Nazarov on 20.07.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation

enum SearchType {
    case shop
    case address
    case dish
}

extension SearchType{
    var type: String{
        switch self {
        case .shop:
            return "shop"
        case .address:
            return "address"
        case .dish:
            return "dish"
        }
    }
}
