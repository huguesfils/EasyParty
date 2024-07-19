//
//  SettingsView.swift
//  EasyParty
//
//  Created by Hugues Fils on 25/03/2024.
//

import PhotosUI
import SwiftUI
import SharedDomain

public struct SettingsView: View {
    @StateObject private var viewModel: SettingsViewModel
    @State private var showingDeleteAlert = false
    @State private var showingAppleSignInAlert = false
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var isImageLoading = false
    @State private var navigateToTerms = false
    @State private var showingShareSheet = false
    
    public init(user: User) {
        _viewModel = .init(wrappedValue: .init(user: user))
    }
    
    public var body: some View {
        
        VStack {
            Text(viewModel.user.fullname)
                .font(.title)
            
            Spacer()
            
            VStack {
                List {
                    Button {
                        showingShareSheet = true
                    } label: {
                        HStack {
                            Image(systemName: "arrowshape.turn.up.right")
                                .foregroundStyle(.blue)
                            Text("Partager Easy Party")
                                .foregroundStyle(.black)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(Color.ds.flamingo)
                        }
                    }
                    .sheet(isPresented: $showingShareSheet) {
                        ActivityView(activityItems: ["Découvrez l'application Easy Party ! Téléchargez-la ici : [lien de téléchargement]"])
                    }
                    
                    
                    
                    Button {
                        navigateToTerms = true
                    } label: {
                        HStack {
                            Image(systemName: "doc")
                                .foregroundStyle(.green)
                            Text("Termes et conditions")
                                .foregroundStyle(.black)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(Color.ds.flamingo)
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
                }
                .scrollContentBackground(.hidden)
                .scrollDisabled(true)
            }
        }
        .background(Color.ds.customBackground)
        .actionSheet(isPresented: $showingDeleteAlert) {
            ActionSheet(
                title: Text("Confirmez la suppression"),
                message: Text(
                    "Êtes-vous sûr de vouloir supprimer définitivement votre compte? Cette action est irréversible."
                ),
                buttons: [
                    .destructive(
                        Text("Supprimer"),
                        action: {
                            if viewModel.user.connectionType == .apple {
                                showingAppleSignInAlert = true
                            } else {
                                Task {
                                    viewModel.deleteAccount()
                                }
                                dismiss()
                            }
                        }),
                    .cancel(),
                ]
            )
        }
        .sheet(isPresented: $showingAppleSignInAlert) {
            AppleSignInAlertView(viewModel: viewModel)
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationTitle("Paramètres")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            trailing: Button("Fermer") {
                dismiss()
            }
                .foregroundStyle(Color.ds.flamingo)
                .fontWeight(.bold)
        )
        .navigationDestination(isPresented: $navigateToTerms) {
            TermsAndConditionsView()
        }
    }
}

@ViewBuilder
private func AppleSignInAlertView(viewModel: SettingsViewModel) -> some View {
    ZStack{
        Color.ds.customBackground.edgesIgnoringSafeArea(.all)
        VStack {
            Text("Pour supprimer votre compte, merci de vous reconnecter.")
                .padding()
                .multilineTextAlignment(.center)
            viewModel.getAppleSignInButton()
                .frame(maxWidth: .infinity, maxHeight: 50)
                .cornerRadius(10)
        }
        .presentationDetents([.height(200)])
        .presentationDragIndicator(.visible)
        .padding()
    }
}

#Preview {
    SettingsView(user: User.mock)
}
