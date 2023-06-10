//
//  WeatherApp.swift
//  Weather
//
//  Created by Stephan Howey on 10.06.23.
//

import SwiftUI

@main
struct WeatherApp: App {
    
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
    }
}
