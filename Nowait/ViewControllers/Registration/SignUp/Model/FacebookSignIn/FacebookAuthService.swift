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
            self?.authResultSubject.onNext(FacebookAuthToken(accessToken: result?.token, error: error))
        }
    }
    
    func logout() {
        loginManager.logOut()
    }
    
}
