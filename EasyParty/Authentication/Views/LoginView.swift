//
//  LoginView.swift
//  EasyParty
//
//  Created by Hugues Fils on 12/04/2024.
//

import AuthenticationServices
import SwiftUI

struct LoginView: View {
  @ObservedObject var viewModel: AuthViewModel

  var body: some View {
    NavigationStack {
      ZStack {
        Color.customBackground.ignoresSafeArea()
        VStack(spacing: 20) {

          IntroLogin()

          Spacer()

          VStack(spacing: 18) {
//            SignInWithAppleButton(.signIn) { request in
//              viewModel.handleSignInWithAppleRequest(request)
//            } onCompletion: { result in
//              viewModel.handleSignInWithAppleCompletion(result)
//            }
//            .frame(maxWidth: .infinity, maxHeight: 50)
//            .cornerRadius(10)

            Button {
              Task {
                await viewModel.signInWithGoogle()
              }
            } label: {
              HStack(
                alignment: /*@START_MENU_TOKEN@*/ .center /*@END_MENU_TOKEN@*/,
                content: {
                  Image("googleIcon")
                  Text("Se connecter avec Google")
                }
              )
              .frame(maxWidth: .infinity, maxHeight: 50)
              .cornerRadius(10)

            }
            .frame(maxWidth: .infinity, maxHeight: 50)
            .cornerRadius(10)
            .buttonStyle(.bordered)

            NavigationLink(destination: MailLoginView()) {
              Label("Continuer avec l'email", systemImage: "envelope")
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(.black)
                .background(Color.white)
                .cornerRadius(10)
            }
          }

          Spacer()
        }
        .padding()

        if viewModel.authenticationState == .authenticating {
          CustomProgressView()
        }

      }
      .navigationTitle("Connexions")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .principal) {
          Text("Titre Invisible").opacity(0)
        }
      }
    }

  }
}

//#Preview {
//  LoginView().environmentObject(AuthViewModel())
//}
