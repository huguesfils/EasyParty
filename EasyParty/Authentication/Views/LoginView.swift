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
            .padding()
            .background(.customBackground)
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
            
            //            NavigationLink(destination: MailLoginView()) {
            //              Label("Continuer avec l'email", systemImage: "envelope")
            //                .frame(maxWidth: .infinity)
            //                .padding()
            //                .foregroundColor(.black)
            //                .background(Color.white)
            //                .cornerRadius(10)
            //            }
        }
    }
}

#Preview {
    LoginView(viewModel: .init(loginWithAppleUseCase: AuthInjector.loginWithAppleUseCase(), buttonLoginInWithAppleUseCase: AuthInjector.buttonLoginInWithAppleUseCase()))
}
