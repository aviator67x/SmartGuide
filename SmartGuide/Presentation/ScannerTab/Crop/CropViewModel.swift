//
//  CropViewModel.swift
//  SmartGuide
//
//  Created by Andrew Kasilov on 11.06.2024.
//

import UIKit
import Vision

final class CropViewModel: ObservableObject {
    // - MARK: Internal properties
    @Published var recognizedText: String = ""
    
    // - MARK: Resizing logic
    @Published var componentInfos: [CardComponentInfo] = []
    
    @Published var draggedComponentInfo: CardComponentInfo? = nil
    @Published var dragOffset: CGSize? = nil
    
    @Published var selectedComponentInfo: CardComponentInfo? = nil
    
    @Published var componentBeingAddedInfo: CardComponentInfo? = nil
    
    @Published var resizedComponentInfo: CardComponentInfo? = nil
    @Published var resizeOffset: CGSize? = nil
    @Published var resizePoint: ResizePoint? = nil
    
    // - MARK: Life cycle
    init() {
        ocr()
    }
}

// - MARK: Extension for text recognition
extension CropViewModel {
    func ocr() {
        let image = UIImage(named: "text")
        if let cgImage = image?.cgImage {
            // Request handler
            let handler = VNImageRequestHandler(cgImage: cgImage)
            let recognizeRequest = VNRecognizeTextRequest { request, _ in
                // Parse the results as text
                guard let result = request.results as? [VNRecognizedTextObservation] else {
                    return
                }
                // Extract the data
                let stringArray = result.compactMap { result in
                    result.topCandidates(1).first?.string
                }
                // Update the UI
                DispatchQueue.main.async {
                    self.recognizedText = stringArray.joined(separator: "\n")
                }
            }
            // Process the request
            recognizeRequest.recognitionLevel = .accurate
            do {
                try handler.perform([recognizeRequest])
            } catch {
                print(error)
            }
        }
    }
}

// - MARK: Extension for resizing
extension CropViewModel {
    // to change height and width
    func widthForCardComponent(info: CardComponentInfo) -> CGFloat {
        let widthOffset = (resizedComponentInfo?.id == info.id) ? (resizeOffset?.width ?? 0.0) : 0.0
        let width = info.size.width + widthOffset
        return max(width, 50)
    }
    
    func heightForCardComponent(info: CardComponentInfo) -> CGFloat {
        let heightOffset = (resizedComponentInfo?.id == info.id) ? (resizeOffset?.height ?? 0.0) : 0.0
        let height = info.size.height + heightOffset
        return max(height, 50)
    }

    func resizeEnded() {
        guard let resizedComponentInfo, let resizePoint, let resizeOffset else { return }
        var w: CGFloat = resizedComponentInfo.size.width
        var h: CGFloat = resizedComponentInfo.size.height
        var x: CGFloat = resizedComponentInfo.origin.x
        var y: CGFloat = resizedComponentInfo.origin.y
        switch resizePoint {
        case .topMiddle:
            h -= resizeOffset.height
            y += resizeOffset.height
        case .rightMiddle:
            w += resizeOffset.width
        case .bottomMiddle:
            h += resizeOffset.height
        case .leftMiddle:
            w -= resizeOffset.width
            x += resizeOffset.width
        }
        resizedComponentInfo.size = CGSize(width: w, height: h)
        resizedComponentInfo.origin = CGPoint(x: x, y: y)
        self.resizeOffset = nil
        self.resizePoint = nil
        self.resizedComponentInfo = nil
    }
    
    func updateForResize(using resizePoint: ResizePoint, deltaX: CGFloat, deltaY: CGFloat) {
        guard let resizedComponentInfo else { return }
        
        var width: CGFloat = resizedComponentInfo.size.width
        var height: CGFloat = resizedComponentInfo.size.height
        var x: CGFloat = resizedComponentInfo.origin.x
        var y: CGFloat = resizedComponentInfo.origin.y
        switch resizePoint {
        case .topMiddle:
            height -= deltaY
            y += deltaY
        case .rightMiddle:
            width += deltaX
        case .bottomMiddle:
            height += deltaY
        case .leftMiddle:
            width -= deltaX
            x += deltaX
        }
        resizedComponentInfo.size = CGSize(width: width, height: height)
        resizedComponentInfo.origin = CGPoint(x: x, y: y)
    }
    // to change position
    func xPositionForCardComponent(info: CardComponentInfo) -> CGFloat {
        let xPositionOffset = (draggedComponentInfo?.id == info.id) ? (dragOffset?.width ?? 0.0) : 0.0
        return info.origin.x + (info.size.width / 2.0) + xPositionOffset
    }
    
    func yPositionForCardComponent(info: CardComponentInfo) -> CGFloat {
        let yPositionOffset = (draggedComponentInfo?.id == info.id) ? (dragOffset?.height ?? 0.0) : 0.0
        return info.origin.y + (info.size.height / 2.0) + yPositionOffset
    }
    
    func updateForDrag(deltaX: CGFloat, deltaY: CGFloat) {
        dragOffset = CGSize(width: deltaX, height: deltaY)
    }
    
    func dragEnded() {
        guard let dragOffset else { return }
        draggedComponentInfo?.origin.x += dragOffset.width
        draggedComponentInfo?.origin.y += dragOffset.height
        draggedComponentInfo = nil
        self.dragOffset = nil
    }
}
