//
//  RSearchCellViewModelType.swift
//  Nowait
//
//  Created by Sergey Nazarov on 16.07.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation

protocol RSearchCellViewModelType: class {
    var picture: String? {get}
    var rating: String? {get}
    var name: String? {get}
    var time: String? {get}
    var address: String? {get}
    var price: String? {get}
}
