//
//  RSearchCellViewModel.swift
//  Nowait
//
//  Created by Sergey Nazarov on 16.07.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation

class RSearchCellViewModel: RSearchCellViewModelType{
    var picture: String?{
        return placesModel.logo
    }
    
    var rating: String?{
        return placesModel.rating
    }
    
    var name: String?{
        return placesModel.name
    }
    
    var time: String?{
        if let open = placesModel.mon_open{
            if let close = placesModel.mon_close{
                return "\(open) - \(close)"
            }else{
                return "\(open)"
            }
        }
        return nil
    }
    
    var address: String?{
        return placesModel.address
    }
    
    var price: String?{
        if let average_check = placesModel.average_check{
            return "\(average_check) ₽ средний чек"
        }
        return ""
    }
    
    let placesModel: PlacesModel
    
    init(placesModel: PlacesModel){
        self.placesModel = placesModel
    }
}
