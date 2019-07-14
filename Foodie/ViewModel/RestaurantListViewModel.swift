//
//  RestaurantListViewModel.swift
//  Foodie
//
//  Created by parul vats on 13/07/2019.
//  Copyright © 2019 SmartSum. All rights reserved.
//

import Foundation
import CoreLocation

class RestaurantListViewModel {
    private let apiService: APIServiceProtocol
    
    private var restaurants: [Restaurant] = [Restaurant]() {
        didSet {
            self.reloadMapClosure?()
        }
    }
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var restaurantList: [Restaurant] {
        return restaurants
    }
    
    var reloadMapClosure: (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    init( apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    func fetchRestaurants(_ location: CLLocation, radius: Int) {
        self.isLoading = true
        apiService.fetchNearbyRestaurants(location: location, radius: radius) { [weak self] (restaurants, error) in
            self?.isLoading = false
            if let error = error {
                self?.alertMessage = error.localizedDescription
            } else {
                guard let restaurants = restaurants else {
                    return
                }
                self?.restaurants = restaurants
            }
        }
    }
}
