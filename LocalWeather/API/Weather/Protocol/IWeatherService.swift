//
//  IWeatherService.swift
//  LocalWeather
//
//  Created by Ilya Rudometov on 02.09.2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import Foundation

protocol IWeatherService {
    
    func getCurrentWeather(lat: Double,
                           long: Double,
                           completion: @escaping ResultBlock<ICurrentWeatherInfo>)
    
    func getCurrentWeather(cityName: String,
                           completion: @escaping ResultBlock<ICurrentWeatherInfo>)
}
