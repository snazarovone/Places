//
//  SearchViewController.swift
//  Nowait
//
//  Created by Sergey Nazarov on 14.07.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa

class SearchViewController: BaseSearchViewController {
   
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let locationManager = CLLocationManager()
    
    private var viewModel: SearchViewModelType = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscribes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideNavigationBar()
    }
    
    private func subscribes(){
        viewModel.searchOffers.asObservable().subscribe(onNext: { [weak self] (_) in
            self?.collectionView.reloadData()
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.locValue = nil
        setupUserLocation()
        
        //MARK:- Permission
        switch(CLLocationManager.authorizationStatus()) {
        //check if services disallowed for this app particularly
        case .restricted, .denied:
            print("No access")
            DispatchQueue.main.async {
                self.openPermission()
            }
            
        //check if services are allowed for this app
        case .authorizedAlways, .authorizedWhenInUse:
            print("Access! We're good to go!")
        //check if we need to ask for access
        case .notDetermined:
            print("asking for access...")
        @unknown default:
            print("authorizationStatus is unknown")
        }
    }
    
    private func setupUserLocation(){
        // Ask for Authorisation from the User.
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            locationManager.requestWhenInUseAuthorization()
        }else{
            print("Location services are not enabled")
        }
        
    }
    
    private func openPermission(){
        let alert = UIAlertController(title: "Предупреждение", message: "Для корректной работы приложения необходимо разрешить доступ к геопозиции, разрешить?", preferredStyle: .alert)
        let actionYes = UIAlertAction(title: "Да", style: .default) { (_) in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        }
        
        let actionNo = UIAlertAction(title: "Нет", style: .cancel, handler: nil)
        alert.addAction(actionNo)
        alert.addAction(actionYes)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //MARK:- Requests
    private func requestNearestPlaces(){
        
        viewModel.requestNearbyOffer { [weak self] (resultResponce, error) in
            switch resultResponce{
            case .success:
                self?.requestPopularPlaces()
            case .fail:
                self?.checkAuth(error: error)
            }
        }
    }
    
    private func requestPopularPlaces(){
        viewModel.requestPopular { [weak self] (resultResponce, error) in
            switch resultResponce{
            case .success:
                break
            case .fail:
                self?.checkAuth(error: error)
            }
        }
    }
    
    
    //MARK:- Actions
    @IBAction func search(_ sender: DesignableUIButton) {
        performSegue(withIdentifier: String(describing: SearchPlacesViewController.self), sender: nil)
    }
    
    
    //MARK:- deinit
    deinit {
        print("SearchViewController is deinit")
    }
}

//MARK:- Location Delegate
extension SearchViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        if viewModel.locValue == nil{
            self.viewModel.locValue = locValue
            self.requestNearestPlaces()
        }
        
        self.locationManager.stopUpdatingLocation()
    }
}

//MARK:- CollectionView Delegate
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRow(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SearchCollectionViewCell.self), for: indexPath) as! SearchCollectionViewCell
        cell.dataSearch = viewModel.cellForRow(at: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150.0, height: 225.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 48.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: SearchHeaderCollectionReusableView.self), for: indexPath) as! SearchHeaderCollectionReusableView
            
            headerView.view.title.text = viewModel.header(at: indexPath)
            return headerView
        default:
            return  UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let w = ((viewModel.numberOfRow(section: section) * 150) + (15 * (viewModel.numberOfRow(section: section) - 1))) + 16
        var ww = Int(collectionView.frame.width) - w
        if ww < 16{
            ww = 16
        }
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: CGFloat(ww))
    }
}
