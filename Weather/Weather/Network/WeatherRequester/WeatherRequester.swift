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

class WeatherRequester: URLRequesting {
    
    func currentWeather(for location: CLLocationCoordinate2D) async -> Result<CurrentWeatherResponseModel, WeatherRequestError> {
        
        guard let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=\(location.latitude)&longitude=\(location.longitude)&hourly=temperature_2m&current_weather=true") else {
            
            return .failure(.urlConstructionFailure)
        }
        
        let request = URLRequest(url: url)

        do {
            let result: CurrentWeatherResponseModel = try await result(from: request)
            return .success(result)
        } catch {
            return .failure(.networkError(error))
        }
    }
}
