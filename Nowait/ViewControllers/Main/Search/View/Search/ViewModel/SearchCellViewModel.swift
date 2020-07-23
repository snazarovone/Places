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
        guard let weekDay = getDayOfWeek() else {
            return nil
        }
        
        let t = times()
        
        if weekDay < t.count && t[weekDay].isEmpty == false{
            return "Работает до \(t[weekDay])"
        }else{
            return nil
        }
    }
    
    var rating: String?{
        return placesModel.rating
    }
    
    let placesModel: PlacesModel
    
    init(placesModel: PlacesModel){
        self.placesModel = placesModel
    }
    
    private func getDayOfWeek() -> Int? {
        let myCalendar = Calendar.current
        let myComponents = myCalendar.dateComponents([.weekday], from: Date())
        let weekDay = myComponents.weekday
        return weekDay
    }
    
    private func times() -> [String]{
           var timeClose = ["", "", "", "", "", "", ""]
           
           timeClose[0] = placesModel.mon_close ?? ""
           
           timeClose[1] = placesModel.tue_close ?? ""
           
           timeClose[2] = placesModel.wed_close ?? ""
           
           timeClose[3] = placesModel.thu_close ?? ""
           
           timeClose[4] = placesModel.fri_close ?? ""
           
           timeClose[5] = placesModel.sat_close ?? ""
           
           timeClose[6] = placesModel.sun_close ?? ""
           return timeClose
       }
}
