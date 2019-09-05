//
//  Appearance.swift
//  LocalWeather
//
//  Created by Ilya Rudometov on 05.09.2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import Foundation

final class Appearance {

    static let colorSchemeDidChangeNotification = Notification.Name("com.irudometov.notification.Appearance.colorSchemeDidChange")
    
    private (set) var colorScheme: ColorScheme {
        didSet {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Appearance.colorSchemeDidChangeNotification, object: self)
            }
        }
    }
    
    // MARK: - Singleton
    
    static let shared = Appearance()
    
    private init() {
        colorScheme = Appearance.detectColorScheme()
        subscribeForNotifications()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func subscribeForNotifications() {
        
        NotificationCenter.default.removeObserver(self,
                                                  name: .darkModeSettingChanged,
                                                  object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refreshColorScheme),
                                               name: .darkModeSettingChanged,
                                               object: nil)
    }
    
    private static func detectColorScheme() -> ColorScheme {
        return UserPreferences.shared.isDarkModeEnabled ? .dark : .default
    }

    @objc
    private func refreshColorScheme() {
        colorScheme = Appearance.detectColorScheme()
    }
}
