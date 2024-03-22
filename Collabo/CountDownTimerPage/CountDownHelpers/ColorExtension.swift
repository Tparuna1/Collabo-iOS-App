//
//  ColorExtension.swift
//  Collabo
//
//  Created by tornike <parunashvili on 22.03.24.
//

import SwiftUI

// MARK: - Background color extension
extension Color {
    static let customBackgroundColor = Color(red: 251/255, green: 247/255, blue: 248/255)
}

// MARK: - Sheet Background color extension

extension Color {
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue)
    }
}
