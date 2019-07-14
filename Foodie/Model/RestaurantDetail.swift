//
//  RestaurantDetail.swift
//  Foodie
//
//  Created by parul vats on 14/07/2019.
//  Copyright © 2019 SmartSum. All rights reserved.
//

import Foundation


struct DetailResponse: Codable {
    let response: Venue
}

struct Venue: Codable {
    let venue: RestaurantDetail
}


struct RestaurantDetail: Codable {
    let id: String
    let name: String
    let location: Location
    let url: String?
    let description: String?
    let rating: Double?
    let hours: RestaurantHours?
}

struct RestaurantHours: Codable {
    let status: String
    let isOpen: Bool
}
