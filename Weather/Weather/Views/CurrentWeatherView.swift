//
//  CurrentWeatherView.swift
//  Weather
//
//  Created by Stephan Howey on 10.06.23.
//

import SwiftUI

struct CurrentWeatherView: View {
    
    @ObservedObject var weatherDataManager: WeatherDataManager
    
    var body: some View {
        if weatherDataManager.state == .hasData {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                
                if let weather = weatherDataManager.currentWeather {
                    Text("\(weather.hourly.temperature.first!)")
                }
            }
            .padding()
        } else {
            Text("Loading weather data ...")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentWeatherView(weatherDataManager: WeatherDataManager(locationManager: LocationManager(), requester: WeatherRequester()))
    }
}
