//
//  MainViewController.swift
//  LocalWeather
//
//  Created by Ilya Rudometov on 02.09.2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import MapKit
import UIKit
import SDWebImage

final class WeatherMapViewController: TypedViewController<WeatherMapViewModel> {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var weatherPlaceholderView: UIView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var settingsAlertStackView: UIStackView!
    
    // MARK: - View's life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationButtons()
        configureMapView()
        configureWeatherPlaceholderView()
        setStatusMessage(nil)
        settingsAlertStackView.isHidden = true // initially
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func applySkin() {
        super.applySkin()
        
        let colorScheme = Appearance.shared.colorScheme
        cityLabel.textColor = colorScheme.currentWeatherView.textColor
        temperatureLabel.textColor = colorScheme.currentWeatherView.textColor
        weatherPlaceholderView.backgroundColor = colorScheme.currentWeatherView.backgroundColor
    }
    
    // MARK: - Configure
    
    private func configureNavigationButtons() {
        
        navigationItem.backBarButtonItem = nil
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIView(frame: .zero))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Settings", comment: "Settings navigation bar button"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didTapSettings))
    }
    
    @objc
    private func didTapSettings() {
        viewModel.didTapSettings?()
    }
    
    private func configureMapView() {
        mapView.delegate = self
    }
    
    private func configureWeatherPlaceholderView() {
        weatherPlaceholderView.layer.cornerRadius = 8
        weatherPlaceholderView.layer.masksToBounds = true
    }
    
    // MARK: - Callbacks
    
    @IBAction
    func didTapGoToSettings(_ sender: Any) {
        viewModel.openSystemSettings()
    }

    // MARK: - IStateView
    
    override func displayData(for stateViewModel: IStateViewModel) {        
        super.displayData(for: stateViewModel)
        
        updateViewsVisibility()
        
        if let currentWeatherInfo = viewModel.currentWeather {
            bindCurrentWeatherInfo(currentWeatherInfo)
        } else {
            setStatusMessage(NSLocalizedString("No data available...", comment: "Default message when no current weather data is available to display."))
        }
    }
    
    override func displayLoadingView(for stateViewModel: IStateViewModel) {
        
        if viewModel.currentWeather == nil {
            setStatusMessage("Loading...")
        }
    }
    
    override func displayError(_ error: Error?, for stateViewModel: IStateViewModel) {
        setStatusMessage(error?.localizedDescription)
    }
    
    private func setStatusMessage(_ text: String?) {
        statusLabel.text = text
        updateViewsVisibility()
    }
    
    private func updateViewsVisibility() {
        
        let isLocationDisabled = viewModel.isLocationTrackingDisabled
        
        if isLocationDisabled {
            mapView.isHidden = true
            weatherPlaceholderView.isHidden = true
            settingsAlertStackView.isHidden = false
            return
        }
        
        let hasStatusMessage = statusLabel.text != nil
        
        mapView.isHidden = isLocationDisabled
        weatherPlaceholderView.isHidden = isLocationDisabled && !hasStatusMessage
        settingsAlertStackView.isHidden = !isLocationDisabled
        cityLabel.isHidden = hasStatusMessage
        temperatureLabel.isHidden = hasStatusMessage
        iconImageView.isHidden = hasStatusMessage
        statusLabel.isHidden = !hasStatusMessage
    }
}

extension WeatherMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !(annotation is MKUserLocation) else { return nil }
        
        let reuseId = "pin"
        
        if let existingView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) {
            existingView.annotation = annotation
            return existingView
        }
        
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        annotationView.isDraggable = true
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView,
                 annotationView view: MKAnnotationView,
                 didChange newState: MKAnnotationView.DragState,
                 fromOldState oldState: MKAnnotationView.DragState) {
        
        guard newState == .ending,
            let annotation = view.annotation else { return }
        
        viewModel.onPinCoordinateChanged(to: annotation.coordinate)
    }
}

extension WeatherMapViewController: ICurrentWeatherView {
    
    func displayPinOnMap(_ pin: MKAnnotation, in region: MKCoordinateRegion) {
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(pin)
        mapView.region = region
    }
    
    func bindCurrentWeatherInfo(_ currentWeatherInfo: CurrentWeatherInfo) {
        cityLabel.text = currentWeatherInfo.city
        temperatureLabel.text = currentWeatherInfo.localizedTemperatureString
        iconImageView.sd_setImage(with: currentWeatherInfo.iconURL, completed: nil)
        setStatusMessage(nil)
    }
}
