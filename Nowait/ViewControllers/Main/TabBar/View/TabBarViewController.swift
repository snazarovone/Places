//
//  TabBarViewController.swift
//  Nowait
//
//  Created by Sergey Nazarov on 30.05.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
}

extension TabBarViewController: TabBarNavigationDelegate{
    func showTab(item: ItemsTabBar){
        DispatchQueue.main.async {
             self.selectedIndex = item.index
        }
    }
}
