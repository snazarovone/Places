//
//  UserInfoData.swift
//  Nowait
//
//  Created by Sergey Nazarov on 02.06.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class UserInfoData{
    static var shared = UserInfoData()
    
    public var userInfo: BehaviorRelay<UserInfo?> = BehaviorRelay(value: nil)
    
    public func requestUserInfo(callback: @escaping ((ResultResponce, ErrorResponce?)->())){
        AuthAPI.requstAuthAPI(type: UserInfoModel.self, request: .userInfo) { [weak self] (value) in
            if value?.success ?? false{
                self?.userInfo.accept(value?.data)
                callback(.success, nil)
            }else{
               let error = (value?.error ?? "").getError(message: value?.message)

                switch error {
                case .unauthorized:
                    self?.userInfo.accept(nil)
                    AuthTokenNowait.shared.removeData()
                default:
                    break
                }
                
                callback(.fail, error)
            }
        }
    }
    
    func removeInfoUser(){
        userInfo.accept(nil)
    }
}
