//
//  CountryCellViewModel.swift
//  Nowait
//
//  Created by Sergey Nazarov on 18.05.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation

class CountryCellViewModel: CountryCellViewModelType{
    var titleCountry: String?{
        return country.name
    }
    
    let country: Country
    
    init(country: Country){
        self.country = country
    }
}
