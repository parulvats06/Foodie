//
//  RestaurantDetailViewModel.swift
//  Foodie
//
//  Created by parul vats on 14/07/2019.
//  Copyright © 2019 SmartSum. All rights reserved.
//

import Foundation
import UIKit

class RestaurantDetailViewModel {
    private let apiService: APIServiceProtocol
    
    private var restaurant: RestaurantDetail? {
        didSet {
            self.loadRestaurantDetails?()
        }
    }
    private var restaurantBasicInfo: Restaurant
    
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
    
    var restaurantDetail: RestaurantDetail {
        return restaurant ?? RestaurantDetail(id: self.restaurantBasicInfo.id, name: self.restaurantBasicInfo.name, location: self.restaurantBasicInfo.location, url: "", description: "", rating: -1, hours: RestaurantHours(status: "", isOpen: false))
    }
    
    var loadRestaurantDetails: (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    init(restaurant: Restaurant, apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
        self.restaurantBasicInfo = restaurant
    }
    
    func fetchRestaurantDetail(_ id: String) {
        self.isLoading = true
        apiService.fetchRestaurantDetails(id: id) { [weak self] (restaurantDetail, error) in
            self?.isLoading = false
            if let error = error {
                self?.alertMessage = error.localizedDescription
            } else {
                guard let restaurantDetail = restaurantDetail else {
                    return
                }
                self?.restaurant = restaurantDetail
            }
        }
    }
    
    func getOpenCloseLabelData() -> (String, UIColor) {
        guard let hours = restaurantDetail.hours else {
            return ("", .black)
        }
        return hours.isOpen ? ("Open", UIColor.foodieGreen) : ("Closed", UIColor.foodieRed)
    }
    
    func getStatusLabelText() -> String {
        guard let hours = restaurantDetail.hours else {
            return "No status info available"
        }
        return hours.status
    }
    
    func getRatingText() -> String {
        guard let rating = restaurantDetail.rating else {
            return "No rating info available"
        }
        return String(rating)
    }
    
    func shouldHideRatingComparison() -> Bool {
        guard let _ = restaurantDetail.rating else {
            return true
        }
        return false
    }
    
    func getWebUrl() -> String {
        guard let url = restaurantDetail.url else {
            return "No web url available"
        }
        return String(url)
    }
    
    func getDescriptionText() -> String {
        guard let desc = restaurantDetail.description else {
            return ""
        }
        return desc
    }
    
    func getRestaurantAddress() -> String {
        var addressStr = ""
        for address in restaurantBasicInfo.location.formattedAddress {
            if !addressStr.isEmpty {
                addressStr = addressStr + " "
            }
            addressStr = addressStr + address
        }
        return addressStr
    }
}
