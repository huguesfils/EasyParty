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
                SettingsView(viewModel: SettingsViewModel(signOutUseCase: AuthInjector.signOut(), deleteAccountUseCase: AuthInjector.deleteAccountUseCase()))
            }
        }
        
        
    }
}


#Preview {
    PartyListView()
}
