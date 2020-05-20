//
//  AuthTokenNowaitType.swift
//  Nowait
//
//  Created by Sergey Nazarov on 20.05.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol AuthTokenNowaitType {
    var tokenModel: BehaviorRelay<TokenModel?> {get}
    
    func setData(token: TokenModel)
    func removeData()
}
