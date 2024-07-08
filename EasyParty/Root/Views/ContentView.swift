//
//  ContentView.swift
//  EasyParty
//
//  Created by Hugues Fils on 19/03/2024.
//

import SwiftUI
import Auth

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel
    
    var body: some View {
        if viewModel.isLoggedIn {
            TabBarView()
        } else {
            LoginView()
        }
    }
}


#Preview {
    ContentView(viewModel: ContentViewModel())
}
