//
//  PersonalInformationViewModelType.swift
//  Nowait
//
//  Created by Sergey Nazarov on 01.06.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol PersonalInformationViewModelType {
    var fields: [String] {get set}
    var photo: UIImage? {get set}
    var userInfo: BehaviorRelay<UserInfo?> {get}
    var imageUser: BehaviorRelay<UIImage?> {get set}
    
    func setFields()
    func formattedNumber(number: String) -> String?
    func getDateInFormat(date: Date?) -> String
}
