//
//  DesignableUIImageView.swift
//  Nowait
//
//  Created by Sergey Nazarov on 19.05.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableUIImageView: UIImageView{
    @IBInspectable var borderW: CGFloat = 0.0 {
        didSet{
            self.layer.borderWidth = borderW
        }
    }
    
    @IBInspectable var borderC: UIColor = .clear {
        didSet{
            self.layer.borderColor = borderC.cgColor
        }
    }
    
    @IBInspectable var borderRadius: CGFloat = 0.0 {
        didSet{
            self.layer.cornerRadius = borderRadius
        }
    }
    
    @IBInspectable var circular : Bool = false{
        didSet{
            self.applyCornerRadius()
        }
    }
    
    func applyCornerRadius()
    {
        if(self.circular) {
            self.layer.cornerRadius = self.bounds.size.height/2
            self.layer.masksToBounds = true
            self.layer.borderColor = self.borderC.cgColor
            self.layer.borderWidth = CGFloat(self.borderW)
        }else {
            self.layer.cornerRadius = borderRadius
            self.layer.masksToBounds = true
            self.layer.borderColor = self.borderC.cgColor
            self.layer.borderWidth = CGFloat(self.borderW)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyCornerRadius()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyCornerRadius()
    }
    
}
