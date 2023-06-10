//
//  CurrentWeatherView.swift
//  Weather
//
//  Created by Stephan Howey on 10.06.23.
//

import SwiftUI

struct CurrentWeatherView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentWeatherView()
    }
}
