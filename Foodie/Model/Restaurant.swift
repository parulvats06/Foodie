//
//  Restaurant.swift
//  Foodie
//
//  Created by parul vats on 13/07/2019.
//  Copyright © 2019 SmartSum. All rights reserved.
//

import Foundation

struct Response: Codable {
    let response: Restaurants
}

struct Restaurants: Codable {
    let restaurants: [Restaurant]
    
    enum CodingKeys: String, CodingKey {
        case restaurants = "venues"
    }
}

struct Restaurant: Codable {
    let id: String
    let name: String
    let location: Location
}

struct Location: Codable {
    let formattedAddress: [String]
    let latitude: Double
    let longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lng"
        case formattedAddress
    }
}

struct Hours: Codable {
    let status: String
    let isOpen: Bool
}
