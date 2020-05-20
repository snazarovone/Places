//
//  MainViewModel.swift
//  Nowait
//
//  Created by Sergey Nazarov on 18.05.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MainViewModel: MainViewModelType{
    
    public var country: BehaviorRelay<[Country]> = BehaviorRelay(value: [])
    public var userInfo: BehaviorRelay<UserInfo?> = BehaviorRelay(value: nil)
    
    public let authTokenNowait = AuthTokenNowait.shared
    
    init(){
    }
    
    public func checkExistValidToken() -> Bool{
        if authTokenNowait.tokenModel.value?.token != nil && authTokenNowait.tokenModel.value?.token_type != nil{
            return true
        }else{
            return false
        }
    }
    
    public func requestLogOut(callback: @escaping ((ResultResponce, BaseResponseModel?)->())){
        AuthAPI.requstAuthAPI(type: BaseResponseModel.self, request: .logout) { (value) in
            if value?.success ?? false{
                callback(.success, nil)
            }else{
                callback(.fail, value)
            }
        }
    }
    
    public func requestUserInfo(callback: @escaping ((ResultResponce, UserInfoModel?)->())){
        AuthAPI.requstAuthAPI(type: UserInfoModel.self, request: .userInfo) { [weak self] (value) in
            if value?.success ?? false{
                self?.userInfo.accept(value?.data)
                callback(.success, nil)
            }else{
                callback(.fail, value)
            }
        }
    }
    
    func removeInfoUser(){
        userInfo.accept(nil)
    }
}
