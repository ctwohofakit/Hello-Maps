//
//  Untitled.swift
//  Hello-Maps
//
//  Created by Kit Sitou on 9/10/26.
//

import Foundation
import CoreLocation
import Combine

final class LocationManager: NSObject, ObservableObject {

    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }

    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
}

extension LocationManager: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(
        _ manager: CLLocationManager
    ) {
        print("Authorization: \(manager.authorizationStatus)")
    }
}
