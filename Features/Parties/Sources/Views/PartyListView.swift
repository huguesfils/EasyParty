//
//  PartyListView.swift
//  EasyParty
//
//  Created by Hugues Fils on 10/06/2024.
//

import SwiftUI
import SharedDomain
import Settings

public struct PartyListView: View {
    @State private var isShowingSettings = false
    
    public init() { }
    
    public var body: some View {
        NavigationStack {
            VStack{
                Spacer()
                
                Text("Hello world!")
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(Color.ds.customBackground)
            .navigationTitle("Mes soirées")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if let data = UserDefaults.standard.object(forKey: "currentUser") as? Data, let user = try? JSONDecoder().decode(User.self, from: data) {
                        NavigationLink(destination: SettingsView(user: user)) {
                            Image(systemName: "gearshape.fill")
                                .foregroundColor(Color("flamingo"))
                                .accessibilityLabel("Paramètres")
                        }
                    }
                }
            }
        }
    }
}


#Preview {
    PartyListView()
}
