//
//  CurrentWeatherInfo.swift
//  LocalWeather
//
//  Created by Ilya Rudometov on 02.09.2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import Foundation

/// Represents the current weather info for a particular location.

protocol ICurrentWeatherInfo {
    
    var city: String { get }
    var temperature: Temperature { get }
    
    var iconURL: URL? { get }
}
