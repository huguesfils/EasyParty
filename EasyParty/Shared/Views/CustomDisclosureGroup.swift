//
//  CustomDisclosureGroup.swift
//  EasyParty
//
//  Created by Hugues Fils on 03/05/2024.
//

import SwiftUI

struct CustomDisclosureGroup<Content: View>: View {
    let title: String
    let icon: String
    @ViewBuilder var content: () -> Content
    @State private var isExpanded: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            })
            {
                HStack {
                    Image(systemName: icon)
                        .foregroundStyle(.flamingo)
                    Text(title)
                        .padding(.horizontal, 10)
                        .fontWeight(.semibold)
                        .foregroundStyle(.flamingo)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                        .animation(.easeInOut(duration: 0.3), value: isExpanded)
                        .foregroundStyle(.flamingo)
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
