//
//  MailLoginView.swift
//  EasyParty
//
//  Created by Hugues Fils on 12/04/2024.
//

import SwiftUI

private enum FocusableField: Hashable {
  case email
  case password
}

struct MailLoginView: View {
  @EnvironmentObject var viewModel: AuthViewModel
  @FocusState private var focus: FocusableField?

  var body: some View {
    NavigationStack {
      ZStack {
        Color.customBackground.ignoresSafeArea()
        GeometryReader { geometry in
          ScrollView {
            VStack {
              VStack {
                IntroLogin().frame(maxWidth: .infinity)
                CustomFormField(text: $viewModel.email, header: "EMAIL", icon: "envelope")
                  .focused($focus, equals: .email)
                  .submitLabel(.next)
                  .onSubmit {
                    self.focus = .password
                  }

                CustomFormField(
                  text: $viewModel.password, header: "MOT DE PASSE", icon: "lock", isSecure: true
                )
                .focused($focus, equals: .password)
                .submitLabel(.go)
                .onSubmit {
                  Task {
                    await viewModel.signInWithEmailPassword()
                  }
                }

                NavigationLink {
                  ResetPasswordView()
                } label: {
                  Text("Mot de passe oublié ?")
                    .font(.system(size: 13, weight: .semibold))

                }
                .padding(.top, 15)
                .frame(maxWidth: .infinity, alignment: .trailing)
              }

              Spacer()

              VStack {
                Button(action: {
                  Task {
                    await viewModel.signInWithEmailPassword()
                  }
                }) {
                  Text("Se connecter")
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, minHeight: 48)
                    .background(Color.flamingo)
                    .cornerRadius(50)
                    .opacity(formIsValid ? 1.0 : 0.5)
                }
                .disabled(!formIsValid)

                NavigationLink {
                  RegisterView()
                } label: {
                  HStack {
                    Text("Vous n'avez pas de compte ?")
                    Text("S'enregister")
                      .fontWeight(.bold)
                      .foregroundStyle(.flamingo)
                  }
                  .font(.system(size: 14))
                  .padding()
                }
              }
            }
            .padding()
            .frame(minHeight: geometry.size.height)
          }
        }
        if viewModel.authenticationState == .authenticating {
          CustomProgressView()
        }
      }
      .alert(isPresented: $viewModel.showAlert) {
        Alert(
          title: Text("Erreur"),
          message: Text(viewModel.authError?.description ?? ""))
      }
    }
  }
}

extension MailLoginView: AuthenticationFormProtocol {
  var formIsValid: Bool {
    return !viewModel.email.isEmpty
      && viewModel.email.contains("@")
      && !viewModel.password.isEmpty
      && viewModel.password.count > 5
  }
}

#Preview {
  MailLoginView().environmentObject(AuthViewModel())
}
