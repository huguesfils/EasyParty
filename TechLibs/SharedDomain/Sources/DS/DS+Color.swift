//
//  DS+Color.swift
//
//
//  Created by Hugues Fils on 18/06/2024.
//

import SwiftUI

public extension Color {
    struct ds {}
}

public extension Color.ds {
    static let flamingo = Color(hex: 0xFF6A82)
    static let blueSky = Color(hex: 0x73FAE7)
    static let customBackground = Color(hex: 0xF1EEE6)
}



private extension Color {
    init(hex: Int, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: opacity
        )
    }
}
