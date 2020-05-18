//
//  Country.swift
//  Nowait
//
//  Created by Sergey Nazarov on 18.05.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation

class Country{
    var name: String?
    var mask: String?
    var code: String?
    
    init(name: String?, mask: String?, code: String?){
        self.name = name
        self.mask = mask
        self.code = code
    }
}
