//
//  TextScannerViewModel.swift
//  SmartGuide
//
//  Created by Andrew Kasilov on 12.06.2024.
//

import Foundation
import Combine

final class TextScannerViewModel: ObservableObject {
    enum FlashMode {
        case regular
        case automatic
        case off
        
        var imageName: String {
            switch self {
            case .regular:
                return "bolt.fill"
            case .automatic:
                return "bolt.badge.a.fill"
            case .off:
                return "bolt.slash.fill"
            }
        }
    }

    // MARK: - life cycle
    
    init(cameraService: CameraService) {
        self.cameraService = cameraService
        setupBinding()
    }
    
    deinit {
        print("TextScannerViewModel deinited")
    }
    
    // MARK: - Internal properties

    @Published var flashMode: FlashMode = .regular
    @Published var isCameraAccessGranted = false
    @Published var cameraAccessStatus: CameraAccessStatus = .notDetermined
    
    // MARK: - Private properties
    private let cameraService: CameraService
    private var cancellables = Set<AnyCancellable>()
    
    private func setupBinding() {
        cameraService.$cameraStatus
            .sink(receiveValue: { [weak self] value in
                self?.cameraAccessStatus = value
            })
            .store(in: &cancellables)
    }
    
    func changeFlashMode() {
        switch flashMode {
        case .regular:
            flashMode = .automatic
        case .automatic:
            flashMode = .off
        case .off:
            flashMode = .regular
        }
    }
    
    func requestCameraAccess() {
        cameraService.checkPermission()
    }
    
    func contactSupportX() {}
    
    func sendEmail() {}
}
