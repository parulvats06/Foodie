//
//  RestaurantViewModelTests.swift
//  FoodieTests
//
//  Created by parul vats on 13/07/2019.
//  Copyright © 2019 SmartSum. All rights reserved.
//

import XCTest
import CoreLocation
@testable import Foodie

class RestaurantViewModelTests: XCTestCase {

    var sut: RestaurantListViewModel!
    var mockAPIService: MockApiService!
    let location = CLLocation(latitude: 52.304145, longitude: 4.86029474)
    
    override func setUp() {
        super.setUp()
        mockAPIService = MockApiService()
        sut = RestaurantListViewModel(apiService: mockAPIService)
    }
    
    override func tearDown() {
        sut = nil
        mockAPIService = nil
        super.tearDown()
    }

    func testFetchNearbyRestaurants() {
        // Given
        mockAPIService.completeNearbyRestaurants = [Restaurant]()
        
        // When
        sut.fetchRestaurants(location, radius: 200)
        
        // Assert
        XCTAssert(mockAPIService.isFetchNearbyRestaurantsCalled)
    }
    
    func testFetchNearbyRestaurantsError() {
        
        // Given a failed fetch with a certain failure
        let error = APIError.permissionDenied
        
        // When
        sut.fetchRestaurants(location, radius: 200)
        
        mockAPIService.fetchNearbyRestaurantsFail(error: error )
        
        // Sut should display predefined error message
        XCTAssertEqual( sut.alertMessage, error.rawValue )
        
    }
    
    func testLoadingWhileFetching() {
        //Given
        var loadingStatus = false
        let expect = XCTestExpectation(description: "Loading status updated")
        sut.updateLoadingStatus = { [weak sut] in
            loadingStatus = sut!.isLoading
            expect.fulfill()
        }
        
        //when fetching
        sut.fetchRestaurants(location, radius: 200)
        
        // Assert
        XCTAssertTrue(loadingStatus)
        
        // When finished fetching
        mockAPIService!.fetchNearbyRestaurantsSuccess()
        XCTAssertFalse(loadingStatus )
        
        wait(for: [expect], timeout: 1.0)
    }
}

class MockApiService: APIServiceProtocol {
    func fetchNearbyRestaurants(location: CLLocation, radius: Int, completion: @escaping ([Restaurant]?, Error?) -> Void) {
        isFetchNearbyRestaurantsCalled = true
        completeNearbyRestaurantsClosure = completion
    }
    
    func fetchRestaurantDetails(id: String, completion: @escaping (RestaurantDetail?, Error?) -> Void) {
        isFetchRestaurantDetailsCalled = true
        completeRestaurantDetailsClosure = completion
    }
    
    var isFetchNearbyRestaurantsCalled = false
    var isFetchRestaurantDetailsCalled = false
    
    var completeNearbyRestaurants: [Restaurant] = [Restaurant]()
    var completeNearbyRestaurantsClosure: (([Restaurant]?, Error?) -> ())!
    var completeRestaurantDetails: RestaurantDetail!
    var completeRestaurantDetailsClosure: ((RestaurantDetail?, Error?) -> ())!
    
    func fetchNearbyRestaurantsSuccess() {
        completeNearbyRestaurantsClosure(completeNearbyRestaurants, nil )
    }
    
    func fetchNearbyRestaurantsFail(error: Error?) {
        completeNearbyRestaurantsClosure(completeNearbyRestaurants, error )
    }
    
    func fetchRestaurantDetailsSuccess() {
        completeRestaurantDetailsClosure(completeRestaurantDetails, nil )
    }
    
    func fetchRestaurantDetailsFail(error: Error?) {
        completeRestaurantDetailsClosure(nil, error )
    }
    
}
