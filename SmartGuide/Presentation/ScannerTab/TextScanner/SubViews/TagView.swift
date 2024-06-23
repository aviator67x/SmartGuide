//
//  TagView.swift
//  SmartGuide
//
//  Created by Andrew Kasilov on 07.06.2024.
//

import Foundation
import SwiftUI

struct TagModel: Identifiable {
    // For testing purposes
    static let exampleModels: [TagModel] = [
        .init(id: 1, systemImage: "car", label: "Car", timeEstimate: 19),
        .init(id: 2, systemImage: "tram", label: "Tram", timeEstimate: 32),
        .init(id: 3, systemImage: "bus", label: "Bus", timeEstimate: 34),
        .init(id: 4, systemImage: "figure.walk", label: "Walking", timeEstimate: 59),
        .init(id: 5, systemImage: "car", label: "Car", timeEstimate: 19),
        .init(id: 6, systemImage: "tram", label: "Tram", timeEstimate: 32),
        .init(id: 7, systemImage: "bus", label: "Bus", timeEstimate: 34),
        .init(id: 8, systemImage: "figure.walk", label: "Walking", timeEstimate: 59),
    ]

    let id: Int
    let systemImage: String
    let label: String
    let timeEstimate: TimeInterval
}

import SwiftUI

// MARK: - TagView

struct TagView: View {
    let viewModel: TagModel
    
    var body: some View {
        HStack {
            Image(systemName: viewModel.systemImage)
                .foregroundColor(.blue)
            
            Text(viewModel.label)
                .fontWeight(.semibold)
                .foregroundColor(.blue)
            
            Text("\(Int(viewModel.timeEstimate)) min")
                .foregroundColor(.blue)
        }
        .padding(6)
        .background(Color.blue.opacity(0.1))
        .cornerRadius(6)
    }
}

// MARK: - TagView_Previews

struct TagView_Previews: PreviewProvider {
    static var previews: some View {
        TagView(viewModel: .init(id: 1, systemImage: "tram", label: "Tram", timeEstimate: 23))
    }
}
