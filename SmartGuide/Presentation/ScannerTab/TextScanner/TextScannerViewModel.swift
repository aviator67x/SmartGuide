//
//  TextScannerViewModel.swift
//  SmartGuide
//
//  Created by Andrew Kasilov on 12.06.2024.
//

import AVFoundation
import Combine
import Foundation
import PhotosUI
import _PhotosUI_SwiftUI

final class TextScannerViewModel: ObservableObject {
    enum FlashMode {
        case on
        case automatic
        case off
        
        var imageName: String {
            switch self {
            case .on:
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

    @Published var flashMode: FlashMode = .on
    @Published var cameraAccessStatus: CameraAccessStatus = .notDetermined
    
    // MARK: - Private properties

    @Published var shouldPresentPhotoPicker = false
    @Published var selectedPickerItem: PhotosPickerItem?

    private let cameraService: CameraService
    private var cancellables = Set<AnyCancellable>()
    
    private func setupBinding() {
        cameraService.cameraStatusPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                self?.cameraAccessStatus = value
            })
            .store(in: &cancellables)
    }
    
    func changeFlashMode() {
        guard let device = AVCaptureDevice.default(for: .video) else { return }

        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                switch flashMode {
                case .on:
                    flashMode = .automatic
                    device.torchMode = .auto
                case .automatic:
                    flashMode = .off
                    device.torchMode = .off
                case .off:
                    flashMode = .on
                    device.torchMode = .on
                }

                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }
    
    func requestCameraAccess() {
        cameraService.checkPermission()
    }
    
    func contactSupportX() {}
    
    func sendEmail() {}
}
