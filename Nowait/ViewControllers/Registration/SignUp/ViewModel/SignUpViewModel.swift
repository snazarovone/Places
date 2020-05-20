//
//  SignUpViewModel.swift
//  Nowait
//
//  Created by Sergey Nazarov on 18.05.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SignUpViewModel: SignUpViewModelType{
    
    var country: BehaviorRelay<[Country]> = BehaviorRelay(value: [])
    var selectCountry: BehaviorRelay<Country?> = BehaviorRelay(value: nil)
  
    var currentTextPhoneTF: String = ""
    var fullphone = ""
    
    init(country: BehaviorRelay<[Country]>){
        self.country = country
    }
    
    public func setSelectCountry(){
        selectCountry.accept(country.value.first)
    }
    
    public func formattedNumber(number: String) -> String? {
        self.currentTextPhoneTF = number
        
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        guard let mask = selectCountry.value?.mask else {
            return nil
        }
        
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    var isValidPhoneNumber: Bool{
        guard let mask = selectCountry.value?.mask else{
            return false
        }
        
        if mask.count != formattedNumber(number: currentTextPhoneTF)?.count{
            return false
        }
        return true
    }
    
    func requestRegistrationAtPhone(callback: @escaping ((ResultResponce, BaseResponseModel?)->())){
        guard let selectCountry = selectCountry.value, let code = selectCountry.code?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            callback(.fail, BaseResponseModel(success: false, message: "Выберите страну", error: "Ошибка"))
            return
        }
         
        let fullphone = "\(code) \(currentTextPhoneTF)"
        self.fullphone = fullphone
        
        AuthAPI.requstAuthAPI(type: BaseResponseModel.self, request: .register(phone: fullphone)) { (value) in
            if value?.success ?? false{
                callback(.success, nil)
            }else{
                callback(.fail, value)
            }
        }
    }
    
    func requestListCountry(callback: @escaping ((ResultResponce, BaseResponseModel?)->())){
        AuthAPI.requstAuthAPI(type: CountryModels.self, request: .listCountry) { [weak self] (value) in
            if value?.success == true {
                self?.country.accept(value?.data ?? [])
                callback(.success, nil)
            }else{
                callback(.fail, value)
            }
        }
    }
}
