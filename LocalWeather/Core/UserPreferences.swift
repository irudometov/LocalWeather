//
//  UserPreferences.swift
//  LocalWeather
//
//  Created by Ilya Rudometov on 03.09.2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import Foundation

enum TemperatureUnit: String, CaseIterable {
    
    case celcius
    case farenheit
    
    var displayName: String {
        
        switch self {
        case .celcius:
            return "C°"
        case .farenheit:
            return "F°"
        }
    }
}

extension TemperatureUnit: Equatable {
    
    static func ==(lhs: TemperatureUnit, rhs: TemperatureUnit) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

extension Notification.Name {
    
    static let temperatureUnitChanged = Notification.Name(rawValue: "com.irudometov.LocalWeather.notification.temperatureUnitChanged")
    static let darkModeSettingChanged = Notification.Name(rawValue: "com.irudometov.LocalWeather.notification.darkModeSettingChanged")
}


/// Allows to store user's preferences in UserDefaults.

final class UserPreferences {
    
    private enum Keys: String, CaseIterable {
        
        static let prefix = "com.irudometov.LocalWeather.user-preferences"
        
        case temperatureUnit = "temperature-unit"
        case darkModeEnabled = "dark-mode-enabled"
        
        var value: String {
            return [Keys.prefix, rawValue].joined(separator: ".")
        }
    }
    
    static let shared = UserPreferences()
    private init() {}
    
    // MARK: - Temperature unit
    
    var temperatureUnit: TemperatureUnit {
        get {
            
            guard let string = UserDefaults.standard.string(forKey: Keys.temperatureUnit.value),
                let unit = TemperatureUnit(rawValue: string) else {
                    return .celcius
            }
            
            return unit
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: Keys.temperatureUnit.value)
        
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .temperatureUnitChanged, object: self)
            }
        }
    }
    
    // MARK: - Dark mode
    
    var isDarkModeEnabled: Bool {
        get {
            guard UserDefaults.standard.value(forKey: Keys.darkModeEnabled.value) != nil else {
                return true
            }
            return UserDefaults.standard.bool(forKey: Keys.darkModeEnabled.value)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.darkModeEnabled.value)
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .darkModeSettingChanged, object: self)
            }
        }
    }
}
