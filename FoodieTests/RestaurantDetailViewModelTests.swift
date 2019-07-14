//
//  RestaurantDetailViewModelTests.swift
//  FoodieTests
//
//  Created by parul vats on 13/07/2019.
//  Copyright © 2019 SmartSum. All rights reserved.
//

import XCTest
import CoreLocation
@testable import Foodie

class RestaurantDetailViewModelTests: XCTestCase {

    var sut: RestaurantDetailViewModel!
    var mockAPIService: MockApiService!
    let location = CLLocation(latitude: 52.304145, longitude: 4.86029474)
    
    override func setUp() {
        super.setUp()
        mockAPIService = MockApiService()
        
        let mylocation = Location(formattedAddress: [""], latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let restaurantBaseInfo = Restaurant(id: "12121212", name: "Parul's Restro", location: mylocation)
        sut = RestaurantDetailViewModel(restaurant: restaurantBaseInfo, apiService: mockAPIService)
    }
    
    override func tearDown() {
        sut = nil
        mockAPIService = nil
        super.tearDown()
    }
    
    func testFetchRestaurantDetails() {
        // Given
        mockAPIService.completeRestaurantDetails = sut.restaurantDetail
        
        // When
        sut.fetchRestaurantDetail(sut.restaurantDetail.id)
        
        // Assert
        XCTAssert(mockAPIService.isFetchRestaurantDetailsCalled)
    }
    
    func testFetchRestaurantDetailsError() {
        
        // Given a failed fetch with a certain failure
        let error = APIError.permissionDenied
        
        // When
        sut.fetchRestaurantDetail(sut.restaurantDetail.id)
        
        mockAPIService.fetchRestaurantDetailsFail(error: error )
        
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
        sut.fetchRestaurantDetail(sut.restaurantDetail.id)
        
        // Assert
        XCTAssertTrue(loadingStatus)
        
        // When finished fetching
        mockAPIService!.fetchRestaurantDetailsSuccess()
        XCTAssertFalse(loadingStatus )
        
        wait(for: [expect], timeout: 1.0)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
