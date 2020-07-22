//
//  ShopViewController.swift
//  Nowait
//
//  Created by Sergey Nazarov on 21.07.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import UIKit

class ShopViewController: UIViewController {
    
    public var viewModel: ShopViewModelType!
    
    @IBOutlet weak var nameCafe: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rating.text = viewModel.rating
        nameCafe.alpha = 0.0
    }
    
    func isTitle(show: Bool){
        var alpha: CGFloat = 0.0
        if show{
            alpha = 1.0
        }
        
        UIView.animate(withDuration: 0.5) {
            self.nameCafe.alpha = alpha
        }
    }
    
    //MARK:- Prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == String(describing: ShopTableViewController.self), let dvc = segue.destination as? ShopTableViewController{
            dvc.viewModel = viewModel
            dvc.isTitle = {
                [weak self] show in
                self?.isTitle(show: show)
            }
        }
    }
    
    //MARK:- Actions
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func favorite(_ sender: UIButton) {
    }
    
    //MARK:- deinit
    deinit {
        print("ShopViewController is deinit")
    }
}
