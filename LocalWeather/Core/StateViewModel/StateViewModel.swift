//
//  StateViewModel.swift
//  LocalWeather
//
//  Created by Ilya Rudometov on 04.09.2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import Foundation

class StateViewModel: IStateViewModel {
    
    weak var view: (AnyObject & IStateView)? {
        didSet {
            
            // Set custom nav bar title if provided
            
            if let title = navBarTitle {
                view?.title = title
            }
        }
    }
    
    var navBarTitle: String? {
        return nil
    }
    
    // MARK: - init
    
    init() {
        subscribeForAppearanceUpdates()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - View model state
    
    private var prevState: ViewModelState = .initial
    var state: ViewModelState = .initial {
        didSet {
            guard prevState != state else { return }
            prevState = state
            bindState()
        }
    }
    
    // MARK: - View's life cycle
    
    func onViewWillAppear() {
        bindState()
    }
    
    private func bindState() {
        switch state {
        case .initial:
            preloadData()
        case .loading:
            displayLoadingView()
        case .error(let error):
            displayError(error: error)
        default:
            displayData()
        }
    }
    
    func preloadData() {
        // Do nothing by default...
    }
    
    func displayLoadingView() {
        view?.displayLoadingView(for: self)
    }
    
    func displayError(error: Error?) {
        view?.displayError(error, for: self)
    }
    
    func displayData() {
        view?.displayData(for: self)
    }
}

extension StateViewModel {
    
    // MARK: - Appearance
    
    private func subscribeForAppearanceUpdates() {
        
        NotificationCenter.default.removeObserver(self,
                                                  name: Appearance.colorSchemeDidChangeNotification,
                                                  object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applySkin),
                                               name: Appearance.colorSchemeDidChangeNotification,
                                               object: nil)
    }
    
    @objc
    private func applySkin() {
        view?.applySkin()
    }
}
