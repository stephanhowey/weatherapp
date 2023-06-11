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
    
    private let locationManager: LocationUpdating
    private let urlRequester: URLRequesting
    private let weatherRequester: WeatherSourcing
    private let weatherViewModel: WeatherViewModel
    
    init() {
        locationManager = LocationManager()
        urlRequester = URLRequester()
        weatherRequester = WeatherRequester(urlRequester: urlRequester)
        weatherViewModel = WeatherViewModel(locationManager: locationManager, requester: weatherRequester)
    }
    
    var body: some Scene {
        WindowGroup {
            CurrentWeatherView(viewModel: weatherViewModel)
        }
        .onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .active:
//                locationManager.startUpdatingLocation()
                weatherViewModel.startUpdatingWeatherData()
                break
            case .background:
//                locationManager.stopUpdatingLocation()
                #warning("store date, calculate offset when becoming active again")
                break
            case .inactive:
//                locationManager.stopUpdatingLocation()
                break
            @unknown default:
                break
            }
        }
    }
}
