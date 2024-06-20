//
//  ResizingConrolsView.swift
//  Resizing Problem
//
//  Created by Kevin on 3/14/23.
//

import Foundation
import SwiftUI

struct ResizingControlsView: View {
    let horizontalGrabViewHeight: CGFloat = 8.0
    let horizontalGrabViewWidth: CGFloat = 34.0
    let verticalGrabViewHeight: CGFloat = 34.0
    let verticalGrabViewWidth: CGFloat = 8.0
    let dragged: (ResizePoint, CGFloat, CGFloat) -> Void
    let dragEnded: () -> Void

    var body: some View {
        VStack(spacing: 0.0) {
            HStack(spacing: 0.0) {
                Spacer()
                horizontalGrabView(resizePoint: .topMiddle)
                Spacer()
            }
            Spacer()
            HStack(spacing: 0.0) {
                verticalGrabView(resizePoint: .leftMiddle)
                Spacer()
                verticalGrabView(resizePoint: .rightMiddle)
            }
            Spacer()
            HStack(spacing: 0.0) {
                Spacer()
                horizontalGrabView(resizePoint: .bottomMiddle)
                Spacer()
            }
        }
        .background(Color.cyan)
            
    }

    private func horizontalGrabView(resizePoint: ResizePoint) -> some View {
        var offsetY: CGFloat = 0.0
        switch resizePoint {
        case .topMiddle:
            offsetY = -horizontalGrabViewHeight / 2
        case .rightMiddle:
            break
        case .bottomMiddle:
            offsetY = horizontalGrabViewHeight / 2
        case .leftMiddle:
            break
        }
        return Color.blue
            .cornerRadius(4)
            .frame(width: horizontalGrabViewWidth, height: horizontalGrabViewHeight)
            .offset(y: offsetY)
            .gesture(dragGesture(point: resizePoint))
    }

    private func verticalGrabView(resizePoint: ResizePoint) -> some View {
        var offsetX: CGFloat = 0.0
        switch resizePoint {
        case .topMiddle:
            break
        case .rightMiddle:
            offsetX = verticalGrabViewWidth / 2
        case .bottomMiddle:
            break
        case .leftMiddle:
            offsetX = -verticalGrabViewWidth / 2
        }
        return Color.blue
            .cornerRadius(4)
            .frame(width: verticalGrabViewWidth, height: verticalGrabViewHeight)
            .offset(x: offsetX)
            .gesture(dragGesture(point: resizePoint))
    }

    private func dragGesture(point: ResizePoint) -> some Gesture {
        DragGesture()
            .onChanged { drag in
                switch point {
                case .topMiddle:
                    dragged(point, 0, drag.translation.height)
                case .rightMiddle:
                    dragged(point, drag.translation.width, 0)
                case .bottomMiddle:
                    dragged(point, 0, drag.translation.height)
                case .leftMiddle:
                    dragged(point, drag.translation.width, 0)
                }
            }
            .onEnded { _ in dragEnded() }
    }
}
