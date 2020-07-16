//
//  ResultSearchViewModelType.swift
//  Nowait
//
//  Created by Sergey Nazarov on 16.07.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ResultSearchViewModelType {
    
    var searchText: String? {get}
    var resultSearch: BehaviorRelay<[PlacesModel]> {get}
    
    func requestSearchFinish(callback: @escaping ((ResultResponce, ErrorResponce?)->()))
    
    func numberOfRow() -> Int
    func cellForRow(at indexPath: IndexPath) -> RSearchCellViewModelType
}
