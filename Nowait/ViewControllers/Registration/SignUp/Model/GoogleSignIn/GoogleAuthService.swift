//
//  GoogleAuthService.swift
//  Nowait
//
//  Created by Sergey Nazarov on 18.05.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation
import RxSwift
import GoogleSignIn

class GoogleAuthService: NSObject, GoogleAuthProviderProtocol{
   
    var googleAuthToken: Observable<GoogleAuthToken>{
        return authResultSubject.asObserver()
    }
    
    private let authResultSubject = PublishSubject<GoogleAuthToken>()
    
    override init(){
        super.init()
        GIDSignIn.sharedInstance().delegate = self
    }
    
    func login() {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    func logout() {
        GIDSignIn.sharedInstance().signOut()
    }
    
}

extension GoogleAuthService: GIDSignInDelegate{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
          if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
            print("The user has not signed in before or they have since signed out.")
          } else {
            print("\(error.localizedDescription)")
          }
          return
        }
        // Perform any operations on signed in user here.
        let userId = user.userID                  // For client-side use only!
        let idToken = user.authentication.idToken // Safe to send to the server
        let fullName = user.profile.name
        let givenName = user.profile.givenName
        let familyName = user.profile.familyName
        let email = user.profile.email
        let googleAuthToken = GoogleAuthToken(userId: userId, idToken: idToken, fullName: fullName, givenName: givenName, familyName: familyName, email: email)
        authResultSubject.onNext(googleAuthToken)
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
}
