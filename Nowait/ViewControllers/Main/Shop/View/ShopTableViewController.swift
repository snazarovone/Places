//
//  ShopTableViewController.swift
//  Nowait
//
//  Created by Sergey Nazarov on 21.07.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import UIKit
import MessageUI
import SDWebImage
import AnimatedCollectionViewLayout

class ShopTableViewController: UITableViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    public var viewModel: ShopViewModelType!
    public var isTitle: ((Bool)->())? = nil
    
    private weak var cellDescription: ShopDescTableViewCell?
    private var isTitleCafe = false
    
    private var direction: UICollectionView.ScrollDirection = .horizontal
    private let animator: LayoutAttributesAnimator = LinearCardAttributesAnimator(minAlpha: 1.0, itemSpacing: 0.26 , scaleRate: 0.83)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
    }
    
    private func registerCell() {
        //Cell Description
        let cellDescription = UINib(nibName: String(describing: ShopDescTableViewCell.self),
                                    bundle: nil)
        self.tableView.register(cellDescription,
                                forCellReuseIdentifier: String(describing: ShopDescTableViewCell.self))
        
        //Cell Address
        let cellAddress = UINib(nibName: String(describing: ShopAddressTableViewCell.self),
                                bundle: nil)
        self.tableView.register(cellAddress, forCellReuseIdentifier: String(describing: ShopAddressTableViewCell.self))
        
        //Cell TimeWork
        let cellTimeWork = UINib(nibName: String(describing: ShopTimeWorkTableViewCell.self),
                                 bundle: nil)
        self.tableView.register(cellTimeWork, forCellReuseIdentifier: String(describing: ShopTimeWorkTableViewCell.self))
        
        //Cell Contact
        let cellContact = UINib(nibName: String(describing: ShopContactsTableViewCell.self), bundle: nil)
        self.tableView.register(cellContact, forCellReuseIdentifier: String(describing: ShopContactsTableViewCell.self))
        
        //Cell Other
        let cellOther = UINib(nibName: String(describing: ShopOtherTableViewCell.self), bundle: nil)
        self.tableView.register(cellOther, forCellReuseIdentifier: String(describing: ShopOtherTableViewCell.self))
        
        if let layout = collectionView.collectionViewLayout as? AnimatedCollectionViewLayout {
            layout.scrollDirection = direction
            layout.animator = animator
        }
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        switch indexPath.row {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ShopDescTableViewCell.self))!
            (cell as! ShopDescTableViewCell).descriptionCafe.text = viewModel.descriptionCafe
            self.cellDescription = cell as? ShopDescTableViewCell
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ShopAddressTableViewCell.self))!
            (cell as! ShopAddressTableViewCell).address.text = viewModel.address
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ShopTimeWorkTableViewCell.self))!
            (cell as! ShopTimeWorkTableViewCell).dataTimeWork = TimeWorkViewModel(timesWork: viewModel.timeWork)
        case 3:
            cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ShopContactsTableViewCell.self))!
            (cell as! ShopContactsTableViewCell).dataContact = ContactCellViewModel(phone: viewModel.phone, email: viewModel.email)
            (cell as! ShopContactsTableViewCell).delegate = self
        case 4:
            cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ShopOtherTableViewCell.self))!
            (cell as! ShopOtherTableViewCell).configure()
        default:
            cell = UITableViewCell()
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            viewModel.isMore = !viewModel.isMore
            if viewModel.isMore{
                cellDescription?.rotationArrow(rotationAngle:  CGFloat(Double.pi))
                cellDescription?.descriptionCafe.numberOfLines = 0
            }else{
                cellDescription?.rotationArrow(rotationAngle:  0.0)
                cellDescription?.descriptionCafe.numberOfLines = 4
            }
            DispatchQueue.main.async {
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2 && viewModel.isTimes == false{
            return 0.0
        }
        
        if indexPath.row == 3 && viewModel.isContact == false{
            return 0.0
        }
        
        if indexPath.row == 4{
            // 0 если данных нет
        }
        return UITableView.automaticDimension
    }
    
    //MARK:- Scroll View
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= 232.0{
            if isTitleCafe == false{
                isTitleCafe = true
                isTitle?(true)
            }
        }else{
            if isTitleCafe == true{
                isTitleCafe = false
                isTitle?(false)
            }
        }
    }
    
    //MARK:- Actions
    @IBAction func showMenu(_ sender: UIButton){
        
    }
    
    @IBAction func reservationTable(_ sender: UIButton){
        
    }
    
    //MARK:- deinit
    deinit {
        print("ShopTableViewController is deinit")
    }
    
}

extension ShopTableViewController: ShopContactDelegate, MFMailComposeViewControllerDelegate{
    
    private func callNumber(phoneNumber: String) {
        guard let url = URL(string: "telprompt://\(phoneNumber)"),
            UIApplication.shared.canOpenURL(url) else {
                return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    private func sendEmail(at email: String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["\(email)"])
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    func callPhoneNumber() {
        callNumber(phoneNumber: viewModel.phone ?? "")
    }
    
    func sendEmail() {
        sendEmail(at: viewModel.email ?? "")
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

//MARK:- Header CollectionView
extension ShopTableViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.pictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ShopPicturesCollectionViewCell.self), for: indexPath) as! ShopPicturesCollectionViewCell
        cell.getImage(url: viewModel.pictures[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 188.0)
    }

    
}
