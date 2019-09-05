//
//  SettingTableViewCell.swift
//  LocalWeather
//
//  Created by Ilya Rudometov on 04.09.2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    
    // MARK: - Overrides
    
    override func awakeFromNib() {
        super.awakeFromNib()
        reset()
        applySkin()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    
    func reset() {
        // Clean up values from IB
    }
    
    func applySkin() {
        let colorScheme = Appearance.shared.colorScheme
        contentView.backgroundColor = colorScheme.tableView.cellBackgroundColor
        backgroundColor = colorScheme.tableView.cellBackgroundColor
    }
}

