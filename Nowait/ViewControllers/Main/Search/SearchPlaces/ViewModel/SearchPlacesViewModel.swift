//
//  SearchPlacesViewModel.swift
//  Nowait
//
//  Created by Sergey Nazarov on 15.07.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchPlacesViewModel: SearchPlacesViewModelType {
    
    var searchText: String = ""
    var historySearch: BehaviorRelay<[HistorySearchModel]> = BehaviorRelay(value: [])
    var resultSearch: BehaviorRelay<ResultSearchModel?> = BehaviorRelay(value: nil)
    
    init() {
    }
    
    //MARK:- Request
    public func requestHistorySearch(callback: @escaping ((ResultResponce, ErrorResponce?)->())){
        SearchAPI.requstSearchAPI(type: HistorySearchData.self, request: .searchHistory) { [weak self] (value) in
            if value?.success == true{
                self?.historySearch.accept(value?.data ?? [])
                callback(.success, nil)
            }else{
                if value?.statusCode == 401{
                    AuthTokenNowait.shared.removeData()
                    callback(.fail, .unauthorized)
                }else{
                    if value?.statusCode != 6{ //отмена
                        callback(.fail, .unknow(title: "Ошибка", message: value?.message))
                    }else{
                        callback(.fail, nil)
                    }
                }
            }
        }
    }
    
    public func requestSearchAtText(callback: @escaping ((ResultResponce, ErrorResponce?)->())){
        SearchAPI.requstSearchAPI(type: ResultSearchData.self, request: .search(text: searchText)) { [weak self] (value) in
            if value?.success == true{
                self?.resultSearch.accept(value?.data)
                callback(.success, nil)
            }else{
                if value?.statusCode == 401{
                    AuthTokenNowait.shared.removeData()
                    callback(.fail, .unauthorized)
                }else{
                    if value?.statusCode != 6{ //отмена
                        callback(.fail, .unknow(title: "Ошибка", message: value?.message))
                    }else{
                        callback(.fail, nil)
                    }
                }
            }
        }
    }
    
    func section() -> Int {
        return 3
    }
    
    func numberOfRow(section: Int) -> Int {
        if section == 0{
            if let address = resultSearch.value?.address, address.count > 0{
                return 1
            }
            return 0
        }
        if section == 1{
            if let shop = resultSearch.value?.shop, shop.count > 0{
                return 1
            }
            return 0
        }
        
        if let dish = resultSearch.value?.dish, dish.count > 0 {
            return 1
        }
        return 0
    }
    
    func cellForRow(at indexPath: IndexPath) -> ResultSearchCellViewModelType {
        let logo: UIImage
        if indexPath.section == 0{
            logo = #imageLiteral(resourceName: "Location")
            return ResultSearchCellViewModel(logo: logo, title: resultSearch.value?.address?[indexPath.row])
        }else{
            if indexPath.section == 1{
                logo = #imageLiteral(resourceName: "condo.png")
                return ResultSearchCellViewModel(logo: logo, title: resultSearch.value?.shop?[indexPath.row])
            }else{
                logo = #imageLiteral(resourceName: "dish")
                return ResultSearchCellViewModel(logo: logo, title: resultSearch.value?.dish?[indexPath.row])
            }
        }
    }
    
    func didSelect(at indexPath: IndexPath) -> String{
        if indexPath.section == 0{
            return resultSearch.value!.address![indexPath.row]
        }else{
            if indexPath.section == 1{
                return resultSearch.value!.shop![indexPath.row]
            }else{
                return resultSearch.value!.dish![indexPath.row]
            }
        }
    }
}
