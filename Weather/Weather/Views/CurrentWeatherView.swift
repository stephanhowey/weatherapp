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
        
        VStack(spacing: 16.0) {
            Text(viewModel.temperatureSmiley)
                .font(.system(size: 72.0))
            
            Text(viewModel.temperatureText)
                .font(.system(size: 48.0, weight: .medium))
        }
        .padding(32.0)
        .animation(.easeInOut(duration: 1.0), value: viewModel.temperatureText)
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        CurrentWeatherView(viewModel: WeatherViewModel(locationManager: LocationManager(), requester: WeatherRequester(urlRequester: URLRequester())))
    }
}
