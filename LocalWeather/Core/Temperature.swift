//
//  Temperature.swift
//  LocalWeather
//
//  Created by Ilya Rudometov on 02.09.2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import Foundation

struct Temperature {
    
    let celcius: Double
    let farenheit: Double
    
    // MARK: - init
    
    init(celcius: Double) {
        self.celcius = celcius
        self.farenheit = (celcius * 9/5) + 32
    }
    
    init(farenheit: Double) {
        self.farenheit = farenheit
        self.celcius = (farenheit - 32) * 5/9
    }
}

extension Temperature {
    
    func localizedString(for unit: TemperatureUnit) -> String {
        
        var degrees: Int
        
        switch unit {
        case .celcius:
            degrees = Int(round(celcius))
        case .farenheit:
            degrees = Int(round(farenheit))
        }
        
        return "\(degrees)°"
    }
}
