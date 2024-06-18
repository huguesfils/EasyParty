//
//  View++.swift
//
//
//  Created by Hugues Fils on 18/06/2024.
//

import SwiftUI

public extension View {
    func color(_ value: Color) -> some View {
        if #available(iOS 15.0, *) {
            return self.foregroundStyle(value)
        } else {
            return self.foregroundColor(value)
        }
    }
}

