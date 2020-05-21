//
//  FacebookAuthService.swift
//  Nowait
//
//  Created by Sergey Nazarov on 19.05.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation
import RxSwift
import FBSDKCoreKit
import FBSDKLoginKit

class FacebookAuthService: FacebookAuthProviderProtocol{
    
    var facebookAuthToken: Observable<FacebookAuthToken>{
        return authResultSubject.asObserver()
    }
    
    private let authResultSubject = PublishSubject<FacebookAuthToken>()
    private let loginManager = LoginManager()
    
    func login(vc: UIViewController) {
        loginManager.logIn(permissions: ["public_profile", "email"], from: vc) { [weak self] (result, error) in
            
            if error == nil{
                let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields": "first_name, last_name, email"])
                
                request.start { [weak self] (graphRequestConnection, r, error) in
                    guard let Info = r as? [String: Any] else {
                        let fb = FacebookAuthToken(accessToken: result?.token,
                                                   error: error,
                                                   firstName: nil, lastName: nil, email: nil)
                        self?.authResultSubject.onNext(fb)
                        return
                        
                    }
                    
                    let fb = FacebookAuthToken(accessToken: result?.token,
                                               error: error,
                                               firstName: Info["first_name"] as? String,
                                               lastName: Info["last_name"] as? String, email: Info["email"] as? String)
                    self?.authResultSubject.onNext(fb)
                }
            }else{
                let fb = FacebookAuthToken(accessToken: result?.token,
                                           error: error,
                                           firstName: nil, lastName: nil, email: nil)
                self?.authResultSubject.onNext(fb)
            }
        }
    }
    
    func logout() {
        if AccessToken.isCurrentAccessTokenActive{
            loginManager.logOut()
        }
    }
    
}
