//
//  SignUpViewModelType.swift
//  Nowait
//
//  Created by Sergey Nazarov on 18.05.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol SignUpViewModelType {
    func formattedNumber(number: String) -> String?
   
    var currentTextPhoneTF: String {get}
    var country: BehaviorRelay<[Country]> {get}
    var selectCountry: BehaviorRelay<Country?> {get}
    
    var isValidPhoneNumber: Bool {get}
    var fullphone: String {get}
    
    func requestRegistrationAtPhone(callback: @escaping ((ResultResponce, BaseResponseModel?)->()))
    func requestListCountry(callback: @escaping ((ResultResponce, BaseResponseModel?)->()))
    
}
