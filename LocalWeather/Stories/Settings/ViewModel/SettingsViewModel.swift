//
//  SettingsViewModel.swift
//  LocalWeather
//
//  Created by Ilya Rudometov on 03.09.2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import Foundation

final class SettingsViewModel: StateViewModel {
    
    private let userPreferences: UserPreferences
    private var cellModels: [Any] = []
    
    override var navBarTitle: String? {
        return "Settings"
    }
    
    // MARK: - init
    
    init(userPreferenes: UserPreferences) {
        self.userPreferences = userPreferenes
        super.init()
    }
    
    // MARK: - Overrides
    
    override func preloadData() {
        super.preloadData()
        cellModels = buildCellModels()
        state = .ready
    }
    
    private func buildCellModels() -> [Any] {
        
        return [
            temperatureUnitCellModel(),
            darkModeCellModel()
        ]
    }
    
    private func temperatureUnitCellModel() -> SegmentSettingCellModel {
        
        let units = TemperatureUnit.allCases
        let selectedUnitIndex = units.firstIndex(of: userPreferences.temperatureUnit) ?? 0
        let cellModel = SegmentSettingCellModel(title: NSLocalizedString("Temperature unit", comment: "Temperature unit setting name."),
                                                values: units.map { $0.displayName },
                                                selectedIndex: selectedUnitIndex)
        
        cellModel.onSelectedIndexChanged = { [weak self] sender in
            guard let this = self else { return }
            
            let index = sender.selectedIndex
            precondition(index >= 0 && index < units.count, "index \(index) is out of bounds [0..\(units.count)]")
            this.userPreferences.temperatureUnit = units[index]
        }
        
        return cellModel
    }
    
    private func darkModeCellModel() -> SwitchSettingCellModel {
        
        let cellModel = SwitchSettingCellModel(title: NSLocalizedString("Dark mode", comment: "Dark mode setting name"),
                                                isOn: userPreferences.isDarkModeEnabled)
        
        cellModel.onValueChanged = { [weak self] sender in
            guard let this = self else { return }
            this.userPreferences.isDarkModeEnabled = sender.isOn
        }
        
        return cellModel
    }
}

extension SettingsViewModel {
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRows(in section: Int) -> Int {
        return cellModels.count
    }
    
    func modelForCell(at indexPath: IndexPath) -> Any {
        precondition(indexPath.section == 0, "indexPath.section \(indexPath.section) should be equal to 0")
        return cellModels[indexPath.row]
    }
}
