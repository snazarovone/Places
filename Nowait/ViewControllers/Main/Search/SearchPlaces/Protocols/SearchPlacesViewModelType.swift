//
//  SearchPlacesViewModelType.swift
//  Nowait
//
//  Created by Sergey Nazarov on 15.07.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol SearchPlacesViewModelType: class {
    var searchText: String {get set}
    var historySearch: BehaviorRelay<[HistorySearchModel]> {get}
    var resultSearch: BehaviorRelay<ResultSearchModel?> {get}
    
    func requestHistorySearch(callback: @escaping ((ResultResponce, ErrorResponce?)->()))
    func requestSearchAtText(callback: @escaping ((ResultResponce, ErrorResponce?)->()))
    
    func section() -> Int
    func numberOfRow(section: Int) -> Int
    func cellForRow(at indexPath: IndexPath) -> ResultSearchCellViewModelType
    func didSelect(at indexPath: IndexPath) -> String
}
