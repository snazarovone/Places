//
//  MainViewModel.swift
//  Nowait
//
//  Created by Sergey Nazarov on 18.05.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MainViewModel: MainViewModelType{
    
    public var country: BehaviorRelay<[Country]> = BehaviorRelay(value: [])
    
    init(){
        initCountry()
    }
    
    private func initCountry(){
        let counryInit: [Country] = [Country(name: "Украина (+380)", mask: "XXX XXX XX XX", code: "+380"),
                                     Country(name: "Россия (+7)", mask: "XXX-XX-XX", code: "+7")
        ]
        
        country.accept(counryInit)
    }
}
