//
//  AuthServerAPI.swift
//  Nowait
//
//  Created by Sergey Nazarov on 20.05.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation
import Moya
import Alamofire

enum AuthServerAPI{
    case register(phone: String)
    case listCountry
    case checkLogin(phone: String, verification_code: String)
    case logout
    case userInfo
}

extension AuthServerAPI: TargetType{
    var baseURL: URL {
        return BaseUrl.url.value
    }
    
    var path: String {
        switch self {
        case .register:
            return "/auth/register"
        case .listCountry:
            return "/country"
        case .checkLogin:
            return "/auth/login"
        case .logout:
            return "/auth/logout"
        case .userInfo:
            return "/user/current"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .register, .checkLogin:
            return .post
        case .listCountry, .logout, .userInfo:
            return .get
        }
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        switch self {
        case .register(let phone):
            return .requestParameters(parameters: ["phone": phone], encoding: URLEncoding.default)
        case .listCountry, .logout, .userInfo:
            return .requestPlain
        case .checkLogin(let phone, let verification_code):
            return .requestParameters(parameters: ["phone": phone,
                                                   "verification_code": verification_code],
                                      encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        let params: [String: String]
        
        switch self {
        case .register, .listCountry, .checkLogin:
            params = ["Content-Type": "application/x-www-form-urlencoded",
                      "Accept": "application/json"]
        case .logout, .userInfo:
            let tokenModel = AuthTokenNowait.shared.tokenModel
            if let token = tokenModel.value?.token, let tokenType = tokenModel.value?.token_type{
                params = ["Authorization": "\(tokenType) \(token)",
                          "Accept": "application/json"]
            }else{
                params = ["Accept": "application/json"]
            }
        }
        return params
    }
    
}


