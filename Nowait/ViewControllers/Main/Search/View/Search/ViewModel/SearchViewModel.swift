//
//  SearchViewModel.swift
//  Nowait
//
//  Created by Sergey Nazarov on 14.07.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import MapKit

class SearchViewModel: SearchViewModelType{
    
    var searchOffers: BehaviorRelay<[SearchOffers]> = BehaviorRelay(value: [])
    var locValue: CLLocationCoordinate2D?
    
    //MARK:- Requests
    public func requestNearbyOffer(callback: @escaping ((ResultResponce, ErrorResponce?)->())){
        guard let latitude = locValue?.latitude, let longitude = locValue?.longitude  else {
            return
        }
        
        SearchAPI.requstSearchAPI(type: PlacesData.self, request: .nearby(lat: String(latitude), lng: String(longitude))) { [weak self] (value) in
            if value?.success == true{
                if let self = self{
                    var tempData = self.searchOffers.value
                    if tempData.count == 2{
                        tempData.remove(at: 0)
                    }
                    let searchOfferTepm = SearchOffers(placesModel: value?.data ?? [], title: "Места поблизости")
                    tempData.insert(searchOfferTepm, at: 0)
                    self.searchOffers.accept(tempData)
                }
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
    
    public func requestPopular(callback: @escaping ((ResultResponce, ErrorResponce?)->())){
        SearchAPI.requstSearchAPI(type: PlacesData.self, request: .popular) { [weak self] (value) in
            if value?.success == true{
                if let self = self{
                    var tempData = self.searchOffers.value
                    if tempData.count == 2{
                        tempData.remove(at: 1)
                    }
                    let searchOfferTepm = SearchOffers(placesModel: value?.data ?? [], title: "Лучшие предложения")
                    tempData.append(searchOfferTepm)
                    self.searchOffers.accept(tempData)
                }
                callback(.success, nil)
            }else{
                if value?.statusCode == 401{
                    AuthTokenNowait.shared.removeData()
                    callback(.fail, .unauthorized)
                }else{
                    if value?.statusCode != 6{
                        callback(.fail, .unknow(title: "Ошибка", message: value?.message))
                    }
                    else{
                        callback(.fail, nil)
                    }
                }
            }
        }
    }
    
    
    //MARK:- CollectionView
    func numberSection() -> Int {
        return searchOffers.value.count
    }
    
    func numberOfRow(section: Int) -> Int {
        return searchOffers.value[section].placesModel.count
    }
    
    func cellForRow(at indexPath: IndexPath) -> SearchCellViewModelType {
        let placesModel: PlacesModel
        placesModel = searchOffers.value[indexPath.section].placesModel[indexPath.row]
        return SearchCellViewModel(placesModel: placesModel)
    }
    
    func header(at indexPath: IndexPath) -> String {
        return searchOffers.value[indexPath.section].title
    }
}
