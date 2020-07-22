//
//  ShopDescTableViewCell.swift
//  Nowait
//
//  Created by Sergey Nazarov on 22.07.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import UIKit

class ShopDescTableViewCell: UITableViewCell {

    @IBOutlet weak var descriptionCafe: UILabel!
    @IBOutlet weak var arrow: UIImageView!
    
    func rotationArrow(rotationAngle: CGFloat){
        UIView.animate(withDuration: 0.5) {[weak self] in
            self?.arrow.transform = CGAffineTransform(rotationAngle: rotationAngle)
        }
    }
}
