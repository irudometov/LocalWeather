//
//  ColorScheme.swift
//  LocalWeather
//
//  Created by Ilya Rudometov on 05.09.2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import Foundation
import UIKit

struct ColorScheme {
    
    struct NavBar {
        let titleColor: UIColor
        let tintColor: UIColor
        let barTintColor: UIColor
        let backgroundColor: UIColor
    }

    struct View {
        let backgroundColor: UIColor
    }

    struct TableView {
        let backgroundColor: UIColor
        let cellTextColor: UIColor
        let cellBackgroundColor: UIColor
    }
    
    struct CurrentWeatherView {
        let textColor: UIColor
        let backgroundColor: UIColor
    }
    
    struct SegmentedControl {
        let tintColor: UIColor
    }
    
    let name: String
    let useDarkStatusBar: Bool
    let navBar: NavBar
    let view: View
    let tableView: TableView
    let currentWeatherView: CurrentWeatherView
    let segmentedControl: SegmentedControl
}

extension ColorScheme: CustomDebugStringConvertible {
    
    var debugDescription: String {
        return "\(type(of: self)): \(name)"
    }
}

extension ColorScheme {
 
    static let defaultTintColor = UIColor(rgb: "1682FB")
    
    static let `default` = ColorScheme(
        
        name: "Default",
        useDarkStatusBar: true,
        
        navBar: NavBar(titleColor: .darkText,
                       tintColor: defaultTintColor,
                       barTintColor: .white,
                       backgroundColor: .white),
        
        view: View(backgroundColor: .white),
        
        tableView: TableView(backgroundColor: .white,
                             cellTextColor: .darkText,
                             cellBackgroundColor: .white),
        
        currentWeatherView: CurrentWeatherView(textColor: .darkText,
                                               backgroundColor: UIColor(rgb: "EFEFF4")),
        
        segmentedControl: SegmentedControl(tintColor: defaultTintColor)
    )
}

extension ColorScheme {
    
    static let dark = ColorScheme(
        
        name: "Dark",
        useDarkStatusBar: false,
        
        navBar: NavBar(titleColor: .white,
                       tintColor: .white,
                       barTintColor: .darkText,
                       backgroundColor: .darkText),
        
        view: View(backgroundColor: .darkText),
        
        tableView: TableView(backgroundColor: .darkText,
                             cellTextColor: .white,
                             cellBackgroundColor: .darkText),
        
        currentWeatherView: CurrentWeatherView(textColor: .white,
                                               backgroundColor: .darkText),
        
        segmentedControl: SegmentedControl(tintColor: .green)
    )
}
