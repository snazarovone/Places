//
//  ResultSearchViewModel.swift
//  Nowait
//
//  Created by Sergey Nazarov on 16.07.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ResultSearchViewModel: ResultSearchViewModelType{
    
    var searchText: String?
    var resultSearch: BehaviorRelay<[PlacesModel]> = BehaviorRelay(value: [])
    let type: SearchType
    
    init(searchText: String?, type: SearchType){
        self.searchText = searchText
        self.type = type
    }
    
    func requestSearchFinish(callback: @escaping ((ResultResponce, ErrorResponce?)->())){
        
        guard let searchText = searchText else {return}
        
        SearchAPI.requstSearchAPI(type: PlacesData.self, request: .searchFinish(text: searchText, kitchens: nil, type: type)) { [weak self] (value) in
            
            self?.resultSearch.accept(value?.data ?? [])
            
            if value?.success == true{
                callback(.success, nil)
            }else{
                if value?.statusCode == 401{
                    AuthTokenNowait.shared.removeData()
                    callback(.fail, .unauthorized)
                }else{
                    if value?.statusCode != 6{
                        callback(.fail, .unknow(title: "Ошибка", message: value?.message))
                    }else{
                        callback(.fail, nil)
                    }
                }
            }
        }
    }
    
    //MARK:- TableView
    func numberOfRow() -> Int {
        return resultSearch.value.count
    }
    
    func cellForRow(at indexPath: IndexPath) -> RSearchCellViewModelType {
        return RSearchCellViewModel(placesModel: resultSearch.value[indexPath.row])
    }
    
    func didSelect(at indexPath: IndexPath) -> PlacesModel {
        return resultSearch.value[indexPath.row]
    }
}
