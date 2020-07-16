//
//  ResultSearchCellViewModel.swift
//  Nowait
//
//  Created by Sergey Nazarov on 15.07.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import UIKit

class ResultSearchCellViewModel: ResultSearchCellViewModelType{
   
    var logo: UIImage
    
    var title: String?
    
    init(logo: UIImage, title: String?){
        self.logo = logo
        self.title = title
    }
}
