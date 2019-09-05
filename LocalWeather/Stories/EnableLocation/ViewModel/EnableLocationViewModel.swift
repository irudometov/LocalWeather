//
//  EnableLocationViewModel.swift
//  LocalWeather
//
//  Created by Ilya Rudometov on 04.09.2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import Foundation
import CoreLocation

final class EnableLocationViewModel: StateViewModel {
    
    private let locationManager: LocationManager
    
    var onFinish: ((_ isAccessGranted: Bool) -> Void)?
    
    // MARK: - init
    
    init(locationManager: LocationManager) {
        self.locationManager = locationManager
        super.init()
        self.subscribeForAuthStatusUpdates()
    }
    
    private func subscribeForAuthStatusUpdates() {
        
        locationManager.onAuthStatusChanged = { [weak self] manager in
            self?.notifyCompleted()
        }
    }
    
    private func notifyCompleted() {
        onFinish?(locationManager.isLocationTrackingAllowed)
    }
    
    // MARK: - Public interface
    
    func tryEnableLocation() {
        
        guard locationManager.canRequestLocationTracking else {
            notifyCompleted()
            return
        }
        
        locationManager.askForPermissionToTrackLocation()
    }
}
