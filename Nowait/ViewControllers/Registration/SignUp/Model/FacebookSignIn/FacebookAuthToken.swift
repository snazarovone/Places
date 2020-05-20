//
//  FacebookAuthToken.swift
//  Nowait
//
//  Created by Sergey Nazarov on 19.05.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation
import FBSDKCoreKit

class FacebookAuthToken{
    
    let accessToken: AccessToken?
    let firstName: String?
    let lastName: String?
    let email: String?
    
    let error: Error?
    
    init(accessToken: AccessToken?, error: Error?, firstName: String?, lastName: String?, email: String?){
        self.accessToken = accessToken
        self.error = error
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }
}
