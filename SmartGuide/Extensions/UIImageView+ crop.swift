//
//  UIImageView+ crop.swift
//  SmartGuide
//
//  Created by Andrew Kasilov on 10.06.2024.
//

import UIKit

extension UIImageView {
    func image(at rect: CGRect) -> UIImage? {
        guard
            let image = image,
            let convertecRect = convertToImageCoordinates(rect)
        else {
            return nil
        }

        guard let cutImage: CGImage = image.cgImage?.cropping(to: convertecRect) else {
            return nil
        }
        return UIImage(cgImage: cutImage)
    }

    func convertToImageCoordinates(_ rect: CGRect) -> CGRect? {
        guard let image = image else { return nil }

        let imageSize = CGSize(width: image.size.width, height: image.size.height)
        let imageCenter = CGPoint(x: imageSize.width / 2, y: imageSize.height / 2)

        let imageViewRatio = bounds.width / bounds.height
        let imageRatio = imageSize.width / imageSize.height

        let scale: CGPoint

        switch contentMode {
        case .scaleToFill:
            scale = CGPoint(x: imageSize.width / bounds.width, y: imageSize.height / bounds.height)

        case .scaleAspectFit:
            let value: CGFloat
            if imageRatio < imageViewRatio {
                value = imageSize.height / bounds.height
            } else {
                value = imageSize.width / bounds.width
            }
            scale = CGPoint(x: value, y: value)

        case .scaleAspectFill:
            let value: CGFloat
            if imageRatio > imageViewRatio {
                value = imageSize.height / bounds.height
            } else {
                value = imageSize.width / bounds.width
            }
            scale = CGPoint(x: value, y: value)

        case .center:
            scale = CGPoint(x: 1, y: 1)

        // unhandled cases include
        // case .redraw:
        // case .top:
        // case .bottom:
        // case .left:
        // case .right:
        // case .topLeft:
        // case .topRight:
        // case .bottomLeft:
        // case .bottomRight:

        default:
            fatalError("Unexpected contentMode")
        }

        var rect = rect
        if rect.width < 0 {
            rect.origin.x += rect.width
            rect.size.width = -rect.width
        }

        if rect.height < 0 {
            rect.origin.y += rect.height
            rect.size.height = -rect.height
        }

        return CGRect(x: (rect.minX - bounds.midX) * scale.x + imageCenter.x,
                      y: (rect.minY - bounds.midY) * scale.y + imageCenter.y,
                      width: rect.width * scale.x,
                      height: rect.height * scale.y)
    }
}
