//
//  Coordinator.swift
//  LocalWeather
//
//  Created by Ilya Rudometov on 04.09.2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import UIKit

// MARK: - Protocols

protocol Coordinator: AnyObject {
    
    var uuid: UUID { get }
    
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get }
    
    func start()
}

protocol Coordinated where Self: UIViewController {
    var coordinator: Coordinator? { get set }
}

// MARK: - Classes

class BaseCoordinator: Coordinator {
    
    let uuid: UUID = UUID()
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
    }
    
    func start() {
        fatalError("Method start() doesn't implemented on \(type(of: self)).")
    }
}

class NavigatableCoordinator: NSObject, Coordinator {
    
    let uuid: UUID = UUID()
    var childCoordinators: [Coordinator] = []
    var navigationController = UINavigationController()
    
    // MARK: - init
    
    override init() {
        super.init()
        navigationController.delegate = self
    }
    
    func start() {
        fatalError("Method start() doesn't implemented on \(type(of: self)).")
    }
    
    func coordinate(to child: Coordinator) {
        
        guard index(of: child) == nil else {
            fatalError("A coortinator \(child) is already added.")
        }
        
        childCoordinators.append(child)
        child.start()
    }
    
    private func index(of child: Coordinator) -> Int? {
        return childCoordinators.firstIndex(where: { child.uuid == $0.uuid })
    }
    
    func childCoordinatorDidFinish(_ child: Coordinator) {
        guard let index = index(of: child) else { return }
        childCoordinators.remove(at: index)
    }
}

extension NavigatableCoordinator: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController,
                              didShow viewController: UIViewController,
                              animated: Bool) {
        
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        
        if let coordinatedViewController = fromViewController as? Coordinated,
            let coordinator = coordinatedViewController.coordinator {
            childCoordinatorDidFinish(coordinator)
        }
    }
}
