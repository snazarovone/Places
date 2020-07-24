//
//  ShopViewModelType.swift
//  Nowait
//
//  Created by Sergey Nazarov on 21.07.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation

protocol ShopViewModelType {
    var placesModel: PlacesModel {get}
    var descriptionCafe: String? {get}
    var address: String? {get}
    var timeWork: ([String], [String]) {get}
    var pictures: [String] {get}
    var rating: String? {get}
    var name: String? {get}
    
    var phone: String? {get}
    var email: String? {get}
    var isContact: Bool {get}
    var isTimes: Bool {get}
    
    var isMore: Bool {get set}
}
