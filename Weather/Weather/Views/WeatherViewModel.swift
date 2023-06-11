//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Stephan Howey on 10.06.23.
//

import Foundation
import CoreLocation
import Combine

class WeatherViewModel: ObservableObject {
    
    enum LoadingState {
        case loading
        case hasData
    }
    
    @Published var currentWeather: WeatherResponseModel?
    @Published var state: LoadingState = .loading
        
    private enum CacheState {
        case downloading
        case cached(WeatherResponseModel)
    }
    private var cache: [String: CacheState] = [:]
    
    private let locationManager: LocationUpdating
    private let requester: WeatherSourcing
    private var cancellable: AnyCancellable?
    
    init(locationManager: LocationUpdating, requester: WeatherSourcing) {
        self.locationManager = locationManager
        self.requester = requester
    }
    
    func startUpdatingWeatherData() {
        
        cancellable = locationManager.locationPublisher
            .sink { [self] location in
                
                guard let cacheState = cache[location.description()] else {
                    cache[location.description()] = .downloading
                    downloadWeather(for: location)
                    return
                }
                
                switch cacheState {
                case .cached(let weatherData):
                    print("Use cached weather data for: " + location.description())
                    currentWeather = weatherData
                case .downloading:
                    break
                }
                
            }
        locationManager.startUpdatingLocation()
    }
    
    private func downloadWeather(for location: CLLocationCoordinate2D) {
        
        Task {
            let response = await requester.currentWeather(for: location)
            
            await MainActor.run {
                
                switch response {
                case .success(let model):
                    cache[location.description()] = .cached(model)
                    state = .hasData
                    currentWeather = model
                    print("Downloaded weather data for: " + location.description())
                    print(model.currentWeather)
                    
                case .failure(let error):
                    print("Download failed: " + error.localizedDescription)
                }
            }
        }
    }
}

extension CLLocationCoordinate2D {
    func description() -> String {
        "\(latitude) \(longitude)"
    }
}
