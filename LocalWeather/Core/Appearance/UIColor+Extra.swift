//
//  UIColor+Extra.swift
//  LocalWeather
//
//  Created by Ilya Rudometov on 05.09.2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import UIKit

extension String {
    
    var hexToInt: UInt32 {
        var hexInt: UInt32 = 0
        let scanner = Scanner(string: self)
        scanner.charactersToBeSkipped = ["#"]
        scanner.scanHexInt32(&hexInt)
        return hexInt
    }
}

extension UIColor {
    
    static func rgb(_ hexColor: String, alpha: CGFloat = 1) -> UIColor {
        return UIColor(rgb: hexColor, alpha: alpha)
    }
    
    convenience init(rgb: String, alpha: CGFloat = 1) {
        let hexint = rgb.hexToInt
        let r = CGFloat((hexint & 0xFF0000) >> 16) / 255
        let g = CGFloat((hexint & 0xFF00  ) >> 8 ) / 255
        let b = CGFloat((hexint & 0xFF    )      ) / 255
        self.init(red: r,
                  green: g,
                  blue: b,
                  alpha: alpha)
    }
}
