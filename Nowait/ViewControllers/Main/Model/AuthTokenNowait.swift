//
//  AuthTokenNowait.swift
//  Nowait
//
//  Created by Sergey Nazarov on 20.05.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class AuthTokenNowait: AuthTokenNowaitType{
    
    static var shared = AuthTokenNowait()
    
    var tokenModel: BehaviorRelay<TokenModel?> = BehaviorRelay(value: nil)
    
    init(){
        getData()
    }
    
    private func getData(){
        let token = UserDefaults.standard.value(forKey: UDID.token.id) as? String
        let tokenType = UserDefaults.standard.value(forKey: UDID.token_type.id) as? String
        let model = TokenModel(token: token, token_type: tokenType)
        tokenModel.accept(model)
    }
    
    public func setData(token: TokenModel){
        UserDefaults.standard.set(token.token, forKey: UDID.token.id)
        UserDefaults.standard.set(token.token_type, forKey: UDID.token_type.id)
        getData()
    }
    
    
    public func removeData(){
        UserDefaults.standard.removeObject(forKey: UDID.token.id)
        UserDefaults.standard.removeObject(forKey: UDID.token_type.id)
        getData()
    }
}
