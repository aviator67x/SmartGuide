//
//  TestView.swift
//  SmartGuide
//
//  Created by Andrew Kasilov on 16.06.2024.
//

import SwiftUI

struct TestView: View {
    var body: some View {
        ZStack {
            Image("face")
            ZStack {
                Rectangle()
                    .foregroundColor(.green.opacity(0.5))
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: cropWidth, height: cropHeight)
                    .offset(y: topHandleOffset * 0.5 + bottomHandleOffset * 0.5)
                    .blendMode(.destinationOut)

                RoundedRectangle(cornerRadius: 4)
                    .foregroundColor(.red)
                    .frame(width: 50, height: 8)
                    .offset(y: topHandleOffset - 75)
                    .gesture(
                        DragGesture(coordinateSpace: .global)
                            .onChanged { value in
                                let offset = value.translation.height
                                print("originalHeightBegin: \(originalHeight)")
                                let height = originalHeight - offset

                                if height > 50, offset < (UIScreen.main.bounds.height + originalHeight) * 0.5 - 30 {
                                    self.topHandleOffset = offset
                                    self.cropHeight = height
                                    print("CropHeigth: \(cropHeight)")
                                }
                            }
                            .onEnded { value in
                                deltaHeight += value.translation.height
                                originalHeight = 150 - deltaHeight
                                print("originalHeightEnd: \(originalHeight)")
                
                            }
                    )

                RoundedRectangle(cornerRadius: 4)
                    .foregroundColor(.red)
                    .frame(width: 50, height: 8)
                    .offset(y: bottomHandleOffset + 75)
                    .gesture(
                        DragGesture(coordinateSpace: .global)
                            .onChanged { value in
                                let offset = value.translation.height
                                let height = originalHeight + offset
                                if height > 50 {
                                    self.bottomHandleOffset = offset
                                    self.cropHeight = height
                                }
                            }
                            .onEnded { value in
                                originalHeight = cropHeight
                            }
                    )

                RoundedRectangle(cornerRadius: 4)
                    .foregroundColor(.red)
                    .frame(width: 8, height: verticalHandleHeight)
                    .offset(x: -cropWidth * 0.5, y: verticalHandleOffset)

                RoundedRectangle(cornerRadius: 4)
                    .foregroundColor(.red)
                    .frame(width: 8, height: verticalHandleHeight)
                    .offset(x: cropWidth * 0.5, y: verticalHandleOffset)
            }
            .compositingGroup()
        }
    }
@State private  var deltaHeight: CGFloat = 0
    @State private var originalHeight: CGFloat = 150
    private let originalWidth: CGFloat = 200
    private let originalHandleLength: CGFloat = 50
    @State private var cropHeight: CGFloat = 150
    @State private var cropWidth: CGFloat = 200
    @State private var topCropOffset: CGFloat = 0
    @State private var topHandleOffset = CGFloat.zero
    @State private var bottomHandleOffset = CGFloat.zero

    private var verticalHandleOffset: CGFloat {
        (topHandleOffset + bottomHandleOffset) * 0.5
    }

    private var verticalHandleHeight: CGFloat {
        if cropHeight > originalHandleLength + 25 {
            return originalHandleLength
        }

        return cropHeight - 25
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
