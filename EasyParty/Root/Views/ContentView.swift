//
//  ContentView.swift
//  EasyParty
//
//  Created by Hugues Fils on 19/03/2024.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel
    
    var body: some View {
        if viewModel.isLoggedIn {
            SettingsView(viewModel: SettingsViewModel(signOutUseCase: AuthInjector.signOut()))
        } else {
            LoginView(viewModel: .init(loginWithAppleUseCase: AuthInjector.loginWithAppleUseCase(), buttonLoginInWithAppleUseCase: AuthInjector.buttonLoginInWithAppleUseCase(), loginWithGoogleUseCase: AuthInjector.loginWithGoogle(), getGoogleCredentialsUseCase: AuthInjector.getGoogleCredentialsUseCase()))
        }
    }
}


#Preview {
    ContentView(viewModel: ContentViewModel())
}
