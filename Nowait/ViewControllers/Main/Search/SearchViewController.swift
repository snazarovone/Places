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
    
    @IBOutlet weak var collectionViewNearest: UICollectionView!
    @IBOutlet weak var collectionViewBest: UICollectionView!
    @IBOutlet weak var nearestView: UIView!
    @IBOutlet weak var bestView: UIView!
    @IBOutlet weak var headerNearest: SearchViewHeader!
    @IBOutlet weak var headerBest: SearchViewHeader!
    @IBOutlet weak var stackView: UIStackView!
    
    private let locationManager = CLLocationManager()
    
    private var viewModel: SearchViewModelType = SearchViewModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscribes()
        self.requestPopularPlaces()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideNavigationBar()
    }
    
    private func subscribes(){
        viewModel.searchOffersNearest.asObservable().subscribe(onNext: { [weak self] (value) in
            if let self = self{
                if (value?.placesModel.count ?? 0) > 0{
                    self.headerNearest.title.text = self.viewModel.headerNearest
                    self.nearestView.showAnimated(in: self.stackView)
                }else{
                    self.nearestView.hideAnimated(in: self.stackView)
                }
                
                self.collectionViewNearest.reloadData()
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.searchOffersBest.asObservable().subscribe(onNext: { [weak self] (value) in
            if let self = self{
                if (value?.placesModel.count ?? 0) > 0{
                    self.headerBest.title.text = self.viewModel.headerBest
                    self.bestView.showAnimated(in: self.stackView)
                }else{
                    self.bestView.hideAnimated(in: self.stackView)
                }
                self.collectionViewBest.reloadData()
            }
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
                break;
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewNearest{
            print(viewModel.numberOfRowNearest(section: section))
            return viewModel.numberOfRowNearest(section: section)
        }
        return viewModel.numberOfRowBest(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SearchCollectionViewCell.self), for: indexPath) as! SearchCollectionViewCell
        
        if collectionView == collectionViewNearest{
            cell.dataSearch = viewModel.cellForRowNearest(at: indexPath)
        }else{
            cell.dataSearch = viewModel.cellForRowBest(at: indexPath)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150.0, height: collectionView.frame.height)
    }
}
