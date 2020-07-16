//
//  ResultSearch.swift
//  Nowait
//
//  Created by Sergey Nazarov on 14.07.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import UIKit

class ResultSearch: UIView {

    @IBOutlet var view: UIView!
    
    @IBOutlet weak var picture: DesignableUIImageView!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var price: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        UINib(nibName: "ResultSearch", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
    }

}
