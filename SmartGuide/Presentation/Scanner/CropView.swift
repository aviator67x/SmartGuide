//
//  CropView.swift
//  SmartGuide
//
//  Created by Andrew Kasilov on 07.06.2024.
//

import SwiftUI

struct CropFrame: Shape {
    // - MARK: private properties
    let width: CGFloat
    let height: CGFloat
    let origin: CGPoint
    let isActive: Bool

    func path(in rect: CGRect) -> Path {
        guard isActive else { return Path(rect) } // full rect for non active

        let size = CGSize(width: width, height: height)
        return Path(CGRect(origin: origin, size: size).integral)
    }
}

struct CropView: View {
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Color.red
                    .opacity(0.5)
                    .frame(height: topHeight)

                Color.red
                    .frame(width: topBottomWidth, height: 4)
                    .offset(y: topHeight / 2)
                    .offset(x: leftOffset)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let offset = value.translation.height
                                let height: CGFloat = topHeight + offset

                                if height > 5, height < screenHeight / 2 {
                                    topHeight = height
                                }
                            }
                    )
            }
            .ignoresSafeArea()
            .overlay {
                Image(uiImage: cropedImage)
                    .resizable()
                    .scaledToFit()
            }

            HStack(spacing: 0) {
                Color.red
                    .opacity(0.5)
                    .frame(width: leftWidth)

                Color.red
                    .frame(width: 4)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let offset = value.translation.width
                                let width: CGFloat = leftWidth + offset

                                if width > 5, width < screenWidth / 2 {
                                    leftWidth = width
                                    leftOffset += offset / 2
                                }
                            }
                    )

                Color.clear

                Color.red
                    .frame(width: 4)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let offset = value.translation.width
                                let width: CGFloat = rightWidth - offset

                                if width > 5, width < screenWidth / 2 {
                                    rightWidth = width
                                    leftOffset += offset / 2
                                }
                            }
                    )

                Color.red
                    .opacity(0.5)
                    .frame(width: rightWidth)
            }
            .ignoresSafeArea()

            ZStack {
                Color.red
                    .frame(width: topBottomWidth, height: 4)
                    .offset(y: -(bottomHeight / 2))
                    .offset(x: leftOffset)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let offset = value.translation.height
                                let height: CGFloat = bottomHeight - offset

                                if height > 5, height < screenHeight / 2 {
                                    bottomHeight = height
                                }
                            }
                    )

                Color.red
                    .frame(height: bottomHeight)
                    .opacity(0.5)

                Button(action: {
                    guard let image = UIImage(named: "face") else {
                        return
                    }
                    cropedImage = cropImage(image,
                                            toRect: cropRect,//CGRect(x: 100,
//                                                           y: 100,
//                                                           width: topBottomWidth,
//                                                           height: cropHeight),
                                            viewWidth: screenWidth,
                                            viewHeight: screenHeight)!
                }) {
                    Text("Crop Image")
                        .padding(.all, 10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .shadow(color: .gray, radius: 1)
                        .padding(.top, 50)
                }
            }
            .ignoresSafeArea()
        }
        .ignoresSafeArea()
        .background(
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
        )
        .ignoresSafeArea()
    }

    // - MARK: private properties
    @StateObject private var model = CropViewModel()
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height

    @State private var topHeight: CGFloat = 300
    @State private var bottomHeight: CGFloat = 300
    @State private var leftWidth: CGFloat = 100
    @State private var rightWidth: CGFloat = 100
    @State private var leftOffset: CGFloat = 0
    @State private var clipped = false

    @State private var cropedImage = UIImage()

    private var topBottomWidth: CGFloat {
        screenWidth - leftWidth - rightWidth
    }

    private var cropHeight: CGFloat {
        screenHeight - topHeight - bottomHeight
    }

    private var cropOrigin: CGPoint {
        CGPoint(x: topHeight,
                y: leftWidth)
    }

    private var cropRect: CGRect {
        CGRect(x:  leftWidth,
               y: cropHeight,
               width: topBottomWidth,
               height: cropHeight)
    }

    private var image: UIImage

    // - MARK: life cycle
    init(_ image: UIImage) {
        self.image = image
    }
    func cropImage(_ inputImage: UIImage, toRect cropRect: CGRect, viewWidth: CGFloat, viewHeight: CGFloat) -> UIImage?
    {
        let imageViewScale = max(inputImage.size.width / viewWidth,
                                 inputImage.size.height / viewHeight)

let y  = topHeight - (screenHeight - inputImage.size.height/imageViewScale)/2
        // Scale cropRect to handle images larger than shown-on-screen size
        let cropZone = CGRect(x: cropRect.origin.x * imageViewScale,
                              y: y * imageViewScale,
                              width: cropRect.size.width * imageViewScale,
                              height: cropRect.size.height * imageViewScale)


        // Perform cropping in Core Graphics
        guard let cutImageRef: CGImage = inputImage.cgImage?.cropping(to:cropZone)
        else {
            return nil
        }


        // Return image to UIImage
        let croppedImage: UIImage = UIImage(cgImage: cutImageRef)
        return croppedImage
    }

//    func cropImage(_ inputImage: UIImage,
//                   toRect cropRect: CGRect,
//                   viewWidth: CGFloat,
//                   viewHeight: CGFloat) -> UIImage?
//    {
//        let imageViewScale = max(inputImage.size.width / viewWidth,
//                                 inputImage.size.height / viewHeight)
//
//        // Scale cropRect to handle images larger than shown-on-screen size
//        let cropZone = CGRect(x: cropRect.origin.x * imageViewScale,
//                              y: cropRect.origin.y * imageViewScale,
//                              width: cropRect.size.width * imageViewScale,
//                              height: cropRect.size.height * imageViewScale)
//
//        // Perform cropping in Core Graphics
//
//        guard let cutImageRef: CGImage = inputImage.cgImage?.cropping(to: cropZone)
//        else {
//            return nil
//        }
//
//        // Return image to UIImage
//        let croppedImage = UIImage(cgImage: cutImageRef)
//
//        return croppedImage
//    }
}

struct CropView_Previews: PreviewProvider {
    static var previews: some View {
        CropView(UIImage())
    }
}
