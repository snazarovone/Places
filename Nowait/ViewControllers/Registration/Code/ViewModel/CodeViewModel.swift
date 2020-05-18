//
//  CodeViewModel.swift
//  Nowait
//
//  Created by Sergey Nazarov on 18.05.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation

class CodeViewModel: CodeViewModelType{
    
    public let phoneNumber: String
    public let succsessCode = "1234"
    
    init(phoneNumber: String){
        self.phoneNumber = phoneNumber
    }
}
