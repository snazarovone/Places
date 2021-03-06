//
//  CodeTextFieldDelegate.swift
//  Nowait
//
//  Created by Sergey Nazarov on 18.05.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation

protocol CodeTextFieldDelegate: class {
    func textFieldDidEnterBackspace(_ textField: CodeTextField)
}
