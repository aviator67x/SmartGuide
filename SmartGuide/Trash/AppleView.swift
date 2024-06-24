//
//  AppleView.swift
//  SwiftUICoordinator
//
//  Created by Alex Nagy on 29.01.2023.
//

import SwiftUI

struct AppleView: View {

    
    var body: some View {
        ZStack {
            VStack {
                Text("This is Scanner View")
                
                Button(action: { print("Push") }, label: { Text("Push") })
                
                Button("Push 🍌") {
                    coordinator.push(.banana)
                }
                Button("Present 🍋") {
                    coordinator.present(sheet: .lemon)
                }
                Button("Present 🫒") {
                    coordinator.present(fullScreenCover: .olive)
                }
            }
            .navigationTitle("🍎")
            
            Image(uiImage: croppedImage)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
            
            Button("Dismiss") {
                coordinator.pop()
            }
        }
    }
    // - MARK: Private properties
    @EnvironmentObject private var coordinator: ScannerCoordinator
    @State private var croppedImage: UIImage
    
    init( croppedImage: UIImage) {
        self.croppedImage = croppedImage
    }
}

struct AppleView_Previews: PreviewProvider {
    static var previews: some View {
        AppleView(croppedImage: UIImage())
    }
}
