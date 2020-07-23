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
    
    var searchOffersNearest: BehaviorRelay<SearchOffers?> {get}
    var searchOffersBest: BehaviorRelay<SearchOffers?> {get}
    var locValue: CLLocationCoordinate2D? {get set}
    
    var headerNearest: String? {get}
    var headerBest: String? {get}
    
    func requestNearbyOffer(callback: @escaping ((ResultResponce, ErrorResponce?)->()))
    func requestPopular(callback: @escaping ((ResultResponce, ErrorResponce?)->()))
   
    func numberOfRowNearest(section: Int) -> Int
    func cellForRowNearest(at indexPath: IndexPath) -> SearchCellViewModelType
    
    func numberOfRowBest(section: Int) -> Int
    func cellForRowBest(at indexPath: IndexPath) -> SearchCellViewModelType
    
}
