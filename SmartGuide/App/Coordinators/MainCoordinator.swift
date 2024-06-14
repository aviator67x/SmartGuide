//
//  MainCoordinator.swift
//  SmartGuide
//
//  Created by Andrew Kasilov on 14.06.2024.
//

import Foundation

protocol MainCoordinator {
    var appContainer: AppContainer { get }
    
    func pop()
    func popToRoot()
    func dismissSheet()
    func dismissFullScreenCover()
}

extension MainCoordinator {
    var appContainer: AppContainer {
        AppContainerImpl()
    }
}
