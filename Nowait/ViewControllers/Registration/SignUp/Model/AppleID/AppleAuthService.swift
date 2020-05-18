//
//  AppleAuthService.swift
//  Nowait
//
//  Created by Sergey Nazarov on 18.05.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import UIKit
import RxSwift
import AuthenticationServices


@available(iOS 13.0, *)
class AppleAuthService: NSObject, AuthProviderProtocol{
    
    private let authResultSubject = PublishSubject<AuthToken>()
    
    var authResult: Observable<AuthToken>{
        return authResultSubject.asObserver()
    }
    
    func login() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
}

@available(iOS 13.0, *)
extension AppleAuthService: ASAuthorizationControllerDelegate{
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
              guard
              let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let tokenData = credential.authorizationCode,
              let token = String(data: tokenData, encoding: .utf8)
          else { return }
        

        if let firstName = credential.fullName?.givenName{
            if let lastName = credential.fullName?.familyName{
                 authResultSubject.onNext(.apple(code: token, name: firstName + lastName))
            }else{
                 authResultSubject.onNext(.apple(code: token, name: firstName))
            }
        }else{
             authResultSubject.onNext(.apple(code: token, name: ""))
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
    }
}
