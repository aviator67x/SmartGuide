//
//  BananaView.swift
//  SwiftUICoordinator
//
//  Created by Alex Nagy on 29.01.2023.
//

import SwiftUI

struct BananaView: View {
    
    @EnvironmentObject private var coordinator: ScannerCoordinator
    
    var body: some View {
VStack {
    Text("This is Chat View")
            Button("Push 🥕") {
//                coordinator.push(.carrot)
            }
            .padding()
   
    
            Button("Pop") {
                coordinator.pop()
            }
            .padding()
        }
        .navigationTitle("🍌")
    }
}

struct BananaView_Previews: PreviewProvider {
    static var previews: some View {
        BananaView()
    }
}
