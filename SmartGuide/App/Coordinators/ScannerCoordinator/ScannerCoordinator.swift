//
//  ScannerCoordinator.swift
//  SmartGuide
//
//  Created by Andrew Kasilov on 06.06.2024.
//

import SwiftUI

enum ScannerPage: Hashable, Identifiable {
    case scanner
    case crop(UIImage)
    case banana
    var id: UUID {
        UUID()
    }
}

enum ScannerSheet: String, Identifiable {
    case lemon
    
    var id: String {
        rawValue
    }
}

enum ScannerFullScreenCover: String, Identifiable {
    case olive
    
    var id: String {
        rawValue
    }
}

final class ScannerCoordinator: MainCoordinator, ObservableObject {
    // MARK: - Internal properties

    @Published var path = NavigationPath()
    @Published var sheet: ScannerSheet?
    @Published var fullScreenCover: ScannerFullScreenCover?

    // MARK: - Navigation

    func push(_ page: ScannerPage) {
        path.append(page)
    }
    
    func present(sheet: ScannerSheet) {
        self.sheet = sheet
    }
    
    func present(fullScreenCover: ScannerFullScreenCover) {
        self.fullScreenCover = fullScreenCover
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func dismissSheet() {
        sheet = nil
    }
    
    func dismissFullScreenCover() {
        fullScreenCover = nil
    }

    // MARK: - ViewBuilders

    @ViewBuilder
    func build(page: ScannerPage) -> some View {
        switch page {
        case .scanner:
            TextScannerView(cameraService: appContainer.cameraService as! CameraServiceImpl)
        case .crop(let image):
            CropView(image)
        case .banana:
            BananaView()
        }
    }
    
    @ViewBuilder
    func build(sheet: ScannerSheet) -> some View {
        switch sheet {
        case .lemon:
            NavigationStack {
                LemonView()
            }
        }
    }
    
    @ViewBuilder
    func build(fullScreenCover: ScannerFullScreenCover) -> some View {
        switch fullScreenCover {
        case .olive:
            NavigationStack {
                OliveView()
            }
        }
    }
}
