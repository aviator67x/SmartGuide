//
//  ChatView.swift
//  SmartGuide
//
//  Created by Andrew Kasilov on 07.06.2024.
//

import SwiftUI

struct ChatView: View {
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(page: .banana)
                .navigationDestination(for: ChatPage.self) { page in
                    coordinator.build(page: page)
                }
                .sheet(item: $coordinator.sheet) { sheet in
                    coordinator.build(sheet: sheet)
                }
                .fullScreenCover(item: $coordinator.fullScreenCover) { fullScreenCover in
                    coordinator.build(fullScreenCover: fullScreenCover)
                }
        }
        .environmentObject(coordinator)
    }
    
    // MARK: - private
    @StateObject private var coordinator = ChatCoordinator()
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
