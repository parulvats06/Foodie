//
//  APIConfiguration.swift
//  Foodie
//
//  Created by parul vats on 13/07/2019.
//  Copyright © 2019 SmartSum. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation

protocol APIConfiguration: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters? { get }
}

enum Endpoint: APIConfiguration {
    
    case restaurants(location: CLLocation, radius: Int)
    case restaurantDetail(id: String)
    
    // MARK: - HTTPMethod
    var method: HTTPMethod {
        switch self {
        case .restaurants:
            return .get
        case .restaurantDetail:
            return .get
        }
    }
    
    // MARK: - Path
    var path: String {
        switch self {
        case .restaurants(let location, let radius):
            return "venues/search?ll=\(location.coordinate.latitude),\(location.coordinate.longitude)&radius=\(radius)&categoryId=\(Constants.Defaults.foodCategoryId)" + addAuthentication()
        case .restaurantDetail(let id):
            return "venues/\(id)?" + addAuthentication()
        }
    }
    
    // MARK: - Parameters
    var parameters: Parameters? {
        switch self {
        case .restaurants, .restaurantDetail:
            return nil
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        
        let base = URL(string: Constants.Defaults.baseUrl)!
        let baseAppend = base.appendingPathComponent(path).absoluteString.removingPercentEncoding
        
        let url = URL(string: baseAppend!)
        var urlRequest = URLRequest(url: url!)
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        // set header fields
        urlRequest.setValue(Constants.ContentType.json.rawValue,
                            forHTTPHeaderField: Constants.HTTPHeaderField.contentType.rawValue)
        urlRequest.setValue(Constants.ContentType.json.rawValue,
                            forHTTPHeaderField: Constants.HTTPHeaderField.acceptType.rawValue)
        
        // Parameters
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        
        return urlRequest
    }
    
    private func addAuthentication() -> String {
        let version = Date().string(with: "YYYYMMDD")
        return "&client_id=\(Constants.Auth.clientId)&client_secret=\(Constants.Auth.clientSecret)&v=\(version)"
    }
}

