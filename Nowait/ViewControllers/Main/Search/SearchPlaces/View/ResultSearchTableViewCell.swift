//
//  ResultSearchTableViewCell.swift
//  Nowait
//
//  Created by Sergey Nazarov on 15.07.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import UIKit

class ResultSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    
    weak var dataResultSearch: ResultSearchCellViewModelType?{
        willSet(data){
            logo.image = data?.logo
            title.text = data?.title
        }
    }

}
