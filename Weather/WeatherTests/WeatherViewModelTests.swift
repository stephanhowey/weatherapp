//
//  WeatherViewModelTests.swift
//  WeatherTests
//
//  Created by Stephan Howey on 11.06.23.
//

import XCTest
import Combine
@testable import Weather

final class WeatherViewModelTests: XCTestCase {
    
    var viewModel: WeatherViewModel!
    var cancellables: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        viewModel = WeatherViewModel(locationManager: LocationManager(), requester: WeatherRequester(urlRequester: MockURLRequester(file: "WeatherResponse")))
    }

    override func tearDownWithError() throws {
        viewModel = nil
        cancellables.forEach { $0.cancel() }
        cancellables = []
    }

    func test1Delivery() throws {
        
        let stateChangeExpectation = expectation(description: "state shall change on first weather update")
        
        viewModel.$temperatureText
            .compactMap { $0 }
            .sink { _ in
                stateChangeExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.startUpdatingWeatherData()
        
        wait(for: [stateChangeExpectation], timeout: 1.0)
    }
    
    func test2Deliveries() throws {
        
        let expect2WeatherUpdate = expectation(description: "2 weather updates are expected within 11sec")
        
        viewModel.$temperatureSmiley
            .collect(2)
            .sink { _ in
                expect2WeatherUpdate.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.startUpdatingWeatherData()
        
        wait(for: [expect2WeatherUpdate], timeout: 11.0)
    }
}
