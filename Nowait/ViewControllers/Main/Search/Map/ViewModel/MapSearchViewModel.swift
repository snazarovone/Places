//
//  MapSearchViewModel.swift
//  Nowait
//
//  Created by Sergey Nazarov on 20.07.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import GoogleMaps

class MapSearchViewModel: MapSearchViewModelType{
    
    var resultSearch: BehaviorRelay<[PlacesModel]> = BehaviorRelay(value: [])
    var currentItem: IndexPath?
    var searchText: String?
    
    private var markers = [GMSMarker]()
    
    init(resultSearch: BehaviorRelay<[PlacesModel]>, searchText: String?){
        self.resultSearch = resultSearch
        self.searchText = searchText
    }
    
    func createMarkers() -> [GMSMarker]{
        markers = []
        for (i, item) in resultSearch.value.enumerated(){
            if let latStr = item.lat, let lat = CLLocationDegrees(latStr), let longStr = item.lng, let lng = CLLocationDegrees(longStr){
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                marker.userData = i
                markers.append(marker)
                currentItem = IndexPath(row: 0, section: 0)
            }
        }
        return markers
    }
    
    func getCameraMarker() -> GMSCameraPosition?{
        if currentItem?.row ?? 0 < resultSearch.value.count{
            let item = resultSearch.value[currentItem!.row]
            if let latStr = item.lat, let lat = CLLocationDegrees(latStr), let longStr = item.lng, let lng = CLLocationDegrees(longStr){
                return GMSCameraPosition(latitude: lat, longitude: lng, zoom: 17.0)
            }
        }
        return nil
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
