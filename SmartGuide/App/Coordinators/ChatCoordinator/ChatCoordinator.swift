//
//  ChatCoordinator.swift
//  SmartGuide
//
//  Created by Andrew Kasilov on 07.06.2024.
//

import SwiftUI

enum ChatPage: Identifiable, Hashable {
    case apple(croppedImage: UIImage)
    case banana
    
    var id: String {
       "Apple"
    }
}

enum ChatSheet: String, Identifiable {
    case lemon
    
    var id: String {
        self.rawValue
    }
}

enum ChatFullScreenCover: String, Identifiable {
    case olive
    
    var id: String {
        self.rawValue
    }
}

final class ChatCoordinator: ObservableObject {
    
    @Published var path = NavigationPath()
    @Published var sheet: ChatSheet?
    @Published var fullScreenCover: ChatFullScreenCover?
    
    func push(_ page: ChatPage) {
        path.append(page)
    }
    
    func present(sheet: ChatSheet) {
        self.sheet = sheet
    }
    
    func present(fullScreenCover: ChatFullScreenCover) {
        self.fullScreenCover = fullScreenCover
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func dismissSheet() {
        self.sheet = nil
    }
    
    func dismissFullScreenCover() {
        self.fullScreenCover = nil
    }
    
    @ViewBuilder
    func build(page: ChatPage) -> some View {
        switch page {
//        case .camera:
//            CameraView()
        case let .apple(image):
            AppleView(croppedImage: image)
        case .banana:
            BananaView()
        }
    }
    
    @ViewBuilder
    func build(sheet: ChatSheet) -> some View {
        switch sheet {
        case .lemon:
            NavigationStack {
                LemonView()
            }
        }
    }
    
    @ViewBuilder
    func build(fullScreenCover: ChatFullScreenCover) -> some View {
        switch fullScreenCover {
        case .olive:
            NavigationStack {
                OliveView()
            }
        }
    }
    
}

