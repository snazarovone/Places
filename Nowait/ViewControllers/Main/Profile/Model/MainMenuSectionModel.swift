//
//  MainMenuSectionModel.swift
//  Nowait
//
//  Created by Sergey Nazarov on 19.05.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation

enum MainMenuSectionModel: CaseIterable{
    case settings
    case helpers
}

extension MainMenuSectionModel{
    var title: String{
        switch self {
        case .settings:
            return "Настройки аккаута"
        case .helpers:
            return "Поддержка"
        }
    }
    
    var cellFull: [MainMenuCell]{
        switch self {
        case .settings:
            return [.bankCard, .notification, .userInfo]
        case .helpers:
            return [.terms, .help, .logout]
        }
    }
    
    var cellNotAuth: [MainMenuCell]{
        switch self {
        case .settings:
            return [.notification]
        case .helpers:
            return [.terms, .help]
        }
    }
    
    
    
    var section: Int{
        switch self {
        case .settings:
            return 0
        case .helpers:
            return 1
        }
    }
}
