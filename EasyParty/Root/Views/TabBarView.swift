//
//  TabBarView.swift
//  EasyParty
//
//  Created by Hugues Fils on 19/03/2024.
//

import SwiftUI
import Parties

struct TabBarView: View {
    @State var isPresenting = false
    @State private var selection = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selection) {
                PartiesInjector.getPartyListView()
                    .tabItem {
                        Label("Mes soirées", systemImage: "party.popper.fill")
                    }
                    .tag(0)
                
                Spacer()
                    .tabItem {
                        EmptyView()
                    }.frame(width: 1)
                    .tag(1)
                
                PartiesInjector.getInviteListView()
                    .tabItem {
                        Label("Mes invitations", systemImage: "calendar.badge.plus")
                    }
                    .tag(2)
            }
            Button {
                self.isPresenting = true
            } label: {
                VStack(alignment: .center, spacing: 4) {
                    Image("mainIcon")
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .frame(height: 32)
                    Text("Créer")
                        .font(.system(size: 10))
                        .fontWeight(.bold)
                }
            }.tint(Color.flamingo)
        }
        .ignoresSafeArea(.keyboard)
        .onChange(of: selection) { [selection] newValue in
            if newValue == 1 {
                self.selection = selection
            }
        }
        .sheet(isPresented: $isPresenting) {
            PartiesInjector.getAddPartyView()
        }
    }
}

#Preview {
    TabBarView()
}
