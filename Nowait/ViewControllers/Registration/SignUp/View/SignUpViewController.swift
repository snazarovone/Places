//
//  SignUpViewController.swift
//  Nowait
//
//  Created by Sergey Nazarov on 18.05.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import GoogleSignIn
import FBSDKCoreKit

class SignUpViewController: UIViewController {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var phoneView: DesignableUIView!
    @IBOutlet weak var placeholderPhone: UILabel!
    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var nextBtn: DesignableUIButton!
    
    //PUBLIC
    public var signUpViewModel: SignUpViewModel!
    
    //PRIVATE
    private var tap: UITapGestureRecognizer!
    private let disposeBag = DisposeBag()
    
    @available(iOS 13.0, *)
    private(set) lazy var appleAuth = AppleAuthService()
    
    private(set) lazy var googleAuth = GoogleAuthService()
    
    private(set) lazy var facebookAuth = FacebookAuthService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configKeyboard()
        subscribes()

        GIDSignIn.sharedInstance()?.presentingViewController = self

        // Automatically sign in the user.
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
        requestListCountry()
    }
    
    private func subscribes(){
        signUpViewModel.selectCountry.asObservable().subscribe(onNext: { [weak self] (country) in
            self?.countryLabel.text = country?.name
            self?.phoneNumberTF.text = self?.signUpViewModel.formattedNumber(number: "")
            self?.checkValidation()
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        signUpViewModel.country.asObservable().subscribe(onNext: { [weak self] (_) in
            self?.signUpViewModel.setSelectCountry()
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        if #available(iOS 13.0, *) {
            appleAuth.authResult.subscribe(onNext: { (value) in
                switch value {
                case .apple(let code, let name):
                    print("code:", code, "name:", name)
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        }
        
        
        googleAuth.googleAuthToken.subscribe(onNext: { [weak self] (info) in
            if info.userId != nil{
                self?.requestLoginGoogle(googleAuthToken: info)
            }else{
                self?.googleAuth.logout()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        facebookAuth.facebookAuthToken.subscribe(onNext: { [weak self] (facebookAuthToken) in
            if facebookAuthToken.accessToken?.userID != nil{
                self?.requestLoginFacabook(facebookAuthToken: facebookAuthToken)
            }else{
                self?.facebookAuth.logout()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dismissKeyboard()
        removeNotificationKeyBoard()
    }
    
    //MARK:- Alert
    private func showAlert(message: String, title: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "ОК", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK:- Request
    private func requestRegistration(){
        showWaitOverlay()
        view.isUserInteractionEnabled = false
        
        signUpViewModel.requestRegistrationAtPhone { [weak self] (resultResponce, baseResponseModel) in
           
            self?.removeAllOverlays()
            self?.view.isUserInteractionEnabled = true
            
            switch resultResponce{
            case .success:
                self?.performSegue(withIdentifier: String(describing: CodeViewController.self), sender: nil)
            case.fail:
                self?.showAlert(message: baseResponseModel?.message ?? "", title: baseResponseModel?.error ?? "")
            }
        }
    }
    
    private func requestListCountry(){
        showWaitOverlay()
        self.view.isUserInteractionEnabled = false
        signUpViewModel.requestListCountry { [weak self] (resultResponce, data) in
           
            self?.removeAllOverlays()
            self?.view.isUserInteractionEnabled = true
            
            switch resultResponce{
            case .success:
                break;
            case .fail:
                self?.showAlert(message: data?.message ?? "", title: data?.error ?? "")
            }
        }
    }
    
    private func requestLoginFacabook(facebookAuthToken: FacebookAuthToken){
        showWaitOverlay()
        self.view.isUserInteractionEnabled = false
        
        signUpViewModel.requestFacebookLogin(at: facebookAuthToken, callback: { [weak self] (resultResponce, tokenModel) in
            
            self?.removeAllOverlays()
            self?.view.isUserInteractionEnabled = true
            
            switch resultResponce{
            case .success:
                self?.dismiss(animated: true, completion: nil)
            case .fail:
                self?.showAlert(message: tokenModel?.message ?? "",
                               title: tokenModel?.error ?? "")
            }
        })
    }
    
    private func requestLoginGoogle(googleAuthToken: GoogleAuthToken){
        showWaitOverlay()
        self.view.isUserInteractionEnabled = false
        
        signUpViewModel.requestGoogleLogin(at: googleAuthToken, callback: { [weak self] (resultResponce, tokenModel) in
            
            self?.removeAllOverlays()
            self?.view.isUserInteractionEnabled = true
            
            switch resultResponce{
            case .success:
                self?.dismiss(animated: true, completion: nil)
            case .fail:
                self?.showAlert(message: tokenModel?.message ?? "",
                               title: tokenModel?.error ?? "")
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == String(describing: SelectCountryViewController.self){
            if let dvc = segue.destination as? SelectCountryViewController{
                dvc.selectCountryViewModel = SelectCountryViewModel(country: signUpViewModel.country, selectCountry: signUpViewModel.selectCountry)
            }
            return
        }
        
        if segue.identifier == String(describing: CodeViewController.self){
            if let dvc = segue.destination as? CodeViewController{
                dvc.codeViewModel = CodeViewModel(phoneNumber: signUpViewModel.currentTextPhoneTF, fullPhoneNumber: signUpViewModel.fullphone)
                
                dvc.isComplite = {
                    [weak self] in
                    self?.dismiss(animated: false, completion: nil)
                }
            }
            return
        }
    }
    
    //MARK:- Actions
    @IBAction func close(_ sender: Any) {
        dismissKeyboard()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectCountry(_ sender: Any) {
        dismissKeyboard()
    }
    
    @IBAction func next(_ sender: UIButton) {
        dismissKeyboard()
        requestRegistration()
    }
    
    //MARK:- apple
    @IBAction func appleID(_ sender: Any) {
        dismissKeyboard()
        if #available(iOS 13.0, *) {
            appleAuth.login()
        } else {
            return
        }
    }
    
    //MARK:- facebook
    @IBAction func facebook(_ sender: Any) {
        dismissKeyboard()
        facebookAuth.login(vc: self)
    }
    
    //MARK:- google
    @IBAction func google(_ sender: Any) {
        dismissKeyboard()
        googleAuth.login()
    }
    
    @IBAction func login(_ sender: UIButton) {
        dismissKeyboard()
    }
    
    //MARK:- deinit
    deinit {
        print("SignUpViewController is deinit")
    }
    
}

extension SignUpViewController: UITextFieldDelegate{
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

    private func checkValidation(){
        
        if signUpViewModel.currentTextPhoneTF.count == 0{
            placeholderPhone.isHidden = true
         
            if phoneNumberTF.isFirstResponder{
                phoneView.borderC = #colorLiteral(red: 0.200000003, green: 0.200000003, blue: 0.200000003, alpha: 1)

            }else{
                phoneView.borderC = #colorLiteral(red: 0.746999979, green: 0.746999979, blue: 0.746999979, alpha: 1)
            }
            phoneView.backgroundColor = .clear
            placeholderPhone.textColor = #colorLiteral(red: 0.5099999905, green: 0.5099999905, blue: 0.5099999905, alpha: 1)
            nextBtn.backgroundColor = #colorLiteral(red: 0.746999979, green: 0.746999979, blue: 0.746999979, alpha: 1)
            nextBtn.isUserInteractionEnabled = false
            
            return
        }else{
            placeholderPhone.isHidden = false
        }
        
        if signUpViewModel.isValidPhoneNumber == false{
            phoneView.borderC = #colorLiteral(red: 0.9219999909, green: 0.3409999907, blue: 0.3409999907, alpha: 1)
            phoneView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.3411764706, blue: 0.3411764706, alpha: 0.1)
            placeholderPhone.textColor = #colorLiteral(red: 0.9219999909, green: 0.3409999907, blue: 0.3409999907, alpha: 1)
            nextBtn.backgroundColor = #colorLiteral(red: 0.746999979, green: 0.746999979, blue: 0.746999979, alpha: 1)
            nextBtn.isUserInteractionEnabled = false
        }else{
            phoneView.borderC = #colorLiteral(red: 0.746999979, green: 0.746999979, blue: 0.746999979, alpha: 1)
            phoneView.backgroundColor = .clear
            placeholderPhone.textColor = #colorLiteral(red: 0.5099999905, green: 0.5099999905, blue: 0.5099999905, alpha: 1)
            nextBtn.backgroundColor = .black
            nextBtn.isUserInteractionEnabled = true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tap.isEnabled = true
        checkValidation()
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkValidation()
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard var currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return true}
            
        currentText = currentText.trimmingCharacters(in: .whitespacesAndNewlines)
        textField.text = signUpViewModel.formattedNumber(number: currentText)
       
        checkValidation()
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
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
        
        
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
        
        scrollView.contentOffset = CGPoint.zero
        scrollView.contentInset =  UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        
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
