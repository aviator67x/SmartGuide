//
//  TextScannerViewModel.swift
//  SmartGuide
//
//  Created by Andrew Kasilov on 12.06.2024.
//

import Foundation

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
    
    init() {}
    
    deinit {
        print("TextScannerViewModel deinited")
    }
    
    // MARK: - Internal properties

    @Published var flashMode: FlashMode = .regular
    @Published var isCameraAccessGranted = true
    
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
    
    func contactSupportX() {}
    
    func sendEmail() {}
}
