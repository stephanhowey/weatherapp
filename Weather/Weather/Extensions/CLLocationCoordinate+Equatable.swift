//
//  CLLocationCoordinate+Equatable.swift
//  Weather
//
//  Created by Stephan Howey on 11.06.23.
//

import CoreLocation

extension CLLocationCoordinate2D: Equatable {
    
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.longitude &&
        lhs.latitude == rhs.longitude
    }
}
