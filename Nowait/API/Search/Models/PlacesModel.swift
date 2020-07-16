//
//  PlacesModel.swift
//  Nowait
//
//  Created by Sergey Nazarov on 14.07.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation
import ObjectMapper

class PlacesModel: Mappable {
    var id : Int?
    var name : String?
    var logo : String?
    var description : String?
    var average_check : Int?
    var lat : String?
    var lng : String?
    var address : String?
    var mon_open : String?
    var mon_close : String?
    var tue_open : String?
    var tue_close : String?
    var wed_open : String?
    var wed_close : String?
    var thu_open : String?
    var thu_close : String?
    var fri_open : String?
    var fri_close : String?
    var sat_open : String?
    var sat_close : String?
    var sun_open : String?
    var sun_close : String?
    var phones : [String]?
    var email : String?
    var images : [String]?
    var rating : String?
    var popular : Bool?
    var kitchens : [KitchensModel]?
    var wishlist : Int?
    var distance : Double?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        logo <- map["logo"]
        description <- map["description"]
        average_check <- map["average_check"]
        lat <- map["lat"]
        lng <- map["lng"]
        address <- map["address"]
        mon_open <- map["mon_open"]
        mon_close <- map["mon_close"]
        tue_open <- map["tue_open"]
        tue_close <- map["tue_close"]
        wed_open <- map["wed_open"]
        wed_close <- map["wed_close"]
        thu_open <- map["thu_open"]
        thu_close <- map["thu_close"]
        fri_open <- map["fri_open"]
        fri_close <- map["fri_close"]
        sat_open <- map["sat_open"]
        sat_close <- map["sat_close"]
        sun_open <- map["sun_open"]
        sun_close <- map["sun_close"]
        phones <- map["phones"]
        email <- map["email"]
        images <- map["images"]
        rating <- map["rating"]
        popular <- map["popular"]
        kitchens <- map["kitchens"]
        wishlist <- map["wishlist"]
        distance <- map["distance"]
    }
}
