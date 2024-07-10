//
//  AddPartyView.swift
//  EasyParty
//
//  Created by Hugues Fils on 10/06/2024.
//

import PhotosUI
import SwiftUI
import SharedDomain

public struct AddPartyView: View {
//    @StateObject private var viewModel: AddPartyListViewModel
//    @Environment(\.dismiss) var dismiss
//    @State private var showPartyItemSheet = false
//    public init(party: Party?) {
//        _viewModel = .init(wrappedValue: .init(party: party ?? nil))
//    }
//    
    public var body: some View {
        Text("hello")
//        NavigationStack {
//            ScrollView {
//                VStack {
//                    photoPickerView()
//                    
//                    VStack {
//                        CustomFormField(text: $viewModel.title, header: "TITRE", icon: "party.popper.fill")
//                            .disableAutocorrection(true)
//                            .submitLabel(.next)
//                        
//                        CustomDateField(selectedDate: $viewModel.date, header: "DATE", icon: "calendar")
//                        
//                    }
//                    
//                }
//                .padding()
//                
//                
//            }
//            .background(Color.ds.customBackground)
//        }
//        .navigationTitle(viewModel.party?.title ?? "Nouvelle soirée")
//        .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//            ToolbarItem(placement: .topBarLeading) {
//                Button(action: {
//                    dismiss()
//                }) {
//                    Image(systemName: "Trash")
//                        .foregroundStyle(.red)
//                }
//            }
//            //                ToolbarItem(placement: .navigationBarLeading) {
//            //                    Button(action: {
//            //                      dismiss()
//            //                    }) {
//            //                      Image(systemName: "trash")
//            //                        .foregroundStyle(.red)
//            //                    }
//            //                }
//            ToolbarItem(placement: .topBarTrailing) {
//                Button(action: {
//                    dismiss()
//                }) {
//                    Text("Enregistrer")
//                        .foregroundStyle(Color.ds.flamingo)
//                        .fontWeight(.semibold)
//                }
//                .disabled(viewModel.title.isEmpty)
//            }
//        }
//    }
//
//    @ViewBuilder
//    private func photoPickerView() -> some View {
//        PhotosPicker(
//            selection: $viewModel.selectedItems, maxSelectionCount: 1, matching: .images,
//            preferredItemEncoding: .automatic
//        ) {
//            ZStack(alignment: .bottomTrailing) {
//                if viewModel.isImageLoading {
//                    ProgressView()
//                        .frame(width: 80, height: 80)
//                        .clipShape(Circle())
//                } else if let data = viewModel.partyImageData, let image = UIImage(data: data) {
//                    Image(uiImage: image)
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: 80, height: 80)
//                        .clipShape(Circle())
//                } else {
//                    Image(systemName: "photo.on.rectangle.angled")
//                        .resizable()
//                        .scaledToFit()
//                        .padding()
//                        .frame(width: 80, height: 80)
//                        .clipShape(Circle())
//                        .foregroundColor(.gray)
//                        .overlay(
//                            Circle()
//                                .stroke(Color.gray, lineWidth: 2)  // Ajout d'une bordure noire
//                        )
//                }
//            }
//        }
//        .onChange(of: viewModel.selectedItems) { _ in
//            guard let item = viewModel.selectedItems.first else {
//                return
//            }
//            viewModel.isImageLoading = true
//            item.loadTransferable(type: Data.self) { result in
//                DispatchQueue.main.async {
//                    viewModel.isImageLoading = false
//                    switch result {
//                    case .success(let data):
//                        viewModel.partyImageData = data
//                    case .failure(let error):
//                        print("Error loading image data: \(error.localizedDescription)")
//                    }
//                }
//            }
//        }
    }
}

#Preview {
    AddPartyView()
}
