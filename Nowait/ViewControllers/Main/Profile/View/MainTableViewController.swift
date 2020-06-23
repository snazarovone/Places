//
//  MainTableViewController.swift
//  Nowait
//
//  Created by Sergey Nazarov on 19.05.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftOverlays
import SDWebImage

class MainTableViewController: UITableViewController {
    
    @IBOutlet var settingSectionCells: [UITableViewCell]!
    @IBOutlet var helpersSectionCells: [UITableViewCell]!
    @IBOutlet weak var createAccount: DesignableUIButton!
    
    @IBOutlet weak var photoUser: DesignableUIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phone: UILabel!
    
    //PUBLIC
    public weak var mainView: MainViewDelegate?
    
    //PRIVATE
    private let mainViewModel = MainViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideNavigationBar()
    }
    
    private func subscribes(){
        mainViewModel.authTokenNowait.tokenModel.asObservable().subscribe(onNext: { [weak self] value in
            self?.tableView.reloadData()
            self?.updateHeaderView()
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        mainViewModel.userInfo.skip(1).asObservable().subscribe(onNext: { [weak self] (userInfo) in
            print("userInfo")
            self?.setDataUserInfo(userInfo: userInfo)
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    //MARK:- Alert
    private func showAlert(message: String, title: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "ОК", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK:- Prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == String(describing: AlertLogoutViewController.self){
            if let dvc = segue.destination as? AlertLogoutViewController{
                dvc.isLogout = {
                    [weak self] in
                    //MARK:- Logout
                    self?.logout()
                }
            }
            return
        }
    }
    
    private func logout(){
        let facebookAuthService = FacebookAuthService()
        facebookAuthService.logout()
        
        let googleAuthService = GoogleAuthService()
        googleAuthService.logout()
        
        self.requestLogout()
    }
    
    private func updateHeaderView(){
        if mainViewModel.checkExistValidToken() == true{
            createAccount.isHidden = true
            
            photoUser.image = nil
            photoUser.isHidden = false
            
            name.text = nil
            name.isHidden = false
            
            phone.text = nil
            phone.isHidden = false
            
            DispatchQueue.main.async {
                self.requestUserInfo()
            }
        }else{
            createAccount.isHidden = false
            photoUser.isHidden = true
            name.isHidden = true
            phone.isHidden = true
            
            UserInfoData.shared.removeInfoUser()
        }
    }
    
    private func setDataUserInfo(userInfo: UserInfo?){
        guard let userInfo = userInfo  else {
            photoUser.isHidden = true
            name.isHidden = true
            phone.isHidden = true
            return
        }
        
        
        if let n = userInfo.name{
            if let lastName = userInfo.last_name{
                name.text = "\(n) \(lastName)"
            }else{
                name.text = "\(n)"
            }
        }else{
            if let lastName = userInfo.last_name{
                name.text = "\(lastName)"
            }else{
                name.text = nil
            }
        }
        
        if let phoneUser = userInfo.phone{
            phone.text = phoneUser
        }else{
            phone.text = userInfo.email
        }
        

        if let img = userInfo.image, let urlImage = URL(string: "\(img)"){
            DispatchQueue.main.async {
                SDWebImageManager.shared.loadImage(with: urlImage, options: .highPriority, progress: nil) { [weak self]
                    (image, data, error, cacheType, isFinished, imageUrl) in
                    self?.photoUser.image = image
                    if image != nil{
                        self?.photoUser.isHidden = false
                    }else{
                        self?.photoUser.isHidden = true
                    }
                }
            }
        }
        else{
            photoUser.image = nil
            photoUser.isHidden = true
        }
        
    }
    
    //MARK:- RequestLogout
    private func requestLogout(){
        showWaitOverlay()
        view.isUserInteractionEnabled = false
        mainViewModel.requestLogOut { [weak self] (resultResponce, baseResponseModel) in
            self?.removeAllOverlays()
            self?.view.isUserInteractionEnabled = true
            switch resultResponce{
            case .success:
                self?.mainViewModel.authTokenNowait.removeData()
            case .fail:
                self?.showAlert(message: baseResponseModel?.message ?? "",
                                title: baseResponseModel?.error ?? "")
            }
        }
    }
    
    //MARK:- RequestUserInfo
    private func requestUserInfo(){
        SwiftOverlays.showBlockingWaitOverlay()
        
        UserInfoData.shared.requestUserInfo { (_, _) in
            SwiftOverlays.removeAllBlockingOverlays()
        }
        
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return MainMenuSectionModel.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if MainMenuSectionModel.settings.section == section{
            if mainViewModel.checkExistValidToken() == true{
                return MainMenuSectionModel.settings.cellFull.count
            }
            return MainMenuSectionModel.settings.cellNotAuth.count
        }else{
            if mainViewModel.checkExistValidToken() == true{
                return MainMenuSectionModel.helpers.cellFull.count
            }else{
                return MainMenuSectionModel.helpers.cellNotAuth.count
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if MainMenuSectionModel.settings.section == indexPath.section{
            if mainViewModel.checkExistValidToken() == true{
                return settingSectionCells[indexPath.row]
            }
            return settingSectionCells[1]
        }else{
            return helpersSectionCells[indexPath.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView.viewFromNibName(name: "MainHeader") as! MainHeaderUIView
        header.titleName.text = ""
        for (i, headerSection) in MainMenuSectionModel.allCases.enumerated(){
            if i == section{
                header.titleName.text = headerSection.title
                break
            }
        }
        return header
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        for menuCell in MainMenuCell.allCases{
            if menuCell.id == cell?.reuseIdentifier{
                didSelect(cell: menuCell)
                break
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    private func didSelect(cell: MainMenuCell){
        switch cell {
        case .logout:
            //MARK:- Logout
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: String(describing: AlertLogoutViewController.self), sender: nil)
            }
        case .userInfo:
            //MARK:- UserInfo
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: String(describing: PersonalInformationViewController.self), sender: nil)
            }
        default:
            break
        }
    }
    
    //MARK:- Acrion
    @IBAction func login(_ sender: UIButton){
        mainView?.showSignInVC()
    }
    
    //MARK:- deinit
    deinit{
        print("MainTableViewController is deinit")
    }
}
