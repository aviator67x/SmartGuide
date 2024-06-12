//
//  AppleView.swift
//  SwiftUICoordinator
//
//  Created by Alex Nagy on 29.01.2023.
//

import SwiftUI

struct AppleView: View {
    @EnvironmentObject private var coordinator: ScannerCoordinator
//    private var cropedImage: UIImage? {
//        UIImageView(image: UIImage(named: "face")).image(at: CGRect(x: 0, y: 0, width: 300, height: 700))
//    }
    @State private var croppedImage: UIImage = UIImage()
    
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
            
            Image(uiImage: UIImage(named: "face")!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 500, height: 300)
            
            Image(uiImage: croppedImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 200, height: 200)
                .background(Color.yellow)
            
            Button("Present 🫒") {
                croppedImage = cropImage(UIImage(named: "face"), toRect: CGRect(x: 100, y: 50, width: 450, height: 300), viewWidth: 500, viewHeight: 300)!//crop()
            }
        }
    }
    
        func cropImage(_ inputImage: UIImage?,
                       toRect cropRect: CGRect,
                       viewWidth: CGFloat,
                       viewHeight: CGFloat) -> UIImage?
        {
            guard let inputImage else {
                return nil
            }
            
            let imageViewScale = max(inputImage.size.width / viewWidth,
                                     inputImage.size.height / viewHeight)
    
            // Scale cropRect to handle images larger than shown-on-screen size
            let cropZone = CGRect(x: cropRect.origin.x * imageViewScale,
                                  y: cropRect.origin.y * imageViewScale,
                                  width: cropRect.size.width * imageViewScale,
                                  height: cropRect.size.height * imageViewScale)
    
            // Perform cropping in Core Graphics
    
            guard let cutImageRef: CGImage = inputImage.cgImage?.cropping(to: cropZone)
            else {
                return nil
            }
    
            // Return image to UIImage
            let croppedImage = UIImage(cgImage: cutImageRef)
            return croppedImage
        }
    
    func crop() -> UIImage {
        let sourceImage = UIImage(
            named: "face"
        )!
        
//       let width =

        // The shortest side
        let sideLength = min(
            sourceImage.size.width,
            sourceImage.size.height
        )

        // Determines the x,y coordinate of a centered
        // sideLength by sideLength square
        let sourceSize = sourceImage.size
        let xOffset = (sourceSize.width - sideLength) / 2.0
        let yOffset = (sourceSize.height - sideLength) / 2.0

        // The cropRect is the rect of the image to keep,
        // in this case centered
        let cropRect = CGRect(
            x: 1000,
            y: 50,
            width: 960,
            height: sourceImage.size.height * 0.5
        ).integral

        // Center crop the image
        let sourceCGImage = sourceImage.cgImage!
        let croppedCGImage = sourceCGImage.cropping(
            to: cropRect
        )!
        return UIImage(cgImage: croppedCGImage)
    }
}

struct AppleView_Previews: PreviewProvider {
    static var previews: some View {
        AppleView()
    }
}
