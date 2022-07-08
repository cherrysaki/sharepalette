//
//  LocationStateManager.swift
//  Original
//
//  Created by 神林沙希 on 2022/07/08.
//

import CoreLocation

// TODO: SingletonClass
// https://ticklecode.com/swiftsingleton/
class LocationStateManager : NSObject, CLLocationManagerDelegate {
    
    public static let shared = LocationStateManager()
    
    private let locationManager = CLLocationManager()
    
    public var lat = CLLocationDegrees()
    public var lon = CLLocationDegrees()
    
    private override init() {
        super.init()
        
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            lat = location.coordinate.latitude
            lon = location.coordinate.longitude
            print("Location update lat: \(lat), lon: \(lon)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
