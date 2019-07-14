//
//  RestaurantDetailViewControllerTests.swift
//  FoodieTests
//
//  Created by parul vats on 13/07/2019.
//  Copyright © 2019 SmartSum. All rights reserved.
//

import XCTest
import CoreLocation
@testable import Foodie

class RestaurantDetailViewControllerTests: XCTestCase {

    // MARK: - Window
    var window: UIWindow!
    var mockAPIService: MockApiService!
    var sut: RestaurantDetailViewController!
    let location = CLLocation(latitude: 52.304145, longitude: 4.86029474)
    
    override func setUp() {
        super.setUp()
        window = UIWindow()
        mockAPIService = MockApiService()
        let mylocation = Location(formattedAddress: [""], latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let restaurantBaseInfo = Restaurant(id: "12121212", name: "Parul's Restro", location: mylocation)
   //     restaurantDetailViewModel = RestaurantDetailViewModel(restaurant: restaurantBaseInfo, apiService: mockAPIService)
        sut = RestaurantDetailViewController(restaurant: restaurantBaseInfo, apiService: mockAPIService)
    }
    
    override func tearDown() {
        sut = nil
        mockAPIService = nil
        super.tearDown()
    }
    
    // MARK: - Test setup
    func loadView(_ view: UIView) {
        window.addSubview(view)
        RunLoop.current.run(until: Date())
    }

    func testFetchRestaurantDetailsUI() {
        // Given
        let mylocation = Location(formattedAddress: [""], latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let restaurantDetail = RestaurantDetail(id: "12121212", name: "Parul's Restro", location: mylocation, url: nil, description: nil, rating: nil, hours: nil)
        mockAPIService.completeRestaurantDetails = restaurantDetail
        loadView(sut.view)
        
        // When
        sut.viewDidLoad()
        
        // When finished fetching
        mockAPIService.fetchRestaurantDetailsSuccess()
        sut.updateDetails()
        // Assert all optional values
        XCTAssert(sut.restaurantDescription.text == "")
        XCTAssert(sut.webUrlTextView.text == "No web url available")
        XCTAssert(sut.restaurantName.text == "Parul's Restro")
        XCTAssert(sut.ratingLabel.text == "No rating info available")
        XCTAssert(sut.statusLabel.text == "No status info available")
        XCTAssert(sut.openCloseLabel.text == "")
    }
    
    func testOpenClosedLabelWhenClosed() {
        // Given
        let mylocation = Location(formattedAddress: [""], latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let hours = RestaurantHours(status: "open until 11:00", isOpen: false)
        let restaurantDetail = RestaurantDetail(id: "12121212", name: "Parul's Restro", location: mylocation, url: nil, description: nil, rating: nil, hours: hours)
        mockAPIService.completeRestaurantDetails = restaurantDetail
        loadView(sut.view)
        
        // When
        sut.viewDidLoad()
        
        // When finished fetching
        mockAPIService.fetchRestaurantDetailsSuccess()
        sut.updateDetails()
        XCTAssert(sut.openCloseLabel.textColor == UIColor.foodieRed)
        XCTAssert(sut.openCloseLabel.text == "Closed")
    }
    
    func testOpenClosedLabelWhenOpen() {
        // Given
        let mylocation = Location(formattedAddress: [""], latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let hours = RestaurantHours(status: "open until 11:00", isOpen: true)
        let restaurantDetail = RestaurantDetail(id: "12121212", name: "Parul's Restro", location: mylocation, url: nil, description: nil, rating: nil, hours: hours)
        mockAPIService.completeRestaurantDetails = restaurantDetail
        loadView(sut.view)
        
        // When
        sut.viewDidLoad()
        
        // When finished fetching
        mockAPIService.fetchRestaurantDetailsSuccess()
        sut.updateDetails()
        XCTAssert(sut.openCloseLabel.textColor == UIColor.foodieGreen)
        XCTAssert(sut.openCloseLabel.text == "Open")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
