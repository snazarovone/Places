//
//  MainViewModelType.swift
//  Nowait
//
//  Created by Sergey Nazarov on 18.05.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol MainViewModelType {
    
    var country: BehaviorRelay<[Country]> {get}
    var userInfo: BehaviorRelay<UserInfo?> {get}
    
    func checkExistValidToken() -> Bool
    
    func requestLogOut(callback: @escaping ((ResultResponce, BaseResponseModel?)->()))
}
