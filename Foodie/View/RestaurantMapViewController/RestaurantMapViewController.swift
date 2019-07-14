//
//  RestaurantMapViewController.swift
//  Foodie
//
//  Created by parul vats on 13/07/2019.
//  Copyright © 2019 SmartSum. All rights reserved.
//

import UIKit
import MapKit

class RestaurantMapViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var restaurantMapView: MKMapView!
    
    // MARK: - Variables
    private var locationManager: LocationManager!
    private var apiService: APIServiceProtocol!
    private var lastLocation: CLLocation!
    
    lazy var restaurantViewModel: RestaurantListViewModel = {
        return RestaurantListViewModel(apiService: apiService)
    }()
    
    // MARK: - init
    init(locationManager: LocationManager, apiService: APIServiceProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.locationManager = locationManager
        self.apiService = apiService
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        self.restaurantMapView.delegate = self
        // Do any additional setup after loading the view.
        // bind view model
        bindViewModel()
    }
    
    func bindViewModel() {
        restaurantViewModel.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.restaurantViewModel.alertMessage {
                    self?.showAlert(title: "Alert", message: message)
                }
            }
        }
        
        restaurantViewModel.updateLoadingStatus = { [weak self] () in
            DispatchQueue.main.async {
                let isLoading = self?.restaurantViewModel.isLoading ?? false
                if isLoading {
                    self?.loadingActivityIndicator.startAnimating()
                }else {
                    self?.loadingActivityIndicator.stopAnimating()
                }
            }
        }
        
        restaurantViewModel.reloadMapClosure = { [weak self] () in
            DispatchQueue.main.async {
                //show restaurants on map
                self?.addRestaurantsOnMap()
            }
        }
    }
    
    // MARK: - internal private functions
    fileprivate func removeRestaurantsFromMap() {
        let allAnnotations = restaurantMapView.annotations
        for annotation in allAnnotations {
            restaurantMapView.removeAnnotation(annotation)
        }
    }
    
    fileprivate func addRestaurantsOnMap() {
        // first remove all the annotations if any
        removeRestaurantsFromMap()
        
        // add all the annotations if any
        let restaurants = restaurantViewModel.restaurantList
        for restaurant in restaurants {
            let annotation = FoodieAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: restaurant.location.latitude, longitude: restaurant.location.longitude)
            annotation.title = restaurant.name
            annotation.name = restaurant.name
            annotation.id = restaurant.id
            annotation.location = restaurant.location
            restaurantMapView.addAnnotation(annotation)
        }
    }
    
    fileprivate func showOnMap(location: CLLocation) {
        restaurantMapView.mapType = MKMapType.standard
        restaurantMapView.showsUserLocation = true
         let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        restaurantMapView.setRegion(region, animated: true)
    }
    
    fileprivate func fetchRestaurants() {
        // get the radius of the map visible on device
        let radius = lastLocation == nil ? Constants.Defaults.defaultRadius : restaurantMapView.currentRadius()
        restaurantViewModel.fetchRestaurants(lastLocation, radius: Int(radius))
    }
    
    // MARK: - IBoutlet functions
    @IBAction func currentLocationButtonPressed(_ sender: Any) {
        // start the location manager
        locationManager.startUpdatingLocation()
    }

}

// MARK: - extension LocationManager delegate
extension RestaurantMapViewController: LocationManagerDelegate {
    func didUpdateLocation(location: CLLocation) {
        // save battery : turn off the location
        self.locationManager.stopUpdatingLocation()
        if lastLocation == location {
            return
        }
       
        self.lastLocation = location
        // show user location on map
        showOnMap(location: location)
    }
    
    func locationServicesStatusUpdate(status: CLAuthorizationStatus) {
        // show alert
        if !self.locationManager.hasLocationPermission() {
            let alertController = UIAlertController(title: "Alert", message: "Please enable location permissions in settings.", preferredStyle: UIAlertController.Style.alert)
            
            let okAction = UIAlertAction(title: "Settings", style: .default, handler: {(cAlertAction) in
                //Redirect to Settings app
                UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
            alertController.addAction(cancelAction)
            
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

// MARK: - extension MKMapViewDelegate
extension RestaurantMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let annotation  = view.annotation as? MKPointAnnotation
        guard let customAnnotaion = annotation as? FoodieAnnotation else {
            return
        }
        // open new park list controller
        let restaurant = Restaurant(id: customAnnotaion.id, name: customAnnotaion.name, location: customAnnotaion.location)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let viewController = RestaurantDetailViewController(restaurant: restaurant, apiService: appDelegate.apiService)
        
        navigationController?.pushViewController(viewController, animated: true)
        // perform request to get restaurant detail and open new page
        mapView.deselectAnnotation(annotation, animated: false)
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        guard lastLocation != nil else {
            return
        }
        // get the new center location
        let centralLocation = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude:  mapView.centerCoordinate.longitude)
        self.lastLocation = centralLocation
        
        fetchRestaurants()
    }
}
