//
//  ListCountry.swift
//  Nowait
//
//  Created by Sergey Nazarov on 01.06.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ListCountryType {
    var country: BehaviorRelay<[Country]> {get}
}

class ListCountry: ListCountryType{
    static var shared = ListCountry()
    var country: BehaviorRelay<[Country]> = BehaviorRelay(value: [])
    
    init(){
        requestListCountry()
    }
    
    private func requestListCountry(){
        AuthAPI.requstAuthAPI(type: CountryModels.self, request: .listCountry) { [weak self] (value) in
            if value?.success == true {
                self?.country.accept(value?.data ?? [])
            }
        }
    }
}
