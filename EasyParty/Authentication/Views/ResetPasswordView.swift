//
//  ResetPasswordView.swift
//  EasyParty
//
//  Created by Hugues Fils on 12/04/2024.
//

import SwiftUI

struct ResetPasswordView: View {

  @EnvironmentObject var viewModel: AuthViewModel

  @Environment(\.dismiss) private var dismiss

  var body: some View {
    NavigationStack {
      ZStack {
        Color.customBackground.ignoresSafeArea()
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
                viewModel.sendResetPasswordLink(toEmail: viewModel.email)
                dismiss()
              }
            }) {
              Text("Réinitialiser")
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, minHeight: 48)
                .background(Color.flamingo)
                .cornerRadius(50)
                .opacity(formIsValid ? 1.0 : 0.5)
            }
            .disabled(!formIsValid)

          }

        }.padding()
      }
    }
  }
}

extension ResetPasswordView: AuthenticationFormProtocol {
  var formIsValid: Bool {
    return !viewModel.email.isEmpty
      && viewModel.email.contains("@")
  }
}

#Preview {
  ResetPasswordView().environmentObject(AuthViewModel())
}
