//
//  HomePage.swift
//  MiniYelp
//
//  Created by Mong, Kyaw on 3/15/19.
//  Copyright © 2019 Mong, Kyaw. All rights reserved.
//

import UIKit
import CoreLocation

class HomePage: UIViewController {
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var googlePlaceGridList: UITableView!
    var places : [PlaceDetail] = []
    var selectedPlace : PlaceDetail?
    var recommender  = MiniYelpRecommender()
    var googlePlaceManager :  GooglePlaceManager!
    let locationManager = CLLocationManager()
    var userLocation : CLLocation = CLLocation.init()

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareViews()
        initializedGridView()
        googlePlaceManager = GooglePlaceManager(with: self)
        requestUserLocation()
        view.bringSubviewToFront(loadingIndicator)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true

    }
    

   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueIdentifier = segue.identifier else { return }
        switch segueIdentifier {
        case "showDetail":
            (segue.destination as? PlaceDetailPage)?.place = self.selectedPlace
        default:()
        }
    }
}


extension HomePage {
    fileprivate func prepareViews() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        self.navigationItem.searchController = search
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "profile"), style: .plain, target: self, action: #selector(presentUserDetail(_:)))

    }
    
    fileprivate func initializedGridView() {
        googlePlaceGridList.delegate = self
        googlePlaceGridList.dataSource = self
        googlePlaceGridList.estimatedRowHeight = 70
        googlePlaceGridList.rowHeight = UITableView.automaticDimension
        googlePlaceGridList.tableFooterView = UIView(frame: .zero)
    }
    

    @objc func presentUserDetail(_ sender : UIBarButtonItem) {
        self.performSegue(withIdentifier: "userDetail", sender: self)
        
    }
}

extension HomePage  : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.last else { return }
        self.userLocation = userLocation
        manager.stopUpdatingLocation()
        googlePlaceManager.getPlace(on: userLocation)
        
        print("\(userLocation.coordinate.latitude),\(userLocation.coordinate.longitude)")
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    private func requestUserLocation() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        switch CLLocationManager.authorizationStatus() {
        case .restricted:()
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .denied:()
        case .notDetermined:
            locationManager.requestLocation()
        }
        
    }
        
}

extension HomePage : GooglePlaceDelegate {
    func didCompleteGooglePlaceDetail(with place: [Place], and placeDetail: [PlaceDetail]) {
        self.places = placeDetail.sorted{$0.sentimentingRanking > $1.sentimentingRanking}
        self.loadingIndicator.stopAnimating()
        self.loadingIndicator.isHidden = true 
        self.googlePlaceGridList.reloadData()
        
    }
    
    func didCompleteGooglePlace(with error: Error) {
        // show error
    }
    
    
}

extension HomePage : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantItemCell", for: indexPath) as? RestaurantItemCell else { return UITableViewCell() }
        cell.config(with: self.places[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedPlace = self.places[indexPath.row]
        self.performSegue(withIdentifier: "showDetail", sender: self)
    }
  
}


extension HomePage : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let keyword = searchController.searchBar.text , keyword.count >= 3 else { return }
        self.places = []
        self.googlePlaceGridList.reloadData()
        loadingIndicator.startAnimating()
        loadingIndicator.isHidden = false
        googlePlaceManager.getPlace(with: keyword, on: self.userLocation)
    }
}


