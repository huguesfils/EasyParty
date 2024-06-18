//
//  LoginView.swift
//  EasyParty
//
//  Created by Hugues Fils on 12/04/2024.
//

import AuthenticationServices
import SwiftUI
import SharedDomain

struct LoginView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                IntroLogin()
                
                Spacer()
                
                if viewModel.isLoading {
                    CustomProgressView()
                } else {
                    buttons()
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(Color.ds.customBackground)
            .navigationTitle("Connexions")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Titre Invisible").opacity(0)
                }
            }
        }
    }
    
    @ViewBuilder
    private func buttons() -> some View {
        VStack(spacing: 18) {
            viewModel.getAppleSignInButton()
                .frame(maxWidth: .infinity, maxHeight: 50)
                .cornerRadius(10)
            
            Button {
                Task {
                    await viewModel.loginWithGoogle()
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
            
            NavigationLink(destination: MailLoginView(viewModel: .init(loginWithEmailUseCase: AuthInjector.loginWithEmailUseCase(), registerWithEmailUseCase: AuthInjector.registerWithEmailUseCase(), loginWithAppleUseCase: AuthInjector.loginWithAppleUseCase(), buttonLoginInWithAppleUseCase: AuthInjector.buttonLoginInWithAppleUseCase(), loginWithGoogleUseCase: AuthInjector.loginWithGoogle(), getGoogleCredentialsUseCase: AuthInjector.getGoogleCredentialsUseCase(), resetPasswordUseCase: AuthInjector.resetPasswordUseCase()))) {
                Label("Continuer avec l'email", systemImage: "envelope")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.black)
                    .background(Color.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}

#Preview {
    LoginView(viewModel: .init(loginWithEmailUseCase: AuthInjector.loginWithEmailUseCase(), registerWithEmailUseCase: AuthInjector.registerWithEmailUseCase(), loginWithAppleUseCase: AuthInjector.loginWithAppleUseCase(), buttonLoginInWithAppleUseCase: AuthInjector.buttonLoginInWithAppleUseCase(), loginWithGoogleUseCase: AuthInjector.loginWithGoogle(), getGoogleCredentialsUseCase: AuthInjector.getGoogleCredentialsUseCase(), resetPasswordUseCase: AuthInjector.resetPasswordUseCase()))
}
        
