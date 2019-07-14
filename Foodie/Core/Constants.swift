//
//  Constants.swift
//  Foodie
//
//  Created by parul vats on 13/07/2019.
//  Copyright © 2019 SmartSum. All rights reserved.
//

import Foundation

struct Constants {
    
    struct Defaults {
        static let baseUrl = "https://api.foursquare.com/v2/"
        static let foodCategoryId = "4d4b7105d754a06374d81259"
        static let defaultRadius = 200.0// in meters
    }
    
    enum HTTPHeaderField: String {
        case authentication = "Authorization"
        case contentType = "Content-Type"
        case acceptType = "Accept"
        case acceptEncoding = "Accept-Encoding"
    }
    
    enum ContentType: String {
        case json = "application/json"
    }
    
    struct Auth {
        static let clientId = "CTK5VKFSEZJ5BDDYSQH04VHHTKBSLOYLA33PMUA4TOHZDPUF"
        static let clientSecret = "LFWMGCVEPXEJ4QDBFSAXAS2RDJW5HXGPRFMYPSSFUQC1QXKB"
    }
    
}

