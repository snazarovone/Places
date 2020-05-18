//
//  SelectCountryViewModelType.swift
//  Nowait
//
//  Created by Sergey Nazarov on 18.05.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol SelectCountryViewModelType {
    func numberOfRow() -> Int
    func cellForRow(at indexPath: IndexPath) -> CountryCellViewModelType
    func didSelect(at indexPath: IndexPath)
    
    func searchField(at text: String)
    var searchCountry: BehaviorRelay<[Country]> {get}
}
