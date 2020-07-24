//
//  ShopViewModel.swift
//  Nowait
//
//  Created by Sergey Nazarov on 21.07.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation

class ShopViewModel: ShopViewModelType{
    
    var placesModel: PlacesModel
    
    var descriptionCafe: String?{
        return placesModel.description
    }
    
    var address: String?{
        return placesModel.address
    }
    
    var timeWork: ([String], [String]){
        return times()
    }
    
    var phone: String?{
        return placesModel.phones?.first
    }
    
    var email: String?{
        return placesModel.email
    }
    
    var pictures: [String]{
        return placesModel.images ?? []
    }
    
    var rating: String?{
        return placesModel.rating
    }
    
    var name: String?{
        return placesModel.name
    }
    
    var isContact: Bool{
        if phone != nil && email != nil{
            return true
        }
        return false
    }
    
    var isTimes: Bool{
        for (i, time) in tm.0.enumerated(){
            if time.isEmpty == false && tm.1[i].isEmpty == false{
                return true
            }
        }
        return false
    }
    
    var isMore: Bool = false
    
    private var tm = ([String](), [String]())
    
    init(placesModel: PlacesModel){
        self.placesModel = placesModel
        self.tm = self.times()
    }
    
    private func times() -> ([String], [String]){
        var timeOpen = ["", "", "", "", "", "", ""]
        var timeClose = ["", "", "", "", "", "", ""]
        
        timeOpen[0] = placesModel.mon_open ?? ""
        timeClose[0] = placesModel.mon_close ?? ""
        
        timeOpen[1] = placesModel.tue_open ?? ""
        timeClose[1] = placesModel.tue_close ?? ""
        
        timeOpen[2] = placesModel.wed_open ?? ""
        timeClose[2] = placesModel.wed_close ?? ""
        
        timeOpen[3] = placesModel.thu_open ?? ""
        timeClose[3] = placesModel.thu_close ?? ""
        
        timeOpen[4] = placesModel.fri_open ?? ""
        timeClose[4] = placesModel.fri_close ?? ""
        
        timeOpen[5] = placesModel.sat_open ?? ""
        timeClose[5] = placesModel.sat_close ?? ""
        
        timeOpen[6] = placesModel.sun_open ?? ""
        timeClose[6] = placesModel.sun_close ?? ""
        return (timeOpen, timeClose)
    }
}

