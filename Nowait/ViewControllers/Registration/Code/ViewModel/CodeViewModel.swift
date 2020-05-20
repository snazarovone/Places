//
//  CodeViewModel.swift
//  Nowait
//
//  Created by Sergey Nazarov on 18.05.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation

class CodeViewModel: CodeViewModelType{
    
    public let phoneNumber: String
    public let succsessCode = "1234"
    public var codeTF: String = ""
    
    private let fullPhoneNumber: String
    private let authTokenNowait = AuthTokenNowait.shared
    
    init(phoneNumber: String, fullPhoneNumber: String){
        self.phoneNumber = phoneNumber
        self.fullPhoneNumber = fullPhoneNumber
    }
    
    public func requestCheckLogin(callBack: @escaping ((ResultResponce, TokenModel?)->())){
        AuthAPI.requstAuthAPI(type: TokenModel.self, request: .checkLogin(phone: fullPhoneNumber, verification_code: codeTF)) { [weak self] (value) in
            if let token = value, token.success ?? false{
                self?.authTokenNowait.setData(token: token)
                callBack(.success, nil)
            }else{
                callBack(.fail, value)
            }
        }
    }
}
