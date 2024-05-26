//
//  PartyListView.swift
//  EasyParty
//
//  Created by Hugues Fils on 19/03/2024.
//

import SwiftUI

struct PartyListView: View {
  @StateObject var viewModel = PartyListViewModel()
  @State private var isShowingSettings = false

  var body: some View {
    NavigationStack {
      ZStack {
        Color("customBackground").ignoresSafeArea()
        List {
          ForEach(viewModel.parties) { party in
            Button(action: {
              viewModel.startEditingParty(party)
            }) {
              PartyView(party: party)

            }
            .listRowBackground(Color.customBackground)

            .listSectionSeparator(.hidden)
            .listRowSeparator(.hidden)
          }
        }
        .listStyle(.inset)
        .scrollContentBackground(.hidden)
      }
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
    }
    .sheet(isPresented: $viewModel.showingAddPartyView) {
      AddPartyView(viewModel: viewModel, party: viewModel.editingParty)
    }
    .sheet(isPresented: $isShowingSettings) {
      SettingsView()
    }

  }
}

#Preview {
  PartyListView()
}
