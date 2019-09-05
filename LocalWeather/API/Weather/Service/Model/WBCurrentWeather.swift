//
//  WBCurrentWeather.swift
//  LocalWeather
//
//  Created by Ilya Rudometov on 02.09.2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import Foundation

struct WBCurrentWeather: ICurrentWeatherInfo {
    
    private let weather: WBWeatherCondition?
    
    var iconURL: URL? {
        guard let iconName = weather?.icon else { return nil }
        return URL(string: "https://www.weatherbit.io/static/img/icons/\(iconName).png")
    }

    let city: String
    
    private let tempC: Double
    var temperature: Temperature {
        return Temperature(celcius: tempC)
    }
}

extension WBCurrentWeather: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case city = "city_name"
        case tempC = "temp"
        case weather
    }
}

private struct WBWeatherCondition: Decodable {
    let icon: String
}

struct WBCurrentWeatherResponse: Decodable {
    
    let data: [WBCurrentWeather]
    let count: Int
}
