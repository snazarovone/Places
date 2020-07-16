//
//  PersonalInformationViewModel.swift
//  Nowait
//
//  Created by Sergey Nazarov on 01.06.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class PersonalInformationViewModel: PersonalInformationViewModelType{
    
    var fields: [String] = ["", "", "", "", ""]
    var photo: UIImage?
    
    var userInfo: BehaviorRelay<UserInfo?>
    let country: BehaviorRelay<[Country]>
    
    var imageUser: BehaviorRelay<UIImage?> = BehaviorRelay(value: nil)
    var currentMask = ""
    
    private var dataImage: Data?
    
    init() {
        self.userInfo = UserInfoData.shared.userInfo
        self.country = ListCountry.shared.country
    }
    
    public func setFields(){
        guard let userInfo = userInfo.value else {
            fields = ["", "", "", "", ""]
            return
        }
        for field in EditFields.allCases{
            switch field {
            case .name:
                fields[field.tag] = userInfo.name ?? ""
            case .lastName:
                fields[field.tag] = userInfo.last_name ?? ""
            case .birthday:
                self.fields[field.tag] = userInfo.birth_date ?? ""
            case .email:
                self.fields[field.tag] = userInfo.email ?? ""
            case .phone:
                self.fields[field.tag] = userInfo.phone ?? ""
            }
        }
    }
    
    public func formattedNumber(number: String) -> String? {
        
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        let mask = getMask(on: cleanPhoneNumber)
        
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "X" || ch == "C"{
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        if result.isEmpty == false{
            self.fields[EditFields.phone.tag] = "+\(result)"
            return "+\(result)"
        }else{
            self.fields[EditFields.phone.tag] = ""
            return ""
        }
    }
    
    private func getMask(on phoneNumber: String) -> String{
        for c in country.value{
            if let code = c.code?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(){
                var mm = ""
                
                let codeRange = NSString(string: phoneNumber).range(of: code, options: String.CompareOptions.caseInsensitive)
                
                if codeRange.lowerBound == 0{
                    for _ in code{
                        mm += "C"
                    }
                    currentMask = "+\(mm) \(c.mask ?? "")"
                    return "\(mm) \(c.mask ?? "")"
                }
            }
        }
        
        var mm = ""
        if let code = country.value.first?.code?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(){
            for _ in code{
                mm += "C"
            }
        }
        
        currentMask = "+\(mm) \(country.value.first?.mask ?? "")"
        return "\(mm) \(country.value.first?.mask ?? "")"
    }
    
    public func getDateInFormat(date: Date?) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = date{
            self.fields[EditFields.birthday.tag] = dateFormatter.string(from: date)
            return dateFormatter.string(from: date)
        }else{
            self.fields[EditFields.birthday.tag] = dateFormatter.string(from: Date())
            return dateFormatter.string(from: Date())
        }
    }
    
    public func requestUpdateUserInfo(callback: @escaping ((ResultResponce, ErrorResponce?)->())){
        validData()
        AuthAPI.requstAuthAPI(type: BaseResponseModel.self,
                              request: .editUserInfo(name: fields[EditFields.name.tag],
                                                     
              last_name: fields[EditFields.lastName.tag],
              email: fields[EditFields.email.tag],
              phone: fields[EditFields.phone.tag],
              image: dataImage,
              birth_date: fields[EditFields.birthday.tag])) { (value) in
              
                UserInfoData.shared.requestUserInfo { (resultResponce, error) in
                    callback(resultResponce, error)
                }
        }
    }
    
    private func validData(){
        for f in EditFields.allCases{
            switch f {
            case .name, .lastName, .birthday:
                fields[f.tag] = fields[f.tag].trimmingCharacters(in: .whitespacesAndNewlines)
            case .email:
                if fields[f.tag].isValidEmail() == false{
                    fields[f.tag] = ""
                }
            case .phone:
                if currentMask.isEmpty == false{
                    if currentMask.count != fields[f.tag].count{
                        fields[f.tag] = ""
                    }
                }
            }
        }
        
        dataImage = imageUser.value?.pngData()
    }
}
