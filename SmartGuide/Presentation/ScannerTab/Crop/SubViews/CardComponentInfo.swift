//
//  CropView.swift
//  SmartGuide
//
//  Created by Andrew Kasilov on 07.06.2024.
//

import Foundation

class CardComponentInfo: Identifiable, ObservableObject {
    let id: UUID
    @Published var origin: CGPoint
    @Published var size: CGSize

    init(id: UUID = UUID(), origin: CGPoint, size: CGSize) {
        self.id = id
        self.origin = origin
        self.size = size
    }
}
