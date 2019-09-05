//
//  URLHelper.swift
//  LocalWeather
//
//  Created by Ilya Rudometov on 05.09.2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import UIKit

struct URLHelper {
    
    static func openSystemSettings() {
        
        guard let url = URL(string: UIApplication.openSettingsURLString),
            UIApplication.shared.canOpenURL(url) else {
                return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
