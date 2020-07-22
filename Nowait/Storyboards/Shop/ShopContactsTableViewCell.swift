//
//  ShopContactsTableViewCell.swift
//  Nowait
//
//  Created by Sergey Nazarov on 22.07.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import UIKit

class ShopContactsTableViewCell: UITableViewCell {
    @IBOutlet weak var phoneNumber: UIButton!
    @IBOutlet weak var email: UIButton!
    
    weak var delegate: ShopContactDelegate?
    
    var dataContact: ContactCellViewModelType?{
        willSet(data){
            phoneNumber.isHidden = data?.isHidePhone ?? true
            email.isHidden = data?.isHideEmail ?? true
            phoneNumber.setTitle(data?.phone, for: .normal)
            email.setTitle(data?.email, for: .normal)
        }
    }
    
    
    @IBAction func phoneAction(_ sender: UIButton) {
        self.delegate?.callPhoneNumber()
    }
    
    @IBAction func emailAction(_ sender: UIButton) {
        self.delegate?.sendEmail()
    }
}
