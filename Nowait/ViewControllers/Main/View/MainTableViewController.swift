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
    
    private func subscribes(){
        mainViewModel.authTokenNowait.tokenModel.asObservable().subscribe(onNext: { [weak self] _ in
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
    
    private func updateHeaderView(){
        if mainViewModel.checkExistValidToken() == true{
            createAccount.isHidden = true
          
            photoUser.image = nil
            photoUser.isHidden = false
            
            name.text = nil
            name.isHidden = false
            
            phone.text = nil
            phone.isHidden = false
            
            reuestUserInfo()
        }else{
            createAccount.isHidden = false
            photoUser.isHidden = true
            name.isHidden = true
            phone.isHidden = true
            
            mainViewModel.removeInfoUser()
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

        phone.text = userInfo.phone
        
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
    private func reuestUserInfo(){
        showWaitOverlay()
        view.isUserInteractionEnabled = false
        mainViewModel.requestUserInfo { [weak self] (resultResponce, userInfoModel) in
            self?.removeAllOverlays()
            self?.view.isUserInteractionEnabled = true
            switch resultResponce{
            case .success:
                break;
            case .fail:
                self?.showAlert(message: userInfoModel?.message ?? "",
                                title: userInfoModel?.error ?? "")
            }
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
            return MainMenuSectionModel.helpers.cellFull.count
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
            self.requestLogout()
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
