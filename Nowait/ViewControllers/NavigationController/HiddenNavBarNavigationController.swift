//
//  HiddenNavBarNavigationController.swift
//  Nowait
//
//  Created by Sergey Nazarov on 01.06.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import UIKit

class HiddenNavBarNavigationController: UINavigationController {

        // MARK: - Properties
    
    private var popRecognizer: InteractivePopRecognizer?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPopRecognizer()
        
    }
    
    // MARK: - Setup
    private func setupPopRecognizer() {
        popRecognizer = InteractivePopRecognizer(controller: self)
    }
    
}
