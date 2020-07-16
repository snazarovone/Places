//
//  SearchViewModelType.swift
//  Nowait
//
//  Created by Sergey Nazarov on 14.07.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import MapKit

protocol SearchViewModelType {
    
    var searchOffers: BehaviorRelay<[SearchOffers]> {get}
    var locValue: CLLocationCoordinate2D? {get set}
    
    func requestNearbyOffer(callback: @escaping ((ResultResponce, ErrorResponce?)->()))
    func requestPopular(callback: @escaping ((ResultResponce, ErrorResponce?)->()))
   
    func numberSection() -> Int
    func numberOfRow(section: Int) -> Int
    func cellForRow(at indexPath: IndexPath) -> SearchCellViewModelType
    func header(at indexPath: IndexPath) -> String
}
