//
//  WeatherRequester.swift
//  Weather
//
//  Created by Stephan Howey on 10.06.23.
//

import Foundation
import CoreLocation

enum WeatherRequestError: Error {
    case networkError(Error)
    case urlConstructionFailure
}

protocol WeatherSourcing {
    func currentWeather(for location: CLLocationCoordinate2D) async -> Result<WeatherResponseModel, WeatherRequestError>
}

class WeatherRequester {
    
    private let urlRequester: URLRequesting
    
    init(urlRequester: URLRequesting) {
        self.urlRequester = urlRequester
    }
}

extension WeatherRequester: WeatherSourcing {
    
    func currentWeather(for location: CLLocationCoordinate2D) async -> Result<WeatherResponseModel, WeatherRequestError> {
        
        guard let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=\(location.latitude)&longitude=\(location.longitude)&hourly=temperature_2m&current_weather=true") else {
            
            return .failure(.urlConstructionFailure)
        }
        
        let request = URLRequest(url: url)

        do {
            let result: WeatherResponseModel = try await urlRequester.result(from: request)
            return .success(result)
        } catch {
            return .failure(.networkError(error))
        }
    }
}
