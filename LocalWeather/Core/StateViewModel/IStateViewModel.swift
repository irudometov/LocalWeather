//
//  IStateViewModel.swift
//  LocalWeather
//
//  Created by Ilya Rudometov on 04.09.2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import Foundation

protocol IStateViewModel {
    
    var state: ViewModelState { get }    
    var view: (AnyObject & IStateView)? { get set }
    
    func onViewWillAppear()
}

protocol IStateView {
    
    var title: String? { get set }
    
    func applySkin()
    
    func displayData(for stateViewModel: IStateViewModel)
    func displayLoadingView(for stateViewModel: IStateViewModel)
    func displayError(_ error: Error?, for stateViewModel: IStateViewModel)
}
