//
//  CurrentWeatherView.swift
//  Weather
//
//  Created by Stephan Howey on 10.06.23.
//

import SwiftUI

struct CurrentWeatherView: View {
    
    @ObservedObject var viewModel: WeatherViewModel
    
    var body: some View {
        
        if viewModel.state == .hasData {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                
                if let weather = viewModel.currentWeather {
                    Text("\(weather.currentWeather.temperature)")
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
        
        CurrentWeatherView(viewModel: WeatherViewModel(locationManager: LocationManager(), requester: WeatherRequester(urlRequester: URLRequester())))
    }
}
