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
  @ObservedObject var viewModel: AuthViewModel
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
                    ResetPasswordView(viewModel: .init(loginWithEmailUseCase: AuthInjector.loginWithEmailUseCase(), registerWithEmailUseCase: AuthInjector.registerWithEmailUseCase(), loginWithAppleUseCase: AuthInjector.loginWithAppleUseCase(), buttonLoginInWithAppleUseCase: AuthInjector.buttonLoginInWithAppleUseCase(), loginWithGoogleUseCase: AuthInjector.loginWithGoogle(), getGoogleCredentialsUseCase: AuthInjector.getGoogleCredentialsUseCase(), resetPasswordUseCase: AuthInjector.resetPasswordUseCase()))
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
                  RegisterView(viewModel: .init(loginWithEmailUseCase: AuthInjector.loginWithEmailUseCase(), registerWithEmailUseCase: AuthInjector.registerWithEmailUseCase(), loginWithAppleUseCase: AuthInjector.loginWithAppleUseCase(), buttonLoginInWithAppleUseCase: AuthInjector.buttonLoginInWithAppleUseCase(), loginWithGoogleUseCase: AuthInjector.loginWithGoogle(), getGoogleCredentialsUseCase: AuthInjector.getGoogleCredentialsUseCase(), resetPasswordUseCase: AuthInjector.resetPasswordUseCase()))
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
        if viewModel.isLoading == true {
          CustomProgressView()
        }
      }
      .alert(isPresented: $viewModel.showAlert) {
        Alert(
          title: Text("Erreur"),
          message: Text(viewModel.hasError?.localizedDescription ?? ""))
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
  MailLoginView(viewModel: .init(loginWithEmailUseCase: AuthInjector.loginWithEmailUseCase(), registerWithEmailUseCase: AuthInjector.registerWithEmailUseCase(), loginWithAppleUseCase: AuthInjector.loginWithAppleUseCase(), buttonLoginInWithAppleUseCase: AuthInjector.buttonLoginInWithAppleUseCase(), loginWithGoogleUseCase: AuthInjector.loginWithGoogle(), getGoogleCredentialsUseCase: AuthInjector.getGoogleCredentialsUseCase(), resetPasswordUseCase: AuthInjector.resetPasswordUseCase()))
}
