//
//  MainMenuCell.swift
//  Nowait
//
//  Created by Sergey Nazarov on 20.05.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation

enum MainMenuCell: CaseIterable {
    case bankCard
    case notification
    case userInfo
    case terms
    case help
    case logout
}

extension MainMenuCell{
    var id: String{
        switch self {
        case .bankCard:
            return "BankCell"
        case .notification:
            return "cellNotification"
        case .userInfo:
            return "userInfoCell"
        case .terms:
            return "termsCellId"
        case .help:
            return "helpCellId"
        case .logout:
            return "logoutCellId"
        }
    }
    
    var indexPath: IndexPath{
        switch self {
        case .bankCard:
            return IndexPath(row: 0, section: 0)
        case .notification:
            return IndexPath(row: 1, section: 0)
        case .userInfo:
            return IndexPath(row: 2, section: 0)
        case .terms:
            return IndexPath(row: 0, section: 1)
        case .help:
            return IndexPath(row: 1, section: 1)
        case .logout:
            return IndexPath(row: 2, section: 1)
        }
    }
    
}
