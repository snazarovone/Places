//
//  BaseSearchViewController.swift
//  Nowait
//
//  Created by Sergey Nazarov on 15.07.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BaseSearchViewController: UIViewController {
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func checkAuth(error: ErrorResponce?){
        if let e = error{
            switch e {
            case .unknow(let title, let message):
                self.showAlert(message: message ?? "", title: title ?? "")
            case .unauthorized:
                if let tabBarNavigationDelegate = self.tabBarController as? TabBarNavigationDelegate{
                    self.logoutSocial()
                    tabBarNavigationDelegate.showTab(item: .profile)
                }
            }
        }
    }
    
    //MARK:- Alert
    private func showAlert(message: String, title: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "ОК", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK:- Helpers
    func logoutSocial(){
        let facebookAuthService = FacebookAuthService()
        facebookAuthService.logout()
        
        let googleAuthService = GoogleAuthService()
        googleAuthService.logout()
    }
}
