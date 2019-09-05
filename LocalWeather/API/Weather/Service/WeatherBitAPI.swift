//
//  WeatherBitAPI.swift
//  LocalWeather
//
//  Created by Ilya Rudometov on 02.09.2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import Foundation
import Moya

enum WeatherBitAPI {
    case current(lat: Double, long: Double)
}

extension WeatherBitAPI: TargetType {
    
    private var apiKey: String {
        return "7c4f963707a94800ad3169e1d79acd5d"
    }
    
    var baseURL: URL {
        return URL(string: "https://api.weatherbit.io/v2.0")!
    }
    
    var path: String {
        switch self {
        case .current:
            return "current"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .current:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case let .current(lat, long):
            var params = [String: String]()
            params["lat"] = String(format: "%.2f", lat)
            params["lon"] = String(format: "%.2f", long)
            params["key"] = apiKey
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    var sampleData: Data {
        switch self {
        case .current:
            return """
{"data":[{"rh":50,"pod":"d","lon":37.61,"pres":985.7,"timezone":"Europe/Moscow","ob_time":"2019-09-02 09:05","country_code":"RU","clouds":72,"ts":1567415100,"solar_rad":486.6,"state_code":"48","city_name":"Moscow","wind_spd":1.79,"last_ob_time":"2019-09-02T09:05:00","wind_cdir_full":"north","wind_cdir":"N","slp":999.9,"vis":5,"h_angle":0,"sunset":"16:22","dni":845.15,"dewpt":11.8,"snow":0,"uv":6.9664,"precip":0,"wind_dir":2,"sunrise":"02:36","ghi":659.17,"dhi":105.58,"aqi":86,"lat":55.74,"weather":{"icon":"c02d","code":"802","description":"Scattered clouds"},"datetime":"2019-09-02:09","temp":22.8,"station":"E8051","elev_angle":41.52,"app_temp":22.5}],"count":1}
""".data(using: .utf8)!
        }
    }
    
    var headers: [String: String]? {
        return ["Accept": "application/json"]
    }
}
