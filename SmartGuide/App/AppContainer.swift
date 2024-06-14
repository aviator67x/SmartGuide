//
//  AppContainer.swift
//  SmartGuide
//
//  Created by Andrew Kasilov on 14.06.2024.
//

import Foundation

protocol AppContainer {
    var cameraService: CameraService { get }
}

final class AppContainerImpl: AppContainer {
    var cameraService: CameraService
    
    init() {
        self.cameraService = CameraServiceImpl()
    }
}
