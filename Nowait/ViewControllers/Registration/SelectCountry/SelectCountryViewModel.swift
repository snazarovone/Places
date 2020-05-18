//
//  SelectCountryViewModel.swift
//  Nowait
//
//  Created by Sergey Nazarov on 18.05.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SelectCountryViewModel: SelectCountryViewModelType{

    private var country: BehaviorRelay<[Country]> = BehaviorRelay(value: [])
    private var selectCountry: BehaviorRelay<Country?> = BehaviorRelay(value: nil)
    var searchCountry: BehaviorRelay<[Country]> = BehaviorRelay(value: [])
    
    init(country: BehaviorRelay<[Country]>, selectCountry: BehaviorRelay<Country?>){
        self.country = country
        self.selectCountry = selectCountry
        self.searchCountry.accept(country.value)
    }
    
    func numberOfRow() -> Int {
        return searchCountry.value.count
    }
    
    func cellForRow(at indexPath: IndexPath) -> CountryCellViewModelType {
        return CountryCellViewModel(country: searchCountry.value[indexPath.row])
    }
    
    func didSelect(at indexPath: IndexPath) {
        selectCountry.accept(searchCountry.value[indexPath.row])
    }
    
    func searchField(at text: String){
        
        guard text.isEmpty == false else {
            return self.searchCountry.accept(country.value)
        }
        
        DispatchQueue.main.async {
            let newSearchCountry = self.country.value.filter { (s) -> Bool in
                if let name = s.name, name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased().contains(text.lowercased()){
                    return true
                }
                return false
            }
            
            self.searchCountry.accept(newSearchCountry)
        }
    }
}
