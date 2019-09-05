//
//  SegmentSettingCellModel.swift
//  LocalWeather
//
//  Created by Ilya Rudometov on 03.09.2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import Foundation

final class SegmentSettingCellModel {
    
    let title: String
    let values: [String]
    
    var selectedIndex: Int {
        didSet {
            if selectedIndex != oldValue {
                onSelectedIndexChanged?(self)
            }
        }
    }
    
    var onSelectedIndexChanged: ((_ sender: SegmentSettingCellModel) -> Void)?
    
    // MARK: - init
    
    init(title: String,
         values: [String],
         selectedIndex: Int = 0) {
        
        self.title = title
        self.values = values
        self.selectedIndex = selectedIndex
    }
}
