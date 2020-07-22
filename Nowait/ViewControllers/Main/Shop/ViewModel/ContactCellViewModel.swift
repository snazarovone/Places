//
//  ContactCellViewModel.swift
//  Nowait
//
//  Created by Sergey Nazarov on 22.07.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation

class ContactCellViewModel: ContactCellViewModelType{
    var phone: String?
    
    var isHidePhone: Bool{
        if phone == nil{
            return true
        }
        return false
    }
    
    var email: String?
    
    var isHideEmail: Bool{
        if email == nil{
            return true
        }
        return false
    }
    
   
    init(phone: String?, email: String?){
        self.phone = phone
        self.email = email
    }
}
