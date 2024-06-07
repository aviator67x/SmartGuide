//
//  CropView.swift
//  SmartGuide
//
//  Created by Andrew Kasilov on 07.06.2024.
//

import SwiftUI

struct CropView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .frame(width: 200, height: 200)
    }
    
    @State private var image: UIImage
    
    init(_ image: UIImage) {
        self.image = image
    }
}

struct CropView_Previews: PreviewProvider {
    static var previews: some View {
        CropView(UIImage())
    }
}
