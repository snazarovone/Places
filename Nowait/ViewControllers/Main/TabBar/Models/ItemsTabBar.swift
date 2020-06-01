//
//  ItemsTabBar.swift
//  Nowait
//
//  Created by Sergey Nazarov on 30.05.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation

enum ItemsTabBar {
    case search
    case orders
    case qrCode
    case favorites
    case profile
}

extension ItemsTabBar{
    var index: Int{
        switch self {
        case .search:
            return 0
        case .orders:
            return 1
        case .qrCode:
            return 2
        case .favorites:
            return 3
        case .profile:
            return 4
        }
    }
}
