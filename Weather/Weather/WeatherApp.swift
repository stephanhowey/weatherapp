//
//  WeatherApp.swift
//  Weather
//
//  Created by Stephan Howey on 10.06.23.
//

import SwiftUI

@main
struct WeatherApp: App {
    
    @Environment(\.scenePhase) private var scenePhase
    
    private(set) var locationManager: LocationManager!
    private(set) var weatherRequester: WeatherRequester!
    private(set) var weatherDataManager: WeatherDataManager!
    
    init() {
        locationManager = LocationManager()
        weatherRequester = WeatherRequester()
        weatherDataManager = WeatherDataManager(locationManager: locationManager, requester: weatherRequester)
    }
    
    var body: some Scene {
        WindowGroup {
            CurrentWeatherView(weatherDataManager: weatherDataManager)
        }
        .onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .active:
                locationManager.startUpdatingLocation()
                weatherDataManager.startUpdatingWeatherData()
            case .background:
                locationManager.stopUpdatingLocation()
                #warning("store date, calculate offset when becoming active again")
                break
            case .inactive:
                locationManager.stopUpdatingLocation()
                break
            @unknown default:
                break
            }
        }
    }
}
