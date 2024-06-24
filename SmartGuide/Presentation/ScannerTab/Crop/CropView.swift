//
//  CropView.swift
//  SmartGuide
//
//  Created by Andrew Kasilov on 07.06.2024.
//

import SwiftUI

struct CropView: View {
    var body: some View {
        ZStack {
            //            Image(uiImage: image)
            //                .resizable()
            //                .scaledToFit()

            Rectangle()
                .foregroundColor(.green.opacity(0.5))
                .reverseMask {
                    Rectangle()
                        .frame(
                            width: model.widthForCardComponent(info: info),
                            height: model.heightForCardComponent(info: info)
                        )
                        .cornerRadius(20)
                        .position(
                            x: model.xPositionForCardComponent(info: info),
                            y: model.yPositionForCardComponent(info: info)
                        )
                }

            ResizingControlsView { point, deltaX, deltaY in
                model.resizedComponentInfo = info
                model.updateForResize(using: point, deltaX: deltaX, deltaY: deltaY)
            } dragEnded: {
                model.resizeEnded()
            }
            .cornerRadius(20)
            .frame(
                width: model.widthForCardComponent(info: info),
                height: model.heightForCardComponent(info: info)
            )
            .position(
                x: model.xPositionForCardComponent(info: info),
                y: model.yPositionForCardComponent(info: info)
            )
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        model.draggedComponentInfo = info
                        model.updateForDrag(deltaX: gesture.translation.width, deltaY: gesture.translation.height)
                    }
                    .onEnded { _ in
                        model.dragEnded()
                    }
            )

            VStack {
                Button(action: {
                    guard let image = cropImage(image,
                                                toRect: cropRect)
                    else {
                        return
                    }
                    self.cropedImage = image
                    self.coordinator.push(.apple(croppedImage: image))
                 
                }) {
                    Text("Crop Image")
                        .padding(.all, 10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .shadow(color: .gray, radius: 1)
                        .padding(.top, 50)
                }

                Image(uiImage: cropedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 200)
            }
            .offset(y: 250)
        }.background(
            GeometryReader { geometry in
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .onAppear {
                        print("Button coordinates: \(geometry.frame(in: .global).minX)  \(geometry.frame(in: .global).minY)")
                    }
            }
        )
    }

    // - MARK: private properties
    @EnvironmentObject private var coordinator: ScannerCoordinator
    @StateObject private var model = CropViewModel()
    @State private var cropedImage = UIImage()
    private let image: UIImage
    private var info: CardComponentInfo

    private var cropRect: CGRect {
        CGRect(x: model.xPositionForCardComponent(info: info),
               y: model.yPositionForCardComponent(info: info),
               width: model.widthForCardComponent(info: info),
               height: model.heightForCardComponent(info: info))
    }

    // - MARK: life cycle
    init(_ image: UIImage,
         info: CardComponentInfo = CardComponentInfo(origin: .init(x: 100, y: 200), size: .init(width: 200, height: 200)))
    {
        self.image = image
        self.info = info
    }

    func cropImage(_ inputImage: UIImage, toRect cropRect: CGRect) -> UIImage? {
        guard let safeAreaInsets = UIWindow.keyWindow?.safeAreaInsets else {
            return nil
        }

        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let imageViewScale = max(inputImage.size.width / screenWidth,
                                 inputImage.size.height / screenHeight)
        let xScale = inputImage.size.width / screenWidth
        let yScale = inputImage.size.height / screenWidth
        
        // Scale cropRect to handle images larger than shown-on-screen size
        let cropZone = CGRect(x: cropRect.origin.x,
                              y: cropRect.origin.y,
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
}

struct CropView_Previews: PreviewProvider {
    static var previews: some View {
        CropView(UIImage(),
                 info: CardComponentInfo(origin: .init(x: 100, y: 200), size: .init(width: 200, height: 200)))
    }
}
