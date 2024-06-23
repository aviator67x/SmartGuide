//
//  ResizingView.swift
//  SmartGuide
//
//  Created by Andrew Kasilov on 20.06.2024.
//

import Foundation
import SwiftUI

struct ResizingView: View {
    var info: CardComponentInfo
    @ObservedObject var model: ViewModel

    var body: some View {
        ZStack {
            Image("face")
                .resizable()
                .scaledToFit()
             

            ZStack {
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
            }
        }
    }
}

struct ResizingView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
