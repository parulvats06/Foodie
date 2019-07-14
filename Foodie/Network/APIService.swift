//
//  APIService.swift
//  Foodie
//
//  Created by parul vats on 13/07/2019.
//  Copyright © 2019 SmartSum. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire

enum APIError: String, Error {
    case noNetwork = "No Network"
    case serverOverload = "Server is overloaded"
    case permissionDenied = "You don't have permission"
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noNetwork:
            return NSLocalizedString("No Network", comment: "No Network")
        case .serverOverload:
            return NSLocalizedString("Server is overloaded", comment: "Server is overloaded")
        case .permissionDenied:
            return NSLocalizedString("You don't have permission", comment: "You don't have permission")
        }
    }
}

protocol APIServiceProtocol {
    func fetchNearbyRestaurants(location: CLLocation, radius: Int, completion: @escaping ([Restaurant]?, Error?) -> Void)
    func fetchRestaurantDetails(id: String, completion:@escaping (RestaurantDetail?, Error?) -> Void)
}

class APIService: APIServiceProtocol {
    
    func fetchNearbyRestaurants(location: CLLocation, radius: Int, completion:@escaping ([Restaurant]?, Error?) -> Void) {
        let url = Endpoint.restaurants(location: location, radius: radius)
        AF.request(url)
            .validate(statusCode: 200..<300)
            .responseData(completionHandler: { (response) in
            switch response.result {
                case .success:
                    do {
                        let results = try JSONDecoder().decode(Response.self, from: response.data!)
                        completion(results.response.restaurants, nil)
                    } catch let err {
                        print(err)
                    }
                case let .failure(error):
                    completion(nil, error)
                }
        })
    }
    
    func fetchRestaurantDetails(id: String, completion:@escaping (RestaurantDetail?, Error?) -> Void) {
        let url = Endpoint.restaurantDetail(id: id)
        AF.request(url)
            .validate(statusCode: 200..<300)
            .responseData(completionHandler: { (response) in
            switch response.result {
            case .success:
                do {
                    let results = try JSONDecoder().decode(DetailResponse.self, from: response.data!)
                    completion(results.response.venue, nil)
                } catch let err {
                    print(err)
                }
            case let .failure(error):
                guard let error = error as? AFError else {
                    return
                }
                completion(nil, error)
            }
        })
    }
}







