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
                if value?.statusCode == 401{
                    AuthTokenNowait.shared.removeData()
                    callback(.fail, .unauthorized)
                }else{
                    callback(.fail, .unknow(title: "Ошибка", message: value?.message))
                }
            }
        }
    }
    
    func removeInfoUser(){
        userInfo.accept(nil)
    }
}
