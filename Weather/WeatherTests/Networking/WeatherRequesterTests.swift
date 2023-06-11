//
//  WeatherRequesterTests.swift
//  WeatherTests
//
//  Created by Stephan Howey on 11.06.23.
//

import XCTest
import CoreLocation
@testable import Weather

final class WeatherRequesterTests: XCTestCase {
    
    var weatherRequester: WeatherRequester!

    override func setUpWithError() throws {
        weatherRequester = WeatherRequester(urlRequester: MockURLRequester(file: "WeatherResponse"))
    }

    override func tearDownWithError() throws {
        weatherRequester = nil
    }

    func testSuccessfulCurrentWeatherRequest() async throws {
        
        let result = await weatherRequester.currentWeather(for: CLLocationCoordinate2D(latitude: 52.0, longitude: 24.0))
        
        switch result {
        case .success(_):
            XCTAssert(true)
        default:
            XCTFail("Unexpected failure of ")
        }
    }
    
    func testErrorPropagationOnCurrentWeatherRequest() async throws {
        
        weatherRequester = WeatherRequester(urlRequester: MockURLRequester(file: "not a file"))
        
        let result = await weatherRequester.currentWeather(for: CLLocationCoordinate2D(latitude: 52.0, longitude: 24.0))
        
        switch result {
        case .success(_):
            XCTFail("Unexpected success")
            
        case .failure(let error):
            switch error {
            case .networkError(_):
                XCTAssert(true)
            default:
                XCTFail("Unexpected error enum case")
            }
        }
    }
}
