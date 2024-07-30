//
//  LoginView.swift
//  EasyParty
//
//  Created by Hugues Fils on 12/04/2024.
//

import AuthenticationServices
import SwiftUI
import SharedDomain
import Factory

public struct LoginView: View {
    @StateObject private var viewModel: LoginViewModel
    
    public init(actions: LoginViewModelActions) {
        _viewModel = .init(wrappedValue: .init(actions: actions))
    }
    
    public var body: some View {
        VStack(spacing: 20) {
            
            IntroLogin()
                .padding(.top, 20)
            
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
            
            
            Label("Continuer avec l'email", systemImage: "envelope")
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(.black)
                .background(Color.white)
                .cornerRadius(10)
                .onTapGesture {
                    viewModel.mailLoginBtnTapped()
                }
            
        }
        .padding()
    }
}

#Preview {
    LoginView(actions: .init(showMailLogin: {}))
}
