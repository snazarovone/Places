//
//  ShopOtherTableViewCell.swift
//  Nowait
//
//  Created by Sergey Nazarov on 22.07.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import UIKit
import AlignedCollectionViewFlowLayout

class ShopOtherTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataOther = [ShopOtherModel]()
    
    private let alignedFlowLayout = AlignedCollectionViewFlowLayout(horizontalAlignment: .left,
                                                            verticalAlignment: .top)
    func configure(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = alignedFlowLayout
        
        let d1 = ShopOtherModel(name: "Wi-Fi", image: #imageLiteral(resourceName: "wifi 1.png"))
        let d2 = ShopOtherModel(name: "Вид на море", image: #imageLiteral(resourceName: "wifi 1.png"))
        let d3 = ShopOtherModel(name: "Банковские карты", image: #imageLiteral(resourceName: "wifi 1.png"))
        let d4 = ShopOtherModel(name: "Парковка", image: #imageLiteral(resourceName: "wifi 1.png"))
        let d5 = ShopOtherModel(name: "Детское питание", image: #imageLiteral(resourceName: "wifi 1.png"))
        dataOther = [d1, d2, d3, d4, d5]
        
        registerCell()
        
        self.collectionView.reloadData()
        self.collectionView.layoutIfNeeded()
    }
    
   
    
    private func registerCell() {
        //Cell Description
        let cellOther = UINib(nibName: String(describing: ShopOtherCollectionViewCell.self),
                              bundle: nil)
        self.collectionView.register(cellOther, forCellWithReuseIdentifier: String(describing: ShopOtherCollectionViewCell.self))
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    private func getWidth(at text: String) -> CGSize?{
        if let font = UIFont(name: "SFProText-Light", size: 15.0) {
            let fontAttributes = [NSAttributedString.Key.font: font]
            let size = (text as NSString).size(withAttributes: fontAttributes)
            return size
        }
        return nil
    }
}

extension ShopOtherTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataOther.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ShopOtherCollectionViewCell.self), for: indexPath) as! ShopOtherCollectionViewCell
        cell.name.text = dataOther[indexPath.row].name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = 58.0 + (getWidth(at: dataOther[indexPath.row].name)?.width ?? 32.0)
        return CGSize(width: w, height: 34.0)
    }
    
}
