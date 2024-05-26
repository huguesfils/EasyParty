//
//  RegisterView.swift
//  EasyParty
//
//  Created by Hugues Fils on 12/04/2024.
//

import SwiftUI

private enum FocusableField: Hashable {
  case email
  case password
  case fullname
  case confirmPassword
}

struct RegisterView: View {
  @EnvironmentObject var viewModel: AuthViewModel
  @FocusState private var focus: FocusableField?

  var body: some View {
    NavigationStack {
      ZStack {
        Color.customBackground.ignoresSafeArea()
        ScrollView {
          VStack {
            IntroLogin().frame(maxWidth: .infinity)

            CustomFormField(text: $viewModel.fullname, header: "NOM COMPLET", icon: "person")
              .disableAutocorrection(true)
              .focused($focus, equals: .fullname)
              .submitLabel(.next)
              .onSubmit {
                self.focus = .email
              }
            CustomFormField(text: $viewModel.email, header: "EMAIL", icon: "envelope")
              .disableAutocorrection(true)
              .focused($focus, equals: .email)
              .submitLabel(.next)
              .onSubmit {
                self.focus = .password
              }
            CustomFormField(
              text: $viewModel.password, header: "MOT DE PASSE", icon: "lock", isSecure: true
            )
            .focused($focus, equals: .password)
            .submitLabel(.next)
            .onSubmit {
              self.focus = .confirmPassword
            }
            CustomFormField(
              text: $viewModel.confirmPassword, header: "CONFIRMER MOT DE PASSE", icon: "lock",
              isSecure: true, confirmText: viewModel.password
            )
            .focused($focus, equals: .confirmPassword)
            .submitLabel(.go)
            .onSubmit {
              Task {
                await viewModel.signUpWithEmailPassword()
              }
            }

            Spacer()

            VStack {
              Button(action: {
                Task {
                  await viewModel.signUpWithEmailPassword()
                }
              }) {
                Text("S'enregistrer")
                  .fontWeight(.semibold)
                  .foregroundStyle(.white)
                  .frame(maxWidth: .infinity, minHeight: 48)
                  .background(Color.flamingo)
                  .cornerRadius(50)
                  .opacity(formIsValid ? 1.0 : 0.5)
              }
              .padding(.top, 15)
              .disabled(!formIsValid)
            }

          }
          .padding()
        }

        if viewModel.isLoading {
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

extension RegisterView: AuthenticationFormProtocol {
  var formIsValid: Bool {
    return !viewModel.email.isEmpty
      && viewModel.email.contains("@")
      && !viewModel.password.isEmpty
      && viewModel.password.count > 5
      && viewModel.confirmPassword == viewModel.password
      && !viewModel.fullname.isEmpty
  }
}

#Preview {
  RegisterView().environmentObject(AuthViewModel())
}
