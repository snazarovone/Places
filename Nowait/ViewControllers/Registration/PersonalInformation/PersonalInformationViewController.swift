//
//  PersonalInformationViewController.swift
//  Nowait
//
//  Created by Sergey Nazarov on 01.06.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Photos
import SwiftOverlays
import SDWebImage

class PersonalInformationViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var changeBtn: UIButton!
    @IBOutlet weak var photoBtn: UIButton!
    @IBOutlet weak var photoImg: DesignableUIImageView!
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var birthBtn: UIButton!
    
    @IBOutlet weak var viewPicker: DesignableUIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var bottomConstPicView: NSLayoutConstraint!
    
    //PRIVATE
    private var isEdit = false
    private let disposeBag = DisposeBag()
    
    private var tap: UITapGestureRecognizer!
    
    private let hideConst: CGFloat = -305
    private let showConst: CGFloat = -25
    
    private let imagePicker = UIImagePickerController()
    private let cameraPicker = UIImagePickerController()
    
    private let personalInfoViewModel = PersonalInformationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribe()
        
        //datePicker
        bottomConstPicView.constant = hideConst
        viewPicker.shadowOpacity = 0.0
        limitPickerView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configKeyboard()
        
    }
    
    private func subscribe(){
        personalInfoViewModel.userInfo.asObservable().subscribe(onNext: { [weak self] (user) in
            self?.setDataInFields(at: user)
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        personalInfoViewModel.imageUser.skip(1).asObservable().subscribe(onNext: { [weak self] (img) in
            if img != nil{
                self?.photoImg.contentMode = .scaleAspectFill
                self?.photoImg.image = img
            }else{
                self?.photoImg.contentMode = .center
                self?.photoImg.image = #imageLiteral(resourceName: "Icon photo.png")
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    //MARK:- Helpers
    private func editing(){
        isEdit = true
        changeBtn.setTitle("Сохранить", for: .normal)
        birthBtn.isEnabled = true
        photoBtn.isEnabled = true
    }
    
    private func save(){
        isEdit = false
        changeBtn.setTitle("Редактировать", for: .normal)
        birthBtn.isEnabled = false
        photoBtn.isEnabled = false
    }
    
    private func fieldsEdit(){
        for f in textFields{
            if f.tag != EditFields.birthday.tag{
                f.isEnabled = isEdit
            }
        }
    }
    
    private func setDataInFields(at user: UserInfo?){
        for field in EditFields.allCases{
            switch field {
            case .name:
                self.textFields[field.tag].text = user?.name
            case .lastName:
                self.textFields[field.tag].text = user?.last_name
            case .birthday:
                self.textFields[field.tag].text = user?.birth_date
            case .email:
                self.textFields[field.tag].text = user?.email
            case .phone:
                self.textFields[field.tag].text = user?.phone
            }
        }
        
        if let img = user?.image, let urlImage = URL(string: "\(img)"){
            DispatchQueue.main.async {
                SDWebImageManager.shared.loadImage(with: urlImage, options: .highPriority, progress: nil) { [weak self]
                    (image, data, error, cacheType, isFinished, imageUrl) in
                    self?.personalInfoViewModel.imageUser.accept(image)
                }
            }
        }
        
        personalInfoViewModel.setFields()
    }
    
    private func showHidePickerView(){
        let position = bottomConstPicView.constant
        let newPosition: CGFloat
        let shadowOpacity: Float
     
        if position == hideConst{
            newPosition = showConst
            shadowOpacity = 0.8
        }else{
            newPosition = hideConst
            shadowOpacity = 0.0
        }
        
        bottomConstPicView.constant = newPosition
        UIView.animate(withDuration: 0.6, animations: {
            self.viewPicker.shadowOpacity = shadowOpacity
            self.view.layoutIfNeeded()
        }) { (_) in
            self.viewPicker.shakeVerticle()
        }
        
        textFields[EditFields.birthday.tag].text = personalInfoViewModel.getDateInFormat(date: datePicker.date)
    }
    
    private func limitPickerView(){
        let calendar = Calendar.current
        let maxDateComponent = calendar.dateComponents([.day,.month,.year], from: Date())
        let maxDate = calendar.date(from: maxDateComponent)
        datePicker.maximumDate =  maxDate! as Date
    }
    
    private func alertSheetCameraOrLib(){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let actionCameraTitle = "Камера"
        let actionPhotoTitle = "Галерея"
        let actionRemovePhoto = "Удалить фото"
        let cancelTitle = "Отмена"
        
        let actionCamera = UIAlertAction(title: actionCameraTitle, style: .default) { [weak self] (_) in
            self?.openCamera()
        }
        
        let actionPhoto = UIAlertAction(title: actionPhotoTitle, style: .default) { [weak self] (_) in
            self?.setupPockerVC()
        }
        
        let actionRemove = UIAlertAction(title: actionRemovePhoto, style: .destructive) { [weak self] (_) in
            //удалить фото
            self?.personalInfoViewModel.imageUser.accept(nil)
        }
        
        
        let actionCancel = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
        
        alert.addAction(actionCamera)
        alert.addAction(actionPhoto)
        alert.addAction(actionRemove)
        alert.addAction(actionCancel)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //MARK:- Alert
    private func showAlert(message: String, title: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "ОК", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK:- Request
    private func requestUpdateUser(){
        SwiftOverlays.showBlockingWaitOverlay()
        personalInfoViewModel.requestUpdateUserInfo { [weak self] (resultResponce, error) in
            SwiftOverlays.removeAllBlockingOverlays()
            switch resultResponce{
            case .success:
                break
            case .fail:
                if let e = error{
                    switch e {
                    case .unknow(let title, let message):
                        self?.showAlert(message: message ?? "", title: title ?? "")
                    default:
                        self?.showAlert(message: "", title: e.value)
                    }
                }
            }
        }
    }
    
    //MARK:- Actions
    @IBAction func back(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func change(_ sender: UIButton){
        if isEdit == false{
            editing()
        }else{
            save()
            requestUpdateUser()
        }
        fieldsEdit()
    }
    
    @IBAction func selectPhoto(_ sender: Any) {
        alertSheetCameraOrLib()
    }
    
    @IBAction func selectBirthday(_ sender: Any) {
        dismissKeyboard()
        showHidePickerView()
    }
    
    @IBAction func doneDate(_ sender: UIButton) {
        dismissKeyboard()
        showHidePickerView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dismissKeyboard()
        removeNotificationKeyBoard()
    }
    
    //MARK:- deinit
    deinit {
        print("PersonalInformationViewController is deinit")
    }
}


//MARK:- TextField
extension PersonalInformationViewController: UITextFieldDelegate{
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
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tap.isEnabled = true
        checkValidation()
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkValidation()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag + 1 != EditFields.birthday.tag{
            if textField.tag + 1 < textFields.count{
                textFields[textField.tag + 1].becomeFirstResponder()
            }else{
                dismissKeyboard()
            }
        }else{
            //open select date picker
            dismissKeyboard()
            showHidePickerView()
        }
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard var currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return true}
        
        currentText = currentText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if textField.tag != EditFields.phone.tag{
            personalInfoViewModel.fields[textField.tag] = currentText
        }else{
            currentText = personalInfoViewModel.formattedNumber(number: currentText) ?? ""
        }
        textField.text = currentText
        
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

//MARK:- Image Picker
extension PersonalInformationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    private func setupPockerVC(){
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = ["public.image"]
        imagePicker.delegate = self
        checkPermission()
    }
    
    private func openCamera(){
        cameraPicker.delegate = self
        cameraPicker.allowsEditing = true
        cameraPicker.sourceType = .camera
        cameraPicker.cameraCaptureMode = .photo
        
        present(cameraPicker, animated: true)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            personalInfoViewModel.imageUser.accept(pickedImage)
        }
        dismiss(animated: true) {
        }
    }
    
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
            self.present(imagePicker, animated: true, completion: nil)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            // same same
            print("User do not have access to photo album.")
        case .denied:
            openPermission()
            
        @unknown default:
            print("unknow ndefault")
        }
    }
    
    private func openPermission(){
        let warning = "Предупреждение"
        let message = "Пользователь запретил доступ к библиотеке фотографий, разрешить?"
        let actionYesTitle = "Да"
        let actionNoTitle = "Нет"
        
        let alert = UIAlertController(title: warning, message: message, preferredStyle: .alert)
        let actionYes = UIAlertAction(title: actionYesTitle, style: .default) { (_) in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        }
        
        let actionNo = UIAlertAction(title: actionNoTitle, style: .cancel, handler: nil)
        alert.addAction(actionNo)
        alert.addAction(actionYes)
        self.present(alert, animated: true, completion: nil)
    }
    
}
