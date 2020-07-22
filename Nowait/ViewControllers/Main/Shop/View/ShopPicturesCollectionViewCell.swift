//
//  ShopPicturesCollectionViewCell.swift
//  Nowait
//
//  Created by Sergey Nazarov on 22.07.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import UIKit
import SDWebImage

class ShopPicturesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var picture: DesignableUIImageView!
    
    public func getImage(url: String?){
        picture.sd_setImage(with: URL(string: url ?? ""), completed: nil)
    }
}
