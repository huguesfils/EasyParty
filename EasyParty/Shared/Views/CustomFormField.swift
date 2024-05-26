//
//  CustomFormField.swift
//  EasyParty
//
//  Created by Hugues Fils on 14/04/2024.
//

import SwiftUI

struct CustomFormField: View {
  @State private var isPasswordVisible = false
  @Binding var text: String
  var header: String
  var icon: String
  var isSecure: Bool = false
  var confirmText: String = ""

  var body: some View {
    VStack(alignment: .leading) {
      Text(header)
        .padding(.horizontal)
        .font(.footnote)
        .foregroundColor(.gray)
      ZStack(alignment: .trailing) {
        HStack {
          Image(systemName: icon)
            .foregroundStyle(.flamingo)

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
