//
//  MapSearchViewController.swift
//  Nowait
//
//  Created by Sergey Nazarov on 20.07.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import UIKit
import GoogleMaps
import UPCarouselFlowLayout

class MapSearchViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var bottomSpace: NSLayoutConstraint!
    @IBOutlet weak var searchBtn: DesignableUIButton!
    
    //PRIVATE
    private var locationManager = CLLocationManager()
    
    private var startPositionView: CGFloat = 0.0
    private var isShowCollection: Bool = true
    
    //PUBLIC
    public var viewModel: MapSearchViewModelType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMap()
        
        self.collectionview.register(UINib.init(nibName: String(describing: RSearchCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: RSearchCollectionViewCell.self))
        
        let layout = UPCarouselFlowLayout()
        layout.itemSize = CGSize(width: collectionview.frame.width - 32, height: 114)
        layout.scrollDirection = .horizontal
        layout.spacingMode = .fixed(spacing: 8)
        layout.sideItemScale = 1.0
        layout.sideItemAlpha = 1.0
        collectionview.collectionViewLayout = layout
        
        searchBtn.setTitle(viewModel.searchText ?? "", for: .normal)
    }
    
    //MARK:- Helpers
    private func setupMap(){
        mapView.delegate = self
        self.mapView.isMyLocationEnabled = true
        
        
        locationManager.delegate = self
        
        let markers = viewModel.createMarkers()
        
        for item in markers{
            item.map = mapView
        }
        
        if let camera = viewModel.getCameraMarker(){
            mapView.camera = camera
        }else{
            locationManager.startUpdatingLocation()
        }
        
    }
    
    //MARK:- Prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == String(describing: ShopViewController.self), let dvc = segue.destination as? ShopViewController{
            dvc.viewModel = ShopViewModel(placesModel: sender as! PlacesModel)
        }
    }
    
    //MARK:- Actions
    @IBAction func close(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func myLocation(_ sender: DesignableUIButton) {
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func panGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        switch sender.state {
        case .began:
            self.startPositionView = translation.y
        case .changed:
            if isShowCollection == true{
                if startPositionView - translation.y <= 0 && startPositionView - translation.y >= -94{
                    self.bottomSpace.constant = startPositionView - translation.y
                }else{
                    if startPositionView - translation.y >= 0{
                        self.bottomSpace.constant = 0.0
                    }else{
                        self.bottomSpace.constant = -94
                    }
                }
            }else{
                if startPositionView - translation.y >= 0.0 && startPositionView - translation.y <= 94{
                    self.bottomSpace.constant = -94 - startPositionView - translation.y
                }else{
                    if startPositionView - translation.y < 0{
                        self.bottomSpace.constant = -94
                    }else{
                        self.bottomSpace.constant = 0.0
                    }
                }
                print(startPositionView - translation.y)
            }
        default:
            if abs(self.bottomSpace.constant) > 47{
                self.bottomSpace.constant = -94
                isShowCollection = false
            }else{
                isShowCollection = true
                self.bottomSpace.constant = 0
            }
            UIView.animate(withDuration: 0.4) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @IBAction func list(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- deinit
    deinit {
        print("MapSearchViewController is deinit")
    }
    
}

//MARK:- Location Manager
extension MapSearchViewController: CLLocationManagerDelegate, GMSMapViewDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: location?.coordinate.latitude ?? 0.0, longitude: location?.coordinate.longitude ?? 0.0, zoom: 17.0)
        
        mapView.animate(to: camera)
        self.locationManager.stopUpdatingLocation()
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let index = marker.userData as? Int{
            if index < viewModel.numberOfRow(){
                DispatchQueue.main.async {
                    let indexPath = IndexPath(row: index, section: 0)
                    self.collectionview.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                }
            }
        }
        return true
    }
}

//MARK:- CollectionView
extension MapSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRow()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: RSearchCollectionViewCell.self), for: indexPath) as! RSearchCollectionViewCell
        cell.dataRSearch = viewModel.cellForRow(at: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let placeModel: PlacesModel = viewModel.didSelect(at: indexPath)
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: String(describing: ShopViewController.self), sender: placeModel)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionview{
            let pageIndex = round(scrollView.contentOffset.x/collectionview.bounds.width)
            if viewModel.currentItem?.row != Int(pageIndex){
                viewModel.currentItem = IndexPath(row: Int(pageIndex), section: 0)
                if let camera = viewModel.getCameraMarker(){
                    mapView.camera = camera
                }
            }
        }
    }
}

extension MapSearchViewController: PlaceDestanceUpdate{
    func updateData() {
        collectionview.reloadData()
    }
}
