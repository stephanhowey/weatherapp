//
//  URLRequestingTests.swift
//  WeatherTests
//
//  Created by Stephan Howey on 10.06.23.
//

import XCTest
@testable import Weather

final class URLRequestingTests: XCTestCase {
    
    var urlRequester: URLRequesting!

    override func setUpWithError() throws {
        urlRequester = MockURLRequester(file: "WeatherResponse")
    }

    override func tearDownWithError() throws {
        urlRequester = nil
    }

    func testSuccessfulResponseModelDecoding() async throws {
        
        guard let url = URL(string: "https://api.open-meteo.com") else {
            XCTFail()
            return
        }
        
        let request = URLRequest(url: url)
        let response: WeatherResponseModel = try await urlRequester.result(from: request)
        XCTAssertTrue(response.hourly.temperature.count > 0)
    }
}
