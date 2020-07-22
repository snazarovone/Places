//
//  ShopTimeWorkTableViewCell.swift
//  Nowait
//
//  Created by Sergey Nazarov on 22.07.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import UIKit

class ShopTimeWorkTableViewCell: UITableViewCell {
    
    @IBOutlet weak var timeWork: UILabel!
    
    var dataTimeWork: TimeWorkViewModelType?{
        willSet(data){
            timeWork.text = data?.times
        }
    }
}
