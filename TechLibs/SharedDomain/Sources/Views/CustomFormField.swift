//
//  CustomFormField.swift
//  EasyParty
//
//  Created by Hugues Fils on 14/04/2024.
//

import SwiftUI

public struct CustomFormField: View {
    @State private var isPasswordVisible = false
    @Binding var text: String
    let header: String
    let icon: String
    let isSecure: Bool
    let confirmText: String
    
    public init(text: Binding<String>, header: String, icon: String, isSecure: Bool = false, confirmText: String = "") {
        self._text = text
        self.header = header
        self.icon = icon
        self.isSecure = isSecure
        self.confirmText = confirmText
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            Text(header)
                .padding(.horizontal)
                .font(.footnote)
                .foregroundColor(.gray)
            ZStack(alignment: .trailing) {
                HStack {
                    Image(systemName: icon)
                        .color(.ds.flamingo)
                    
                    if isSecure && !isPasswordVisible {
                        SecureField("", text: $text)
                            .textInputAutocapitalization(.never)
                    } else {
                        TextField("", text: $text)
                            .textInputAutocapitalization(.never)
                    }
                    
                    if isSecure {
                        Button(action: {
                            isPasswordVisible.toggle()
                        }) {
                            Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                .background(Color.white.opacity(0.5))
                .cornerRadius(10)
            }
        }
        .padding(.top, 15)
    }
}
