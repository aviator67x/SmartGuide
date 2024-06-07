//
//  ScannerView.swift
//  SmartGuide
//
//  Created by Andrew Kasilov on 06.06.2024.
//

import SwiftUI

struct ScannerView: View {
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(page: .scanner)
                .navigationDestination(for: ScannerPage.self) { page in
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
    @StateObject private var coordinator = ScannerCoordinator()
}

struct ScannerView_Previews: PreviewProvider {
    static var previews: some View {
        ScannerView()
    }
}
