//
//  EditFields.swift
//  Nowait
//
//  Created by Sergey Nazarov on 01.06.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation

enum EditFields: CaseIterable{
    case name
    case lastName
    case birthday
    case phone
    case email
}

extension EditFields{
    var tag: Int{
        switch self {
        case .name:
            return 0
        case .lastName:
            return 1
        case .birthday:
            return 2
        case .phone:
            return 3
        case .email:
            return 4
        }
    }
}
