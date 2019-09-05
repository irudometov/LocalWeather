//
//  SettingsViewController.swift
//  LocalWeather
//
//  Created by Ilya Rudometov on 03.09.2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import UIKit

final class SettingsViewController: TypedViewController<SettingsViewModel>, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - New instance
    
    static func newInstance(viewModel: SettingsViewModel) -> SettingsViewController {
        return newInstance(viewModel: viewModel, storyboardId: "settings")
    }
    
    // MARK: - View's life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = viewModel.modelForCell(at: indexPath)
        
        // Segmented control
        
        if let segmentedModel = model as? SegmentSettingCellModel {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SegmentSettingTableViewCell.reuseIdentifier, for: indexPath) as? SegmentSettingTableViewCell else {
                fatalError("Fail to instantiate a table view cell of type \(type(of: SegmentSettingTableViewCell.self)) with id \(SegmentSettingTableViewCell.reuseIdentifier)")
            }
            
            cell.bind(model: segmentedModel)
            
            return cell
        }
        
        // Switch
        
        if let switchModel = model as? SwitchSettingCellModel {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SwitchSettingTableViewCell.reuseIdentifier, for: indexPath) as? SwitchSettingTableViewCell else {
                fatalError("Fail to instantiate a table view cell of type \(type(of: SwitchSettingTableViewCell.self)) with id \(SwitchSettingTableViewCell.reuseIdentifier)")
            }
            
            cell.bind(model: switchModel)
            
            return cell
        }
        
        fatalError("Unsupported type of cell model: \(type(of: model))")
    }

    // MARK: - IStateView
    
    override func displayData(for stateViewModel: IStateViewModel) {
        super.displayData(for: stateViewModel)
        tableView.reloadData()
    }
    
    override func applySkin() {
        super.applySkin()
        tableView.backgroundColor = Appearance.shared.colorScheme.tableView.backgroundColor
        tableView.reloadData()
    }
}
