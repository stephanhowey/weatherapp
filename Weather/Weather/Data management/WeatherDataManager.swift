//
//  WeatherDataManager.swift
//  Weather
//
//  Created by Stephan Howey on 10.06.23.
//

import Foundation
import CoreLocation
import Combine
import SwiftUI

class WeatherDataManager: ObservableObject {
    
    enum LoadingState {
        case loading
        case hasData
    }
    
    @Published var currentWeather: CurrentWeatherResponseModel?
    @Published var state: LoadingState = .loading
        
    private var cache: [String: CurrentWeatherResponseModel] = [:]
    
    private let locationManager: LocationManager
    private let requester: WeatherRequester
    private var cancellable: AnyCancellable?
    
    init(locationManager: LocationManager, requester: WeatherRequester) {
        self.locationManager = locationManager
        self.requester = requester
    }
    
    func startUpdatingWeatherData() {
        cancellable = locationManager.$currentLocation
            .sink { [self] locationCoordinate in
                
                guard let cachedData = cache["\(locationCoordinate.latitude) \(locationCoordinate.longitude)"] else {
                    downloadWeather(for: locationCoordinate)
                    return
                }
                print("cached \(cachedData.currentWeather.temperature)")
                currentWeather = cachedData
                
            }        
        locationManager.startUpdatingLocation()
    }
    
    private func downloadWeather(for location: CLLocationCoordinate2D) {
        Task {
            let response = await requester.currentWeather(for: location)
            
            await MainActor.run {
                switch response {
                case .success(let model):
                    guard let cachedData = cache["\(location.latitude) \(location.longitude)"] else {
                        cache["\(location.latitude) \(location.longitude)"] = model
                        state = .hasData
                        currentWeather = model
                        print("downloaded \(model.currentWeather.temperature)")
                        return
                    }
                    currentWeather = cachedData
                    print("cached \(model.currentWeather.temperature)")
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
