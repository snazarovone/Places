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
    let error: Error?
    
    init(accessToken: AccessToken?, error: Error?){
        self.accessToken = accessToken
        self.error = error
    }
}
