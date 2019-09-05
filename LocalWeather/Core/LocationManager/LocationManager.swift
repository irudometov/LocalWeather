//
//  LocationManager.swift
//  LocalWeather
//
//  Created by Ilya Rudometov on 05.09.2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

/// An app-specific wrapper for CLLocation manager class.

final class LocationManager: NSObject {
    
    private let minDistanceChangeToReact: Double = 100 // meters
    
    private let locationManager = CLLocationManager()
    private var lastKnownAuthStatus: CLAuthorizationStatus? {
        didSet {
            if let newStatus = lastKnownAuthStatus,
                newStatus != oldValue,
                newStatus != .notDetermined {
                
                currentLocation = nil
                onAuthStatusChanged?(self)
            }
        }
    }
    
    private (set) var currentLocation: CLLocation? {
        didSet {
            if let location = currentLocation {
                onLocationUpdated?(location)
            }
        }
    }
    
    var onAuthStatusChanged: ((LocationManager) -> Void)?
    var onLocationUpdated: ((CLLocation) -> Void)?
    
    // MARK: - init
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        subscribeForNotifications()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: - Notifications
    
    private func subscribeForNotifications() {
        
        NotificationCenter.default.removeObserver(self,
                                                  name: UIApplication.didBecomeActiveNotification,
                                                  object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onAppDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }
    
    @objc
    private func onAppDidBecomeActive() {
        
        // Here we have to check the current authorization status
        // in case it has just been changed by the user on Settings.
        
        lastKnownAuthStatus = CLLocationManager.authorizationStatus()
    }
    
    // MARK: - Public interface
    
    var isLocationTrackingAllowed: Bool {
        let currentStatus = CLLocationManager.authorizationStatus()
        return (currentStatus == .authorizedWhenInUse || currentStatus == .authorizedAlways)
    }
    
    var canRequestLocationTracking: Bool {
        return CLLocationManager.authorizationStatus() == .notDetermined
    }
    
    func startTrackingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopTrackingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: - Authorization
    // TODO: add a comment for this method
    
    func askForPermissionToTrackLocation() {
        guard canRequestLocationTracking else { return }
        locationManager.requestWhenInUseAuthorization()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status != .notDetermined else { return }
        lastKnownAuthStatus = status
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else { return }
        
        if let current = currentLocation {
            
            let distance = current.distance(from: location)
            
            if (distance < minDistanceChangeToReact) {
                return // skip this update
            }
        }
        
        currentLocation = location
    }
}
