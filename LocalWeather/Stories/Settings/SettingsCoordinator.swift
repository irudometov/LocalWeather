//
//  SettingsCoordinator.swift
//  LocalWeather
//
//  Created by Ilya Rudometov on 04.09.2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import Foundation

/// Coordinates the 'Settings' flow.

final class SettingsCoordinator: BaseCoordinator {
    
    override func start() {
        
        let viewModel = SettingsViewModel(userPreferenes: UserPreferences.shared)
        let viewController = SettingsViewController.newInstance(viewModel: viewModel, storyboardId: "settings")
        viewController.coordinator = self
        
        navigationController.pushViewController(viewController, animated: true)
    }
}
