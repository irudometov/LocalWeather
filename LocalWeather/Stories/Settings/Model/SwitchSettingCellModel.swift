//
//  SwitchSettingCellModel.swift
//  LocalWeather
//
//  Created by Ilya Rudometov on 04.09.2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import Foundation

final class SwitchSettingCellModel {
    
    let title: String
    
    var isOn: Bool {
        didSet {
            if isOn != oldValue {
                onValueChanged?(self)
            }
        }
    }
    
    var onValueChanged: ((_ sender: SwitchSettingCellModel) -> Void)?
    
    // MARK: - init
    
    init(title: String, isOn: Bool) {
        
        self.title = title
        self.isOn = isOn
    }
}
