//
//  CountryTableViewCell.swift
//  Nowait
//
//  Created by Sergey Nazarov on 18.05.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import UIKit

class CountryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleCountry: UILabel!
    
    weak var dataCountry: CountryCellViewModelType?{
        willSet(data){
            self.titleCountry.text = data?.titleCountry
        }
    }
}
