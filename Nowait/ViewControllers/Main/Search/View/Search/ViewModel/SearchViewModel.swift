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

    var searchOffersNearest: BehaviorRelay<SearchOffers?> = BehaviorRelay(value: nil)
    var searchOffersBest: BehaviorRelay<SearchOffers?> = BehaviorRelay(value: nil)
    var locValue: CLLocationCoordinate2D?
    
    //MARK:- Requests
    public func requestNearbyOffer(callback: @escaping ((ResultResponce, ErrorResponce?)->())){
        guard let latitude = locValue?.latitude, let longitude = locValue?.longitude  else {
            return
        }
        
        SearchAPI.requstSearchAPI(type: PlacesData.self, request: .nearby(lat: String(latitude), lng: String(longitude))) { [weak self] (value) in
            if value?.success == true{
                let searchOfferTepm = SearchOffers(placesModel: value?.data ?? [], title: "Места поблизости")
                self?.searchOffersNearest.accept(searchOfferTepm)
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
                let searchOfferTepm = SearchOffers(placesModel: value?.data ?? [], title: "Лучшие предложения")
                self?.searchOffersBest.accept(searchOfferTepm)
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
    
    var headerNearest: String?{
        return searchOffersNearest.value?.title
    }
       
    var headerBest: String?{
        return searchOffersBest.value?.title
    }
    
    func numberOfRowNearest(section: Int) -> Int {
        return searchOffersNearest.value?.placesModel.count ?? 0
    }
    
    func cellForRowNearest(at indexPath: IndexPath) -> SearchCellViewModelType {
        let placesModel: PlacesModel
        placesModel = searchOffersNearest.value!.placesModel[indexPath.row]
        return SearchCellViewModel(placesModel: placesModel)
    }
    
    func numberOfRowBest(section: Int) -> Int {
        return searchOffersBest.value?.placesModel.count ?? 0
    }
    
    func cellForRowBest(at indexPath: IndexPath) -> SearchCellViewModelType {
        let placesModel: PlacesModel
        placesModel = searchOffersBest.value!.placesModel[indexPath.row]
        return SearchCellViewModel(placesModel: placesModel)
    }
}
