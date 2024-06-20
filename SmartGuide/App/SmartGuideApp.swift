//
//  SmartGuideApp.swift
//  SmartGuide
//
//  Created by Andrew Kasilov on 06.06.2024.
//

import SwiftUI

@main
struct SmartGuideApp: App {
    var body: some Scene {
        WindowGroup {
//            AppleView()
//            CropView(UIImage(named: "face") ?? UIImage())
//            MainView()
//            TestView()
   
                
                ResizingView(info: info, model: model)

           

//ChatGPTView()
        }
    }
    @StateObject private var model = ViewModel()

    let info = CardComponentInfo(origin: .init(x: 100, y: 200), size: .init(width: 200, height: 200))
}
