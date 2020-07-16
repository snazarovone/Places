//
//  SearchCellViewModelType.swift
//  Nowait
//
//  Created by Sergey Nazarov on 15.07.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation

protocol SearchCellViewModelType: class {
    var img: String? {get}
    var title: String? {get}
    var type: String? {get}
    var time: String? {get}
    var rating: String? {get}
}
