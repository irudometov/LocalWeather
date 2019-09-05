//
//  UIViewController+Storyboardable.swift
//  LocalWeather
//
//  Created by Ilya Rudometov on 03.09.2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import UIKit

protocol Storyboardable {
    static func instantiate(withId identitifer: String) -> Self
    static func instantiate(withId identitifer: String, storyboardName: String) -> Self
}

extension Storyboardable where Self : UIViewController {
    
    static func instantiate(withId identifier: String) -> Self {
        return instantiate(withId: identifier, storyboardName: "Main")
    }
    
    static func instantiate(withId identifier: String, storyboardName: String) -> Self {
        
        let bundle = Bundle(for: Self.self)
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        
        guard let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as? Self else {
            fatalError("Fail to instantiate a view controller with id '\(identifier)' from storyboard '\(String(describing: storyboardName))'.")
        }
        
        return viewController
    }
}
