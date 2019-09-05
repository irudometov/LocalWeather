//
//  AppCoordinator.swift
//  LocalWeather
//
//  Created by Ilya Rudometov on 02.09.2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import UIKit

final class AppCoordinator: NavigatableCoordinator {
    
    private let window: UIWindow
    private let weatherService = WeatherBitAPIService()
    private let locationManager = LocationManager()
    private let appearance = Appearance.shared
    
    private var shouldRequestLocation: Bool {
        return !locationManager.isLocationTrackingAllowed &&
            locationManager.canRequestLocationTracking
    }
    
    // MARK: - init
    
    init(window: UIWindow) {
        self.window = window
        super.init()
        subscribeForAppearanceUpdates()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func start() {
        
        // Ask for the persmission to track the user's location
        // at the first time.
        
        applySkin()
        
        if shouldRequestLocation {
            askForLocationTracking()
        } else {
            openWeatherMap()
        }
    }
    
    private func openWeatherMap() {
        
        let viewModel = WeatherMapViewModel(locationManager: locationManager,
                                            weatherService: weatherService)
        
        viewModel.didTapSettings = openSettings
        
        let mapViewController = WeatherMapViewController.newInstance(viewModel: viewModel, storyboardId: "weather-map")
        
        if navigationController.viewControllers.isEmpty {
            navigationController.viewControllers = [mapViewController]
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
            return
        }
        
        navigationController.pushViewController(mapViewController, animated: true)
    
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { [weak self] in
            guard let this = self else { return }
            
            var viewControllers = this.navigationController.viewControllers
            
            if let index = viewControllers.firstIndex(where: { $0 is EnableLocationViewController }) {
                viewControllers.remove(at: index)
            }
            
            self?.navigationController.viewControllers = viewControllers
        }
    }
    
    private func askForLocationTracking() {
        
        let viewModel = EnableLocationViewModel(locationManager: locationManager)
        viewModel.onFinish = { [weak self] isAccessGranted in
            self?.openWeatherMap()
        }
        
        let viewController = EnableLocationViewController.newInstance(viewModel: viewModel, storyboardId: "enable-location")
        
        navigationController.viewControllers = [viewController]
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    private func openSettings() {
        let coordinator = SettingsCoordinator(navigationController: navigationController)
        coordinate(to: coordinator)
    }
}

private extension AppCoordinator {
    
    func subscribeForAppearanceUpdates() {
        
        NotificationCenter.default.removeObserver(self,
                                                  name: Appearance.colorSchemeDidChangeNotification,
                                                  object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applySkin),
                                               name: Appearance.colorSchemeDidChangeNotification,
                                               object: nil)
    }
    
    @objc
    func applySkin() {
        
        // Apply navigation bar and view skin by default
        
        let colorScheme = Appearance.shared.colorScheme
        let navBar = navigationController.navigationBar
        
        navBar.tintColor = colorScheme.navBar.tintColor
        navBar.barTintColor = colorScheme.navBar.barTintColor
        navBar.backgroundColor = colorScheme.navBar.backgroundColor
        
        let textAttributes = [NSAttributedString.Key.foregroundColor: colorScheme.navBar.titleColor]
        navBar.titleTextAttributes = textAttributes
        
        // Status bar        
        navBar.barStyle = colorScheme.useDarkStatusBar ? .default : .black
    }
}
