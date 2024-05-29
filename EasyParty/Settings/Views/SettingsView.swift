//
//  SettingsView.swift
//  EasyParty
//
//  Created by Hugues Fils on 25/03/2024.
//

import PhotosUI
import SwiftUI

struct SettingsView: View {
  @ObservedObject var viewModel: AuthViewModel
  @State private var showingDeleteAlert = false
  @Environment(\.dismiss) var dismiss

  @State private var selectedItems: [PhotosPickerItem] = []
  @State private var isImageLoading = false

  var body: some View {
    NavigationStack {
        VStack {
            Text( viewModel.fullName ?? "Utilisateur")
              .font(.title)
            
          Spacer()

          VStack {
            List {
              Button {

              } label: {
                HStack {
                  Image(systemName: "arrowshape.turn.up.right")
                    .foregroundStyle(.blue)
                  Text("Partager Easy Party")
                    .foregroundStyle(.black)
                  Spacer()
                  Image(systemName: "chevron.right")
                    .foregroundStyle(.flamingo)
                }

              }

              Button {

              } label: {
                HStack {
                  Image(systemName: "doc")
                    .foregroundStyle(.green)
                  Text("Termes et conditions")
                    .foregroundStyle(.black)
                  Spacer()
                  Image(systemName: "chevron.right")
                    .foregroundStyle(.flamingo)
                }

              }

              DisclosureGroup("Compte") {
                Button {
                  viewModel.signOut()
                } label: {
                  HStack {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                      .foregroundStyle(.yellow)
                    Text("Se déconnecter")
                  }

                }
                Button {
                  showingDeleteAlert = true
                } label: {
                  HStack(spacing: 13) {
                    Image(systemName: "trash")
                      .foregroundStyle(.red)
                    Text("Supprimer compte")
                      .foregroundStyle(.red)
                  }
                }
              }
            }.scrollContentBackground(.hidden)
              .scrollDisabled(true)

          }

        }
      }
    .background(.customBackground)
      .actionSheet(isPresented: $showingDeleteAlert) {  // ActionSheet pour confirmation
        ActionSheet(
          title: Text("Confirmez la suppression"),
          message: Text(
            "Êtes-vous sûr de vouloir supprimer définitivement votre compte? Cette action est irréversible."
          ),
          buttons: [
            .destructive(
              Text("Supprimer"),
              action: {
//                Task {
//                  await viewModel.deleteAccount()
//
//                }
                dismiss()
              }),
            .cancel(),
          ]
        )
      }
      .toolbar(.hidden, for: .tabBar)
      .navigationTitle("Paramètres")
      .navigationBarTitleDisplayMode(.inline)
      .navigationBarItems(
        trailing: Button("Fermer") {
//          viewModel.saveProfileChanges()
          dismiss()
        }
        .foregroundStyle(.flamingo)
        .fontWeight(.bold)
      )
      .onAppear {
                  viewModel.loadUserInfo()
              }
  }
        
}

#Preview {
    SettingsView(viewModel: .init(loginWithAppleUseCase: AuthInjector.loginWithAppleUseCase(), buttonLoginInWithAppleUseCase: AuthInjector.buttonLoginInWithAppleUseCase(), loginWithGoogleUseCase: AuthInjector.loginWithGoogle(), getGoogleCredentialsUseCase: AuthInjector.getGoogleCredentialsUseCase(), signOutUseCase: AuthInjector.signOut()))
}
