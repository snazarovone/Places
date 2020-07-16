//
//  SearchAPI.swift
//  Nowait
//
//  Created by Sergey Nazarov on 14.07.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation
import Moya
import Moya_ObjectMapper
import RxSwift
import ObjectMapper
import Alamofire

class SearchAPI{
    static let delegate = UIApplication.shared.delegate as! AppDelegate
    
    static func requstSearchAPI <T>(type: T.Type, request: SearchServerAPI, callback: @escaping (T?)->()) where T : BaseResponseModel{
        
        delegate.providerSearchServerAPI.session.session.getAllTasks { (value) in
            
            for task in value{
                if let currentRequest = task.currentRequest,
                    let url = currentRequest.url, url == URL(string: "\(request.baseURL.absoluteString)\(request.path)"){
                    task.cancel()
                }
            }
            
            delegate.providerSearchServerAPI.rx.request(request).filterSuccessfulStatusCodes().mapObject(T.self).asObservable().subscribe(onNext: { (responce) in
                callback(responce)
            }, onError: { e in
                let error = e as! MoyaError
                var statusCode = error.response?.statusCode
                
                if statusCode == nil && error.localizedDescription.lowercased().contains("cancelled"){
                    statusCode = 6
                }
                
                let responce = T(success: false, message: error.localizedDescription, error: nil, statusCode: statusCode)
                
                callback(responce)
                
            }, onCompleted: nil, onDisposed: nil).disposed(by: delegate.disposeBag)
        }
    }
}
