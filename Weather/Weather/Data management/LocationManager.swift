//
//  LocationManager.swift
//  Weather
//
//  Created by Stephan Howey on 10.06.23.
//

import Foundation
import CoreLocation
import Combine

class LocationManager {
    
    @Published var currentLocation: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    private let locations = [
        CLLocationCoordinate2D(latitude: 53.619653, longitude: 10.079969),
        CLLocationCoordinate2D(latitude: 53.080917, longitude: 8.847533),
        CLLocationCoordinate2D(latitude: 52.378385, longitude: 9.794862),
        CLLocationCoordinate2D(latitude: 52.496385, longitude: 13.444041),
        CLLocationCoordinate2D(latitude: 53.866865, longitude: 10.739542),
        CLLocationCoordinate2D(latitude: 54.304540, longitude: 10.152741),
        CLLocationCoordinate2D(latitude: 54.797277, longitude: 9.491039),
        CLLocationCoordinate2D(latitude: 52.426412, longitude: 10.821392),
        CLLocationCoordinate2D(latitude: 53.542788, longitude: 8.613462),
        CLLocationCoordinate2D(latitude: 53.141598, longitude: 8.242565)
    ]
    
    private let timer = Timer.publish(every: 10.0, on: .main, in: .common)
        .autoconnect()
    
    private var cancellable: AnyCancellable?
    private var currentIndex = 0
    
    func startUpdatingLocation() {
        self.currentLocation = self.locations[currentIndex]
        stopUpdatingLocation()
        cancellable = timer
            .sink { seconds in
                guard self.currentIndex < self.locations.count - 1 else {
                    self.currentIndex = 0
                    self.currentLocation = self.locations[0]
                    return
                }
                self.currentIndex += 1
                self.currentLocation = self.locations[self.currentIndex]
            }
    }
    
    func stopUpdatingLocation() {
        cancellable?.cancel()
        cancellable = nil
    }
}
