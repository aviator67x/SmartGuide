//
//  ContentView.swift
//  CustomCamera
//
//  Created by Andrew Kasilov on 03.06.2024.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView(selection: $selectedView) {
            Group {
//                TextScanner()
                ScannerView()
                    .tabItem {
                        Label("Text Scanner", systemImage: "camera")
                    }
                    .tag(1)
                    .onTapGesture {
                        selectedView = 1
                    }

                Chat()
                    .tabItem {
                        Label("Ask AI", systemImage: "character.book.closed")
                    }
                    .tag(2)
            }
        }
        .accentColor(Color.pink)
    }

    @State private var selectedView = 1
//    @StateObject private var viewModel = MainViewModel()
    
    init() {
         let transparentAppearence = UITabBarAppearance()
         transparentAppearence.configureWithTransparentBackground() // 🔑
         UITabBar.appearance().standardAppearance = transparentAppearence
     }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
