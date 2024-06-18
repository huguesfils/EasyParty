//
//  CustomDisclosureGroup.swift
//  EasyParty
//
//  Created by Hugues Fils on 03/05/2024.
//

import SwiftUI

public struct CustomDisclosureGroup<Content: View>: View {
    let title: String
    let icon: String
    @ViewBuilder var content: () -> Content
    @State private var isExpanded: Bool = false
    
    public var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            })
            {
                HStack {
                    Image(systemName: icon)
                        .color(.ds.flamingo)
                    Text(title)
                        .padding(.horizontal, 10)
                    //                        .fontWeight(.semibold)
                        .font(.system(size: 16, weight: .semibold))
                        .color(.ds.flamingo)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                        .animation(.easeInOut(duration: 0.3), value: isExpanded)
                        .color(.ds.flamingo)
                }
                .contentShape(Rectangle())
            }
            .padding()
            .background(.white.opacity(0.5))
            .cornerRadius(10)
            
            if isExpanded {
                withAnimation{
                    content()
                        .padding(.leading)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
        }.buttonStyle(PlainButtonStyle())
    }
}
