//
//  WeatherMapViewModel.swift
//  LocalWeather
//
//  Created by Ilya Rudometov on 02.09.2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import Foundation
import MapKit
import Reachability

protocol ICurrentWeatherView: IStateView {
    
    func displayPinOnMap(_ pin: MKAnnotation, in region: MKCoordinateRegion)
    func bindCurrentWeatherInfo(_ currentWeatherInfo: CurrentWeatherInfo)
}

final class WeatherMapViewModel: StateViewModel {
    
    private let defaultCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.8, longitudeDelta: 1.2)
    
    private let reachability = Reachability()
    private let locationManager: LocationManager
    private let weatherService: IWeatherService
    private (set) var currentWeather: CurrentWeatherInfo?
    
    private var currentWeatherView: ICurrentWeatherView? {
        return view as? ICurrentWeatherView
    }
    
    override var navBarTitle: String? {
        return "Weather"
    }
    
    var isLocationTrackingDisabled: Bool {
        return !locationManager.isLocationTrackingAllowed
    }
    
    // MARK: - Callbacks
    
    var didTapSettings: (() -> Void)?
    
    // MARK: - Map view
    
    private var userLocation: CLLocation? {
        didSet {
            state = .initial
        }
    }
    
    // MARK: - init
    
    init(locationManager: LocationManager,
         weatherService: IWeatherService) {
        
        self.locationManager = locationManager
        self.weatherService = weatherService
        super.init()
        subscribeForNotifications()
        subscribeForReachabilityUpdates()
        configureLocationManager()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        reachability?.stopNotifier()
        locationManager.stopTrackingLocation()
    }

    // MARK: - Location manager

    private func configureLocationManager() {
        
        locationManager.onAuthStatusChanged = { [weak self] _ in
            self?.userLocation = nil
        }
    }
    
    // MARK: - Reachability
    
    private func subscribeForReachabilityUpdates() {
        
        guard let reachability = reachability else { return }
        
        reachability.whenReachable = { [weak self] _ in
            self?.state = .initial
        }
        
        try? reachability.startNotifier()
    }
    
    // MARK: - Notifications
    
    private func subscribeForNotifications() {
        
        NotificationCenter.default.removeObserver(self,
                                                  name: .temperatureUnitChanged,
                                                  object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onTemperatureUnitChanged),
                                               name: .temperatureUnitChanged,
                                               object: nil)
    }
    
    @objc
    private func onTemperatureUnitChanged() {
        guard let currentWeather = currentWeather else { return }
        currentWeatherView?.bindCurrentWeatherInfo(currentWeather)
    }
    
    func onPinCoordinateChanged(to newCoordinate: CLLocationCoordinate2D) {
        
        if let current = userLocation {
            guard current.coordinate.latitude != newCoordinate.latitude,
                current.coordinate.longitude != newCoordinate.longitude else { return }
        }
        
        userLocation = CLLocation(latitude: newCoordinate.latitude,
                                  longitude: newCoordinate.longitude)
    }
    
    func openSystemSettings() {
        URLHelper.openSystemSettings()
    }
    
    // MARK: - Overrides
    
    override func preloadData() {
        
        state = .loading
        
        guard let coordinate = userLocation?.coordinate else {
            startTrackingUserLocation()
            return
        }
        
        weatherService.getCurrentWeather(lat: coordinate.latitude,
                                         long: coordinate.longitude) { [weak self] result in
                                            
            guard let this = self else { return }
            
            switch result {
            case .success(let info):                
                this.currentWeather = CurrentWeatherInfo(city: info.city,
                                                         temperature: info.temperature,
                                                         iconURL: info.iconURL)
                this.state = .ready
                
            case .failure(let error):
                this.state = .error(lastError: error)
            }
        }
    }
    
    private func startTrackingUserLocation() {
        
        guard !isLocationTrackingDisabled else {
            state = .ready
            return
        }
        
        locationManager.onLocationUpdated = { [weak self] newLocation in
            guard let this = self else { return }
            this.locationManager.stopTrackingLocation()
            this.userLocation = newLocation
            this.dipslayUserLocationOnMap()
        }
        
        locationManager.startTrackingLocation()
    }
    
    private func dipslayUserLocationOnMap() {
        
        guard let userLocation = userLocation else { return }
        
        let pin = MKPointAnnotation()
        pin.coordinate = userLocation.coordinate
        let region = MKCoordinateRegion(center: pin.coordinate, span: defaultCoordinateSpan)
        
        currentWeatherView?.displayPinOnMap(pin, in: region)
    }
}
