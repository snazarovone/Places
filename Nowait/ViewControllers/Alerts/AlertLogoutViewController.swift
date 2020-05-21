//
//  AlertLogoutViewController.swift
//  Nowait
//
//  Created by Sergey Nazarov on 20.05.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import UIKit

class AlertLogoutViewController: UIViewController {

    @IBOutlet weak var alertView: DesignableUIView!
    
    //PUBLIC
    public var isLogout: (()->())? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        alertView.alpha = 0.0
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        alertView.alpha = 0.0
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        UIView.animate(withDuration: 0.5) {
            self.alertView.alpha = 1.0
            self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        }
    }

    
    //MARK:- Actions
    @IBAction func logout(_ sender: Any) {
        self.alertView.alpha = 1.0
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.alertView.alpha = 0.0
            self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        }) { (_) in
            self.dismiss(animated: false) {
                self.isLogout?()
            }
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.alertView.alpha = 1.0
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.alertView.alpha = 0.0
            self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        }) { (_) in
            self.dismiss(animated: false) {
            }
        }
    }
    
    
    //MARK:- deinit
    deinit{
        print("AlertLogoutViewController is deinit")
    }
}
