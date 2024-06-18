//
//  PartyListView.swift
//  EasyParty
//
//  Created by Hugues Fils on 10/06/2024.
//

import SwiftUI

struct PartyListView: View {
    @State private var isShowingSettings = false
    
    var body: some View {
        NavigationStack {
            VStack{
                Spacer()
                
                Text("Hello world!")
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(.customBackground)
            .navigationTitle("Mes soirées")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        isShowingSettings = true
                    }) {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(Color("flamingo"))
                            .accessibilityLabel("Paramètres")
                    }
                }
            }
            .sheet(isPresented: $isShowingSettings) {
                
                if let data = UserDefaults.standard.object(forKey: "currentUser") as? Data, let user = try? JSONDecoder().decode(User.self, from: data) {
                    SettingsView(viewModel: SettingsViewModel(user: user, signOutUseCase: SettingsInjector.signOut(), deleteAccountUseCase: SettingsInjector.deleteAccountUseCase(), comfirmAppleSignInUseCase: SettingsInjector.comfirmAppleSignInUseCase()))
                }
            }
        }
    }
}


#Preview {
    PartyListView()
}
