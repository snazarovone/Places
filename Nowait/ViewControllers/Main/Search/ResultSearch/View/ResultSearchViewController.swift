//
//  ResultSearchViewController.swift
//  Nowait
//
//  Created by Sergey Nazarov on 16.07.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftOverlays
import MapKit

class ResultSearchViewController: BaseSearchViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightSearch: NSLayoutConstraint!
    @IBOutlet weak var iconSearchBtn: UIButton!
    @IBOutlet weak var topSort: NSLayoutConstraint!
    @IBOutlet weak var searchTextBtn: DesignableUIButton!
    
    //PUBLIC
    public var resultSearchViewModel: ResultSearchViewModelType!
    public weak var searchPlacesViewModel: SearchPlacesViewModelType?
    
    //PRIVATE
    private let locationManager = CLLocationManager()
    
    private weak var placeDestanceUpdate: PlaceDestanceUpdate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextBtn.setTitle(resultSearchViewModel.searchText, for: .normal)
        
        self.tableView.register(UINib.init(nibName: String(describing: RSearchTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: RSearchTableViewCell.self))
        
        setupUserLocation()
        subscribe()
        requestSearch()
    }
    
    private func subscribe(){
        resultSearchViewModel.resultSearch.asObservable().subscribe(onNext: { [weak self] (_) in
            self?.tableView.reloadData()
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
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
    
    //MARK:- Requests
    private func requestSearch(){
        SwiftOverlays.showBlockingWaitOverlay()
        resultSearchViewModel.requestSearchFinish { [weak self] (resultResponce, error) in
            
            SwiftOverlays.removeAllBlockingOverlays()
            
            switch resultResponce{
            case .success:
                //перезапрашиваем историю поиска
                self?.searchPlacesViewModel?.requestHistorySearch(callback: { (_, _) in
                })
            case .fail:
                self?.checkAuth(error: error)
            }
        }
    }
    
    //MARK:- Prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == String(describing: MapSearchViewController.self), let dvc = segue.destination as? MapSearchViewController{
            dvc.viewModel = MapSearchViewModel(resultSearch: resultSearchViewModel.resultSearch, searchText: resultSearchViewModel.searchText)
            self.placeDestanceUpdate = dvc
            return
        }
        
        if segue.identifier == String(describing: ShopViewController.self), let dvc = segue.destination as? ShopViewController{
            dvc.viewModel = ShopViewModel(placesModel: sender as! PlacesModel)
        }
    }
    
    //MARK:- Actions
    @IBAction func sortAction(_ sender: DesignableUIButton) {
    }
    
    @IBAction func filtersAction(_ sender: DesignableUIButton) {
    }
    
    @IBAction func mapAction(_ sender: DesignableUIButton) {
        self.performSegue(withIdentifier: String(describing: MapSearchViewController.self), sender: nil)
    }
    
    @IBAction func search(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- deinit
    deinit{
        print("ResultSearchViewController is deinit")
    }
    
}

extension ResultSearchViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultSearchViewModel.numberOfRow()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RSearchTableViewCell.self)) as! RSearchTableViewCell
        cell.dataRSearch = resultSearchViewModel.cellForRow(at: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let placeModel = resultSearchViewModel.didSelect(at: indexPath)
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: String(describing: ShopViewController.self), sender: placeModel)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 114.0
    }
    
}

//MARK:- Location Delegate
extension ResultSearchViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue = manager.location else { return }
        updateDistance(listCafe: resultSearchViewModel.resultSearch.value, myLocation: locValue)
        tableView.reloadData()
        placeDestanceUpdate?.updateData()
    }
}
