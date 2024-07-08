//
//  ResetPasswordView.swift
//  EasyParty
//
//  Created by Hugues Fils on 12/04/2024.
//

import SwiftUI
import SharedDomain

struct ResetPasswordView: View {

  @ObservedObject var viewModel: ResetPasswordViewModel

  @Environment(\.dismiss) private var dismiss

  var body: some View {
    NavigationStack {
      ZStack {
          Color.ds.customBackground.ignoresSafeArea()
        VStack {
          IntroLogin().frame(maxWidth: .infinity)

          CustomFormField(text: $viewModel.email, header: "EMAIL", icon: "envelope")
          Text(
            "Si l'adresse e-mail fournie est associée à un compte utilisateur, un lien de réinitialisation de mot de passe vous sera envoyé."
          )
          .font(.footnote)
          .foregroundColor(.gray)
          .padding()
          .multilineTextAlignment(.center)

          Spacer()

          VStack {
            Button(action: {
              Task {
                  await viewModel.resetPassword()
                dismiss()
              }
            }) {
              Text("Réinitialiser")
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, minHeight: 48)
                .background(Color.ds.flamingo)
                .cornerRadius(50)
                .opacity(viewModel.formIsValid ? 1.0 : 0.5)
            }
            .disabled(!viewModel.formIsValid)

          }

        }.padding()
      }
    }
  }
}

#Preview {
  ResetPasswordView(viewModel: .init())
}
