//
//  SearchCollectionViewCell.swift
//  Nowait
//
//  Created by Sergey Nazarov on 14.07.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import UIKit
import SDWebImage

class SearchCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var img: DesignableUIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var rating: UILabel!
    
    weak var dataSearch: SearchCellViewModelType?{
        willSet(data){
            getImage(url: data?.img)
            title.text = data?.title
            type.text = data?.type
            time.text = data?.time
            rating.text = data?.rating
        }
    }
    
    private func getImage(url: String?){
        img.sd_setImage(with: URL(string: url ?? ""), completed: nil)
    }
}
