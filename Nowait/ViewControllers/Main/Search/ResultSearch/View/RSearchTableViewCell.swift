//
//  RSearchTableViewCell.swift
//  Nowait
//
//  Created by Sergey Nazarov on 16.07.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import UIKit
import SDWebImage

class RSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var viewResultSearch: ResultSearch!
    
    weak var dataRSearch: RSearchCellViewModelType?{
        willSet(data){
            viewResultSearch.name.text = data?.name
            viewResultSearch.time.text = data?.time
            viewResultSearch.address.text = data?.address
            viewResultSearch.price.text = data?.price
            viewResultSearch.rating.text = data?.rating
            
            getImage(url: data?.picture)
        }
    }
    
    private func getImage(url: String?){
        viewResultSearch.picture.sd_setImage(with: URL(string: url ?? ""), completed: nil)
    }

}
