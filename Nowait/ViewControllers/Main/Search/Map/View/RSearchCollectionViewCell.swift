//
//  RSearchCollectionViewCell.swift
//  Nowait
//
//  Created by Sergey Nazarov on 20.07.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import UIKit
import SDWebImage

class RSearchCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var picture: DesignableUIImageView!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var price: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    weak var dataRSearch: RSearchCellViewModelType?{
        willSet(data){
            name.text = data?.name
            time.text = data?.time
            address.text = data?.address
            price.text = data?.price
            rating.text = data?.rating
            
            getImage(url: data?.picture)
        }
    }
    
    private func getImage(url: String?){
        picture.sd_setImage(with: URL(string: url ?? ""), completed: nil)
    }
    
}
