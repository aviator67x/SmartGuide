//
//  UIWindow+.swift
//  SmartGuide
//
//  Created by Andrew Kasilov on 21.06.2024.
//

import UIKit

extension UIWindow {
    static var keyWindow: UIWindow? {
        return UIApplication
            .shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first { $0.isKeyWindow }
    }
}
