//
//  LocalWeatherTests.swift
//  LocalWeatherTests
//
//  Created by Ilya Rudometov on 02.09.2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import XCTest
@testable import LocalWeather

final class LocalWeatherTests: XCTestCase {

    func testTemperature() {
        
        let targetCelcius = 16.0
        let targetFarenheit = 60.8
        let targetLocalizedCelcius = "16°"
        let targetLocalizedFarenheit = "61°"
        
        let one = Temperature(celcius: targetCelcius)
        let another = Temperature(farenheit: targetFarenheit)
        
        XCTAssert(one.celcius == targetCelcius, "one.celcius \(one.celcius) should be equal to \(targetCelcius)")
        XCTAssert(one.farenheit == targetFarenheit, "one.farenheit \(one.farenheit) should be equal to \(targetFarenheit)")
        
        XCTAssert(one.localizedString(for: .celcius) == targetLocalizedCelcius, "one.localizedString(for: .celcius) \(one.localizedString(for: .celcius)) should be equal to \(targetLocalizedCelcius)")
        XCTAssert(one.localizedString(for: .farenheit) == targetLocalizedFarenheit, "one.localizedString(for: .celcius) \(one.localizedString(for: .farenheit)) should be equal to \(targetLocalizedFarenheit)")
            
        XCTAssert(one.celcius == another.celcius)
        XCTAssert(one.farenheit == another.farenheit)
        
        XCTAssert(one.localizedString(for: .celcius) == another.localizedString(for: .celcius))
        XCTAssert(one.localizedString(for: .farenheit) == another.localizedString(for: .farenheit))
    }
}
