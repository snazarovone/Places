//
//  LaunchViewController.swift
//  Nowait
//
//  Created by Sergey Nazarov on 02.06.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftOverlays

class LaunchViewController: UIViewController {
    
    let authTokenNowait = AuthTokenNowait.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if checkExistValidToken() == false{
            self.performSegue(withIdentifier: String(describing: MainViewController.self), sender: nil)
        }else{
             requestGetUserInfo()
        }
    }
    
    public func checkExistValidToken() -> Bool{
        if authTokenNowait.tokenModel.value?.token != nil && authTokenNowait.tokenModel.value?.token_type != nil{
            return true
        }else{
            return false
        }
    }
    
    //MARK:- Request
    private func requestGetUserInfo(){
        self.showWaitOverlay()
        UserInfoData.shared.requestUserInfo { [weak self] (res, errorResponce) in
            self?.removeAllOverlays()
            self?.performSegue(withIdentifier: String(describing: MainViewController.self), sender: nil)
        }
    }
    
    
    
    //MARK:- deinit
    deinit {
        print("LaunchViewController is deinit")
    }
}
