//
//  AuthToken.swift
//  Nowait
//
//  Created by Sergey Nazarov on 18.05.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation

enum AuthToken {
    case apple(code: String, name: String)
}
