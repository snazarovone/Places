//
//  SearchOffers.swift
//  Nowait
//
//  Created by Sergey Nazarov on 14.07.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation

class SearchOffers{
    
    let title: String
    let placesModel: [PlacesModel]
    
    init(placesModel: [PlacesModel], title: String){
        self.placesModel = placesModel
        self.title = title
    }
}
