//
//  CropView.swift
//  SmartGuide
//
//  Created by Andrew Kasilov on 07.06.2024.
//

import SwiftUI

struct CropFrame: Shape {
    // - MARK: private properties
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    let isActive: Bool
    func path(in rect: CGRect) -> Path {
        guard isActive else { return Path(rect) } // full rect for non active

        let size = CGSize(width: screenWidth * 0.7, height: screenHeight/5)
        let origin = CGPoint(x: rect.midX - size.width / 2, y: rect.midY - size.height / 2)
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
            }
        }
        .ignoresSafeArea()
    }

    // - MARK: private properties
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height

    @State private var topHeight: CGFloat = 300
    @State private var bottomHeight: CGFloat = 300
    @State private var leftWidth: CGFloat = 100
    @State private var rightWidth: CGFloat = 100
    @State private var leftOffset: CGFloat = 0

    private var topBottomWidth: CGFloat {
        screenWidth - leftWidth - rightWidth
    }

    @State private var image: UIImage

    // - MARK: life cycle
    init(_ image: UIImage) {
        self.image = image
    }

}

struct CropView_Previews: PreviewProvider {
    static var previews: some View {
        CropView(UIImage())
    }
}
