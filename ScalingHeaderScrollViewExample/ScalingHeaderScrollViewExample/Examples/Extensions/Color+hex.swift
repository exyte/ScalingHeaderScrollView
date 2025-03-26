//
//  UIColor+hex.swift
//  Example
//
//  Created by Danil Kristalev on 02.11.2021.
//  Copyright © 2021 Exyte. All rights reserved.
//

import UIKit
import SwiftUI

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x0000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: 1)
                    return
                }
            }
        }

        return nil
    }
}

extension Color {
    static func hex(_ hex: String) -> Color {
        guard let uiColor = UIColor(hex: hex) else {
            return Color.red
        }
        return Color(uiColor)
    }
}
