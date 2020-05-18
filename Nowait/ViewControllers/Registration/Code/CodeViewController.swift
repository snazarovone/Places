//
//  CodeViewController.swift
//  Nowait
//
//  Created by Sergey Nazarov on 18.05.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CodeViewController: UIViewController {
    
    @IBOutlet weak var bottomSendCodeConstraint: NSLayoutConstraint!
    @IBOutlet weak var phoneTtitle: UILabel!
    @IBOutlet var OTPTxtFields: [CodeTextField]!
    @IBOutlet var OTPViews: [DesignableUIView]!
    @IBOutlet weak var invalidCodeMessage: UILabel!
    
    //PRIVATE
    private var tap: UITapGestureRecognizer!
    private let disposeBag = DisposeBag()
    
    //PUBLIC
    public var codeViewModel: CodeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPhoneNumber()
        configKeyboard()
        invalidCodeMessage.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        OTPTxtFields.forEach {
            $0.myTextFieldDelegate = self
        }
        OTPTxtFields.first?.becomeFirstResponder()
    }

    
    //MARK:- Helpers
    private func setPhoneNumber(){
        let text = "Введите 4-значный код,\nотправленный на номер \(codeViewModel.phoneNumber)"
        
        let rangePhone = NSString(string: text).range(of: codeViewModel.phoneNumber, options: String.CompareOptions.caseInsensitive)
        let rangeFull = NSString(string: text).range(of: text, options: String.CompareOptions.caseInsensitive)
        

        let attributedString = NSMutableAttributedString(string: text)

        attributedString.addAttributes([NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.200000003, green: 0.200000003, blue: 0.200000003, alpha: 1),
                                        NSAttributedString.Key.font : UIFont.init(name: "SFProText-Regular", size: 17)!], range: rangeFull)
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.200000003, green: 0.200000003, blue: 0.200000003, alpha: 1),
                                        NSAttributedString.Key.font : UIFont.init(name: "SFProText-Light", size: 17)!], range: rangePhone)

        
        phoneTtitle.attributedText = attributedString
    }
    
    
    private func checkCode(){
        var texts:  [String] = []
        OTPTxtFields.forEach {  texts.append($0.text!)}
        let currentText = texts.reduce("", +)
        if currentText == codeViewModel.succsessCode{
            print("Success Code")
            OTPViews.forEach { (v) in
                v.borderC = .black
                v.backgroundColor = .clear
            }
            invalidCodeMessage.isHidden = true
        }else{
            invalidCode()
        }
    }
    
    private func invalidCode(){
        OTPViews.forEach { (v) in
            v.borderC = #colorLiteral(red: 0.9219999909, green: 0.3409999907, blue: 0.3409999907, alpha: 1)
            v.backgroundColor = #colorLiteral(red: 0.9219999909, green: 0.3409999907, blue: 0.3409999907, alpha: 0.1000000015)
            invalidCodeMessage.isHidden = false
        }
    }
    
    private func selectField(textField: UITextField){
        let tag = textField.tag
        invalidCodeMessage.isHidden = true
        OTPViews.forEach { (v) in
            if v.tag == tag{
                v.borderC = .black
                v.backgroundColor = .clear
            }else{
                v.borderC = #colorLiteral(red: 0.746999979, green: 0.746999979, blue: 0.746999979, alpha: 1)
                v.backgroundColor = .clear
            }
        }
    }
    
    //MARK:- Actions
    @IBAction func close(_ sender: Any) {
        dismissKeyboard()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func repeatSendCode(_ sender: Any) {
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dismissKeyboard()
        removeNotificationKeyBoard()
    }
    
    //MARK:- deinit
    deinit{
        print("CodeViewController is deinit")
    }
    
}

extension CodeViewController: UITextFieldDelegate, CodeTextFieldDelegate{
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
        selectField(textField: textField)
    }
    
    
    func textFieldDidEnterBackspace(_ textField: CodeTextField) {
        guard let index = OTPTxtFields.firstIndex(of: textField) else {
            return
        }
        
        if index > 0 {
            OTPTxtFields[index - 1].becomeFirstResponder()
            OTPTxtFields[index - 1].text = ""
        } else {
            view.endEditing(true)
        }
        
    }
    
    func callOTPValidate(){
        var texts:  [String] = []
        OTPTxtFields.forEach {  texts.append($0.text!)}
        sentOTPOption(currentText: texts.reduce("", +))
    }
    
    func  sentOTPOption(currentText: String)   {
        self.view.endEditing(true)
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var newString = ((textField.text)! as NSString).replacingCharacters(in: range, with: string)
        
        
        if newString.count < 2 && !newString.isEmpty {
            textFieldShouldReturnSingle(textField, newString : newString)
            //  return false
        }else{
            if newString.count == 2{
                newString = string
                textFieldShouldReturnSingle(textField, newString : newString)
            }
        }
        
        return newString.count < 2 || string == ""
    }
    
    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) || action == #selector(paste(_:)) {
            return false
        }
        
        return true
    }
    
    func textFieldShouldReturnSingle(_ textField: UITextField, newString : String)
    {
        let nextTag: Int = textField.tag + 1
        textField.text = newString
        let nextResponder: UIResponder? =         textField.superview?.superview?.viewWithTag(nextTag)?.subviews.first
        if let nextR = nextResponder
        {
            // Found next responder, so set it.
            nextR.becomeFirstResponder()
        }
        else
        {
            textField.resignFirstResponder()
            callOTPValidate()
        }
        
        var texts:  [String] = []
        OTPTxtFields.forEach {  texts.append($0.text!)}
        let currentText = texts.reduce("", +)
        if currentText.count == 4{
            checkCode()
        }
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

        bottomSendCodeConstraint.constant = keyboardFrame.size.height
        
        
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
        
        bottomSendCodeConstraint.constant = 0.0
        
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
