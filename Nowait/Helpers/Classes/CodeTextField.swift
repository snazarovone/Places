//
//  CodeTextField.swift
//  Nowait
//
//  Created by Sergey Nazarov on 18.05.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import UIKit
class CodeTextField: UITextField {
    weak var myTextFieldDelegate: CodeTextFieldDelegate?
    
    override func deleteBackward() {
        if text?.isEmpty ?? false {
            myTextFieldDelegate?.textFieldDidEnterBackspace(self)
        }
        
        super.deleteBackward()
    }
}
