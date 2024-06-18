//
//  CustomProgressView.swift
//  EasyParty
//
//  Created by Hugues Fils on 14/04/2024.
//

import SwiftUI

public struct CustomProgressView: View {
    public init() {}
    
    public var body: some View {
        ProgressView()
            .progressViewStyle(.circular)
            .accentColor(.white)
            .scaleEffect(x: 1.5, y: 1.5, anchor: .center)
            .frame(width: 80, height: 80)
            .background(Color(.systemGray4))
            .cornerRadius(20)
    }
}

#Preview {
    CustomProgressView()
}
