//
//  SwitchSettingTableViewCell.swift
//  LocalWeather
//
//  Created by Ilya Rudometov on 04.09.2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import UIKit

final class SwitchSettingTableViewCell: SettingTableViewCell {
    
    static let reuseIdentifier = "switch-setting"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var switchControl: UISwitch!
    
    var onSwitchValueChanged: ((_ isOn: Bool) -> Void)?
    
    // MARK: - Overrides
    
    override func awakeFromNib() {
        super.awakeFromNib()
        switchControl.addTarget(self, action: #selector(onSwitchValueChanged(_:)), for: .valueChanged)
    }
    
    override func reset() {
        super.reset()
        titleLabel?.text = nil
        onSwitchValueChanged = nil
    }
    
    override func applySkin() {
        super.applySkin()
        titleLabel?.textColor = Appearance.shared.colorScheme.tableView.cellTextColor
    }
    
    func bind(model: SwitchSettingCellModel) {
        
        applySkin()
        
        titleLabel.text = model.title
        switchControl.isOn = model.isOn
        
         onSwitchValueChanged = { [weak model] isOn in
            model?.isOn = isOn
        }
    }
    
    @objc
    private func onSwitchValueChanged(_ sender: Any) {
        onSwitchValueChanged?(switchControl.isOn)
    }
}
