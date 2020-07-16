//
//  SearchViewHeader.swift
//  Nowait
//
//  Created by Sergey Nazarov on 14.07.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import UIKit

class SearchViewHeader: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var title: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        UINib(nibName: "SearchHeader", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
    }

}
