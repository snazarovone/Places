//
//  SearchCellViewModel.swift
//  Nowait
//
//  Created by Sergey Nazarov on 15.07.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation

class SearchCellViewModel: SearchCellViewModelType{
    var img: String?{
        return placesModel.logo
    }
    
    var title: String?{
        return placesModel.name
    }
    
    var type: String?{
        return placesModel.kitchens?.first?.title
    }
    
    var time: String?{
        return "Работает до \(placesModel.mon_close ?? "")"
    }
    
    var rating: String?{
        return placesModel.rating
    }
    
    let placesModel: PlacesModel
    
    init(placesModel: PlacesModel){
        self.placesModel = placesModel
    }
}
