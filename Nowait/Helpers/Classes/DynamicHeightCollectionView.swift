//
//  DynamicHeightCollectionView.swift
//  Nowait
//
//  Created by Sergey Nazarov on 22.07.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import UIKit

class DynamicHeightCollectionView: UICollectionView {
    override func layoutSubviews() {
        super.layoutSubviews()
        if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize) {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
}
