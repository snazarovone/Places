//
//  FacebookAuthProviderProtocol.swift
//  Nowait
//
//  Created by Sergey Nazarov on 19.05.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import UIKit
import RxSwift

protocol FacebookAuthProviderProtocol {
    var facebookAuthToken: Observable<FacebookAuthToken> {get}
    
    func login(vc: UIViewController)
    func logout()
}
