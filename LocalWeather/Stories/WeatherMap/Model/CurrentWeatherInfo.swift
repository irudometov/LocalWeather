//
//  CurrentWeatherInfo.swift
//  LocalWeather
//
//  Created by Ilya Rudometov on 02.09.2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import Foundation

struct CurrentWeatherInfo {
    
    let city: String
    let temperature: Temperature
    let iconURL: URL?
}

extension CurrentWeatherInfo {
    
    var localizedTemperatureString: String {
        return temperature.localizedString(for: UserPreferences.shared.temperatureUnit)
    }
}
