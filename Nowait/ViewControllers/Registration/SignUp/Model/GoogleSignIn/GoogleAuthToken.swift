//
//  GoogleAuthToken.swift
//  Nowait
//
//  Created by Sergey Nazarov on 18.05.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation

class GoogleAuthToken{
    let userId: String?        // For client-side use only!
    let idToken: String?      // Safe to send to the server
    let fullName: String?
    let givenName: String?
    let familyName: String?
    let email: String?
    
    init(userId: String?, idToken: String?, fullName: String?, givenName: String?, familyName: String?, email: String?){
        self.userId = userId
        self.idToken = idToken
        self.fullName = fullName
        self.givenName = givenName
        self.familyName = familyName
        self.email = email
    }
}
