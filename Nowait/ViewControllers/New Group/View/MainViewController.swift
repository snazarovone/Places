//
//  MainViewController.swift
//  Nowait
//
//  Created by Sergey Nazarov on 18.05.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {
    
    private let mainViewModel = MainViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        performSegue(withIdentifier: String(describing: SignUpViewController.self), sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == String(describing: SignUpViewController.self){
            if let dvc = segue.destination as? SignUpViewController{
                dvc.signUpViewModel = SignUpViewModel(country: mainViewModel.country)
            }
        }
    }

    //MARK:- deinit
    deinit {
        print("MainViewController is deinit")
    }
}

