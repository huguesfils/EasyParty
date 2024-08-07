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
    @StateObject private var viewModel: PartyListViewModel
    
    public init(actions: PartyListViewModelActions) {
        _viewModel = .init(wrappedValue: .init(actions: actions))
    }
    
    public var body: some View {
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
                Button(action: {
                    viewModel.settingsBtnTapped()
                }) {
                    Image(systemName: "gearshape.fill")
                        .foregroundColor(Color("flamingo"))
                        .accessibilityLabel("Paramètres")
                }
            }
        }
    }
}


#Preview {
    PartyListView(actions: .init(showSettings: {}))
}
