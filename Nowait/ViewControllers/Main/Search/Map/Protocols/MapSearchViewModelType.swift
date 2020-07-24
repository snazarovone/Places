//
//  MapSearchViewModelType.swift
//  Nowait
//
//  Created by Sergey Nazarov on 20.07.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import GoogleMaps

protocol MapSearchViewModelType {
    var resultSearch: BehaviorRelay<[PlacesModel]> {get}
    var currentItem: IndexPath? {get set}
    var searchText: String? {get}
    
    func createMarkers() -> [GMSMarker]
    func getCameraMarker() -> GMSCameraPosition?
    
    func numberOfRow() -> Int
    func cellForRow(at indexPath: IndexPath) -> RSearchCellViewModelType
    func didSelect(at indexPath: IndexPath) -> PlacesModel
}
