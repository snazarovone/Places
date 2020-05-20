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
import FBSDKCoreKit
import SwiftOverlays

class MainViewController: UIViewController {
    
    private let mainViewModel = MainViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if mainViewModel.checkExistValidToken() == false{
            showSignInVC()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == String(describing: SignUpViewController.self){
            if let dvc = segue.destination as? SignUpViewController{
                dvc.signUpViewModel = SignUpViewModel(country: mainViewModel.country)
            }
            return
        }
        
        if segue.identifier == String(describing: MainTableViewController.self){
            if let dvc = segue.destination as? MainTableViewController{
                dvc.mainView = self
            }
            return
        }
    }

    //MARK:- deinit
    deinit {
        print("MainViewController is deinit")
    }
}

extension MainViewController: MainViewDelegate{
    func showSignInVC() {
        performSegue(withIdentifier: String(describing: SignUpViewController.self), sender: nil)
    }
}

