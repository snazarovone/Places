//
//  SearchServerAPI.swift
//  Nowait
//
//  Created by Sergey Nazarov on 14.07.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation
import Moya
import Alamofire

enum SearchServerAPI{
    case nearby(lat: String, lng: String)
    case popular
    case searchHistory
    case search(text: String)
    case searchFinish(text: String, kitchens: String?, type: SearchType)
}

extension SearchServerAPI: TargetType{
    var baseURL: URL {
        return BaseUrl.url.value
    }
    
    var path: String {
        switch self {
        case .nearby:
            return "/shops/nearby"
        case .popular:
            return "/shops/popular"
        case .searchHistory:
            return "/user/search/history"
        case .search:
            return "/shops/search/autocomplete"
        case .searchFinish:
            return "/shops/search/finish"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .nearby, .search, .searchFinish:
            return .post
        case .popular, .searchHistory:
            return .get
        }
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        switch self {
        case .popular, .searchHistory:
            return .requestPlain
        case .nearby(let lat, let lng):
            return .requestParameters(parameters: ["lat" : lat, "lng": lng], encoding: URLEncoding.default)
        case .search(let text):
            return .requestParameters(parameters: ["text" : text], encoding: URLEncoding.queryString)
        case .searchFinish(let text, let kitchens, let type):
            var params = ["text": text, "type": type.type]

            if let kitchens = kitchens{
                params["kitchens"] = kitchens
            }
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        let params: [String: String]
        switch self {
        case .nearby, .popular, .searchHistory, .search, .searchFinish:
            let tokenModel = AuthTokenNowait.shared.tokenModel
            if let token = tokenModel.value?.token, let tokenType = tokenModel.value?.token_type{
                params = ["Authorization": "\(tokenType) \(token)",
                    "content-type": "multipart/form-data"]
            }else{
                params = ["content-type": "multipart/form-data"]
            }
            
        }
        return params
    }
}
