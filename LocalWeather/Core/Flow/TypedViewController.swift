//
//  TypedViewController.swift
//  LocalWeather
//
//  Created by Ilya Rudometov on 04.09.2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import UIKit

class TypedViewController<VM: IStateViewModel>: UIViewController, Storyboardable, Coordinated, IStateView {
    
    private (set) var viewModel: VM!
    var coordinator: Coordinator?
    
    class func newInstance(viewModel: VM, storyboardId: String) -> Self {
        
        let viewController = instantiate(withId: storyboardId)
        viewController.viewModel = viewModel
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applySkin()
        viewModel.onViewWillAppear()
    }

    // MARK: - IStateView
    
    func applySkin() {
        view.backgroundColor = Appearance.shared.colorScheme.view.backgroundColor
    }
    
    func displayData(for stateViewModel: IStateViewModel) {}
    func displayLoadingView(for stateViewModel: IStateViewModel) {}
    func displayError(_ error: Error?, for stateViewModel: IStateViewModel) {}
}
