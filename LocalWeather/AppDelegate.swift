//
//  AppDelegate.swift
//  LocalWeather
//
//  Created by Ilya Rudometov on 02.09.2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private var coordinator: AppCoordinator!

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        
        let keyWindow = window ?? UIWindow(frame: UIScreen.main.bounds)
        
        if window == nil {
            window = keyWindow
        }
        
        coordinator = AppCoordinator(window: keyWindow)
        coordinator.start()

        return true
    }
}
