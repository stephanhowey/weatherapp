//
//  LocationManagerTests.swift
//  WeatherTests
//
//  Created by Stephan Howey on 11.06.23.
//

import XCTest
import Combine
@testable import Weather

final class LocationManagerTests: XCTestCase {
    
    var locationManager: LocationManager!
    var cancellables: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        locationManager = LocationManager()
    }

    override func tearDownWithError() throws {
        locationManager = nil
    }

    func test10SecondDelivery() throws {
        
        let every10SecDelivery = expectation(description: "10 sec delivery of updates")
        
        locationManager.locationPublisher
            .map { _ in Date().timeIntervalSince1970 }
            .collect(2)
            .sink { timeIntervals in
                
                guard let first = timeIntervals.first,
                      let last = timeIntervals.last else {
                    XCTFail()
                    return
                }
                
                // timers are not exact in the milliseconds, we round the values for comparison
                let firstInSeconds = Int(first)
                let lastInSeconds = Int(last)
                guard lastInSeconds == firstInSeconds + 10 else {
                    XCTFail()
                    return
                }
                every10SecDelivery.fulfill()
            }
            .store(in: &cancellables)
        
        locationManager.startUpdatingLocation()
        
        wait(for: [every10SecDelivery], timeout: 15.0)
    }
}
