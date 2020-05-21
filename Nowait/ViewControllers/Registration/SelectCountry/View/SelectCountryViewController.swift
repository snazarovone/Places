//
//  SelectCountryViewController.swift
//  Nowait
//
//  Created by Sergey Nazarov on 18.05.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SelectCountryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTF: UITextField!
    
    //PUBLIC
    public var selectCountryViewModel: SelectCountryViewModel!
    
    //PRIVATE
    private var tap: UITapGestureRecognizer!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configKeyboard()
        subscribes()
    }
    
    private func subscribes(){
        selectCountryViewModel.searchCountry.asObservable().subscribe(onNext: { [weak self] (_) in
            self?.tableView.reloadData()
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    //MARK:- Actions
    @IBAction func close(_ sender: Any) {
        self.dismissKeyboard()
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- deinit
    deinit {
        print("SelectCountryViewController is deinit")
    }
}

//MARK:- TableView
extension SelectCountryViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectCountryViewModel.numberOfRow()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CountryTableViewCell.self)) as! CountryTableViewCell
        cell.dataCountry = selectCountryViewModel.cellForRow(at: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectCountryViewModel.didSelect(at: indexPath)
        DispatchQueue.main.async {
            self.dismissKeyboard()
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension SelectCountryViewController: UITextFieldDelegate{
    fileprivate func configKeyboard(){
        //dissmis keyboard
        tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.isEnabled = false
        
        //event свернуть клавиатуру если был тап в пустую область
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        tap.isEnabled = false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tap.isEnabled = true
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard var currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return true}
        
        currentText = currentText.trimmingCharacters(in: .whitespacesAndNewlines)
        selectCountryViewModel.searchField(at: currentText)
        
        return true
    }
}
