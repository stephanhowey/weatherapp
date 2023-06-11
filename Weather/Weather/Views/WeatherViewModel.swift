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
    
    @Published var temperatureSmiley: String = ""
    @Published var temperatureText: String = "Loading ..."
    
    @Published private var currentWeather: WeatherResponseModel? {
        didSet {
            guard let weather = currentWeather else { return }
            
            let temperature = weather.currentWeather.temperature
            temperatureText = "\(temperature) \(weather.hourlyUnits.temperature)"
            
            switch temperature {
            case _ where temperature < 1.0:
                temperatureSmiley = "⛄️"
            case 1.0..<8.0:
                temperatureSmiley = "🥶"
            case 8.0..<14.0:
                temperatureSmiley = "🧤"
            case 14.0..<20.0:
                temperatureSmiley = "😎"
            case 20.0...28.0:
                temperatureSmiley = "☀️"
            case _ where temperature > 28.0:
                temperatureSmiley = "🔥"
            default:
                temperatureSmiley = "🤷‍♂️"
            }
        }
    }
        
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
