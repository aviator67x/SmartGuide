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
            topView()
//                .overlay {
//                    Image(uiImage: cropedImage)
//                        .resizable()
//                        .scaledToFit()
//                }

            HStack(spacing: 0) {
                leftView()

                Color.clear
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                rightView()
            }

            bottomView()
            //        ZStack {
            //            RoundedRectangle(cornerRadius: 20)
            //                .frame(width: cropWidth, height: cropHeight - topHandleOffset)
            //                .foregroundColor(Color.clear)
            //                .offset(y: topHandleOffset * 0.5)
            //
            //            HStack {
            //                Color.red
            //                    .frame(width: 50)
            //                    .cornerRadius(4)
            //            }
            //            .frame(width: cropWidth, height: 8)
            //            .offset(y: topHandleOffset - 150)
            //            //                .offset(x: topOffset)
            //            .gesture(
            //                DragGesture()
            //                    .onChanged { val in
            //                        self.topHandleOffset = val.translation.height
            //                              }
            //                              .onEnded { val in
            //                                  self.topHandleOffset = .zero
            //                              }
            //            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
        )
    }

//
//    @State var cropHeight: CGFloat = 300
//    @State var cropWidth: CGFloat = 200
//    @State var topCropOffset: CGFloat = 0
//    @State var topHandleOffset = CGFloat.zero

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
        CGRect(x: leftWidth,
               y: cropHeight,
               width: topBottomWidth,
               height: cropHeight)
    }

    private var image: UIImage

    // - MARK: life cycle
    init(_ image: UIImage) {
        self.image = image
    }

    @ViewBuilder
    func topView() -> some View {
        ZStack {
            Color.black
                .opacity(0.2)
                .frame(height: topHeight)

            HStack {
                Color.white
                    .frame(width: 50)
                    .cornerRadius(4)
            }
            .frame(width: topBottomWidth, height: 8)
            .offset(y: topHeight / 2)
            .offset(x: leftOffset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let offset = value.translation.height
                        let height: CGFloat = topHeight + offset

                        if height > 5, height < (screenHeight - bottomHeight - 50) {
                            topHeight = height
                        }
                    }
                    .onEnded { _ in
                    }
            )
        }
    }

    @ViewBuilder
    func leftView() -> some View {
        ZStack(alignment: .trailing) {
            Color.red
                .opacity(0.5)
                .frame(width: leftWidth)

            VStack {
                Color.white
                    .frame(height: 50)
                    .cornerRadius(4)
            }
            .offset(x: 4)
            .frame(width: 8)
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
        }
    }

    @ViewBuilder
    func rightView() -> some View {
        ZStack(alignment: .leading) {
            Color.red
                .opacity(0.5)
                .frame(width: rightWidth)
            
            VStack {
                Color.white
                    .frame(height: 50)
                    .cornerRadius(4)
            }
                .offset(x: -4)
                .frame(width: 8)
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
        }
    }

    @ViewBuilder
    func bottomView() -> some View {
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
                                        toRect: cropRect,
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
    }

    func cropImage(_ inputImage: UIImage, toRect cropRect: CGRect, viewWidth: CGFloat, viewHeight: CGFloat) -> UIImage?
    {
        let imageViewScale = max(inputImage.size.width / viewWidth,
                                 inputImage.size.height / viewHeight)

        let y = topHeight - (screenHeight - inputImage.size.height / imageViewScale) / 2
        // Scale cropRect to handle images larger than shown-on-screen size
        let cropZone = CGRect(x: cropRect.origin.x * imageViewScale,
                              y: y * imageViewScale,
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
        CropView(UIImage())
    }
}
