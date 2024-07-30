//
//  MailLoginView.swift
//  EasyParty
//
//  Created by Hugues Fils on 12/04/2024.
//

import SwiftUI
import SharedDomain

private enum FocusableField: Hashable {
    case email
    case password
}

public struct MailLoginView: View {
    @StateObject private var viewModel: MailLoginViewModel
    @FocusState private var focus: FocusableField?
    
    public init(actions: MailLoginViewModelActions) {
        _viewModel = .init(wrappedValue: .init(actions: actions))
    }
    
    
    public var body: some View {
        ZStack {
            Color.ds.customBackground.ignoresSafeArea()
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
                            
                            Button(action: {
                                viewModel.resetPasswordBtnTapped()
                            }, label: {
                                Text("Mot de passe oublié ?")
                                    .font(.system(size: 13, weight: .semibold))
                            })
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
                                    .background(Color.ds.flamingo)
                                    .cornerRadius(50)
                                    .opacity(viewModel.formIsValid ? 1.0 : 0.5)
                            }
                            .disabled(!viewModel.formIsValid)
                            
                            Button(action: {
                                viewModel.registerBtnTapped()
                            }, label: {
                                HStack {
                                    Text("Vous n'avez pas de compte ?")
                                    Text("S'enregister")
                                        .fontWeight(.bold)
                                        .color(.ds.flamingo)
                                }
                                .font(.system(size: 14))
                                .padding()
                            })
                            
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

#Preview {
    MailLoginView(actions: .init(showRegister: {}, showResetPassword: {}))
}
