//
//  RSearchCellViewModel.swift
//  Nowait
//
//  Created by Sergey Nazarov on 16.07.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import UIKit

class RSearchCellViewModel: RSearchCellViewModelType{
    var picture: String?{
        return placesModel.logo
    }
    
    var rating: String?{
        return placesModel.rating
    }
    
    var name: String?{
        return placesModel.name
    }
    
    var time: String?{
        if let open = placesModel.mon_open{
            if let close = placesModel.mon_close{
                return "\(open) - \(close)"
            }else{
                return "\(open)"
            }
        }
        return nil
    }
    
    var address: NSMutableAttributedString?{
        var text = ""
        var distance = ""
        if let distanceIn = placesModel.distanceIn{
            text += distanceIn
            distance = "\(distanceIn) • "
            if let address = placesModel.address{
                text += " • \(address)"
            }
        }else{
            if let address = placesModel.address{
                text += "\(address)"
            }
        }
        
        let rangeFullText = NSString(string: text).range(of: text, options: String.CompareOptions.caseInsensitive)
        let rangeBold = NSString(string: text).range(of: distance, options: String.CompareOptions.caseInsensitive)
        
        return getAttribudedString(text: text, rangeFullText: rangeFullText, rangeBold: rangeBold)
    }
    
    var price: NSMutableAttributedString?{
        if let average_check = placesModel.average_check{
            let text = "\(average_check) ₽ средний чек"
            let boldText = "\(average_check) ₽"
            
            let rangeFullText = NSString(string: text).range(of: text, options: String.CompareOptions.caseInsensitive)
            let rangeBold = NSString(string: text).range(of: boldText, options: String.CompareOptions.caseInsensitive)
            
            return getAttribudedString(text: text, rangeFullText: rangeFullText, rangeBold: rangeBold)
            
        }else{
            return nil
        }
    }
    
    let placesModel: PlacesModel
    
    init(placesModel: PlacesModel){
        self.placesModel = placesModel
    }
    
    private func getAttribudedString(text: String, rangeFullText: NSRange, rangeBold: NSRange) -> NSMutableAttributedString{
        let attributedString = NSMutableAttributedString(string: text)
        
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.1764705882, green: 0.1764705882, blue: 0.1764705882, alpha: 1),
                                                   NSAttributedString.Key.font : UIFont.init(name: "SFProText-Light", size: 14)!], range: rangeFullText)
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.1764705882, green: 0.1764705882, blue: 0.1764705882, alpha: 1),
                                        NSAttributedString.Key.font : UIFont.init(name: "SFProText-Medium", size: 14)!], range: rangeBold)
        return attributedString
    }
}
