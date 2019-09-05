//
//  EnableLocationViewController.swift
//  LocalWeather
//
//  Created by Ilya Rudometov on 04.09.2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import UIKit

final class EnableLocationViewController: TypedViewController<EnableLocationViewModel> {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Appearance.shared.colorScheme.useDarkStatusBar ? .default : .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func didTapEnableLocation(_ sender: Any) {
        viewModel.tryEnableLocation()
    }
}
