//
//  AuthProviderProtocol.swift
//  Nowait
//
//  Created by Sergey Nazarov on 18.05.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation
import RxSwift
import AuthenticationServices

protocol AuthProviderProtocol {
    var authResult: Observable<AuthToken> { get }
    
    func login()
}
