//
//  ContactCellViewModelType.swift
//  Nowait
//
//  Created by Sergey Nazarov on 22.07.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation

protocol ContactCellViewModelType: class {
    var phone: String? {get}
    var isHidePhone: Bool {get}
    
    var email: String? {get}
    var isHideEmail: Bool {get}
}
