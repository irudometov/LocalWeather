//
//  SegmentSettingTableViewCell.swift
//  LocalWeather
//
//  Created by Ilya Rudometov on 04.09.2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import UIKit

final class SegmentSettingTableViewCell: SettingTableViewCell {

    static let reuseIdentifier = "segmented-setting"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var onSelectedIndexChanged: ((_ newValue: Int) -> Void)?
    
    // MARK: - Overrides
    
    override func awakeFromNib() {
        super.awakeFromNib()
        segmentedControl.addTarget(self, action: #selector(onSelectedIndexChanged(_:)), for: .valueChanged)
    }
    
    override func reset() {
        super.reset()
        titleLabel?.text = nil
        segmentedControl?.removeAllSegments()
        onSelectedIndexChanged = nil
    }
    
    override func applySkin() {
        super.applySkin()
        
        let colorScheme = Appearance.shared.colorScheme
        titleLabel?.textColor = colorScheme.tableView.cellTextColor
        segmentedControl?.tintColor = colorScheme.segmentedControl.tintColor
    }
    
    func bind(model: SegmentSettingCellModel) {
        
        applySkin()
        
        titleLabel.text = model.title
        
        segmentedControl.removeAllSegments()
        
        for index in 0..<model.values.count {
            self.segmentedControl.insertSegment(withTitle: model.values[index],
                                                at: index,
                                                animated: false)
        }
        
        if model.selectedIndex >= 0 && model.selectedIndex < segmentedControl.numberOfSegments {
            segmentedControl.selectedSegmentIndex = model.selectedIndex
        } else if segmentedControl.numberOfSegments > 0 {
            segmentedControl.selectedSegmentIndex = 0
        }
        
        onSelectedIndexChanged = { [weak model] index in
            model?.selectedIndex = index
        }
    }
    
    @objc
    private func onSelectedIndexChanged(_ sender: Any) {
        onSelectedIndexChanged?(segmentedControl.selectedSegmentIndex)
    }
}
