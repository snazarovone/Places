//
//  SearchPlacesViewController.swift
//  Nowait
//
//  Created by Sergey Nazarov on 15.07.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftOverlays

class SearchPlacesViewController: BaseSearchViewController {
    
    @IBOutlet weak var tableViewHistory: UITableView!
    @IBOutlet weak var tableViewResults: UITableView!
    @IBOutlet weak var clearFields: UIButton!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var historySearchTitle: UILabel!
    
    private var tap: UITapGestureRecognizer!
    
    private var viewModel: SearchPlacesViewModelType = SearchPlacesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configKeyboard()
        requestHistory()
        subscribe()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dismissKeyboard()
        removeNotificationKeyBoard()
    }
    
    private func subscribe(){
        viewModel.historySearch.asObservable().subscribe(onNext: { [weak self] (value) in
            if value.count == 0{
                self?.historySearchTitle.isHidden = true
            }else{
                self?.historySearchTitle.isHidden = false
            }
            self?.tableViewHistory.reloadData()
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.resultSearch.asObservable().subscribe(onNext: { [weak self] (value) in
            if value == nil{
                self?.tableViewHistory.isHidden = false
                self?.tableViewResults.isHidden = true
            }else{
                self?.tableViewHistory.isHidden = true
                self?.tableViewResults.isHidden = false
            }
            self?.tableViewResults.reloadData()
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    //MARK:- Request
    private func requestHistory(){
        viewModel.requestHistorySearch { (_, _) in
        }
    }
    
    private func requestSearchAtText(){
        viewModel.requestSearchAtText { [weak self] (resultResponce, error) in
            switch resultResponce{
            case .success:
                break
            case .fail:
                self?.checkAuth(error: error)
            }
        }
    }
    
    //MARK:- Prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == String(describing: ResultSearchViewController.self), let dvc = segue.destination as? ResultSearchViewController{
            dvc.resultSearchViewModel = ResultSearchViewModel(searchText: sender as? String)
            dvc.searchPlacesViewModel = viewModel
        }
    }
    
    //MARK:- Actions
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clearSearch(_ sender: UIButton) {
        searchTF.text = ""
        viewModel.searchText = ""
        viewModel.resultSearch.accept(nil)
    }
    
    //MARK:- deinit
    deinit{
        print("SearchPlacesViewController is deinit")
    }

}

//MARK:- TextField
extension SearchPlacesViewController: UITextFieldDelegate{
    fileprivate func configKeyboard(){
        //dissmis keyboard
        tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.isEnabled = false
        
        //event свернуть клавиатуру если был тап в пустую область
        view.addGestureRecognizer(tap)
        registerForKeyboardNotification()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        tap.isEnabled = false
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tap.isEnabled = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        if viewModel.searchText != ""{
            requestSearchAtText()
        }else{
            viewModel.resultSearch.accept(nil)
        }
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard var currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return true}
        
        currentText = currentText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        viewModel.searchText = currentText
        textField.text = currentText
        
        if viewModel.searchText.count > 3{
            requestSearchAtText()
        }else{
            if viewModel.searchText.count == 0 && viewModel.resultSearch.value != nil{
                viewModel.resultSearch.accept(nil)
            }
        }
        
        return false
    }
    
    func registerForKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func kbWillShow(_ notification: Notification){
        let userInfo = notification.userInfo!
        let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
        
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.tableViewHistory.contentInset
        
        contentInset.bottom = keyboardFrame.size.height
        tableViewHistory.contentInset = contentInset
        tableViewResults.contentInset = contentInset
        
        
        UIView.animate(withDuration: duration,
                       delay: TimeInterval(0),
                       options: animationCurve,
                       animations: { [weak self] in
                        if let self = self{
                            self.view.layoutIfNeeded()
                        }
            },
                       completion: { (_) in
        })
    }
    
    @objc func kbWillHide(_ notification: Notification){
        let userInfo = notification.userInfo!
        let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
        
        tableViewHistory.contentInset = .zero
        tableViewResults.contentInset = .zero
        
        UIView.animate(withDuration: duration,
                       delay: TimeInterval(0),
                       options: animationCurve,
                       animations: { [weak self] in
                        if let self = self{
                            self.view.layoutIfNeeded()
                        }
            },
                       completion: { (_) in
        })
    }
    
    func removeNotificationKeyBoard(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
}

//MARK:- TableView
extension SearchPlacesViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tableViewHistory{
            return 1
        }
        return viewModel.section()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableViewHistory{
            return viewModel.historySearch.value.count
        }else{
            return viewModel.numberOfRow(section: section)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableViewHistory{
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HistorySearchTableViewCell.self)) as! HistorySearchTableViewCell
            cell.title.text = viewModel.historySearch.value[indexPath.row].text
            return cell
        }else{
             let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ResultSearchTableViewCell.self)) as! ResultSearchTableViewCell
            cell.dataResultSearch = viewModel.cellForRow(at: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableViewResults{
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: String(describing: ResultSearchViewController.self), sender: self.viewModel.didSelect(at: indexPath))
            }
        }
    }
    
}
