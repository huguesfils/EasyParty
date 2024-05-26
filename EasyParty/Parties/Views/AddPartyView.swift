//
//  AddPartyView.swift
//  EasyParty
//
//  Created by Hugues Fils on 20/03/2024.
//

import PhotosUI
import SwiftUI

struct AddPartyView: View {
  @Environment(\.dismiss) var dismiss
  var viewModel: PartyListViewModel
  var party: Party?

  @State private var title: String = ""
  @State private var date: Date = Date()
  @State private var description: String = ""
  @State private var partyImageData: Data?
  @State private var selectedItems: [PhotosPickerItem] = []

  @State private var partyItems: [PartyItem] = []

  @State private var showPartyItemSheet = false

  init(viewModel: PartyListViewModel, party: Party? = nil) {
    self.viewModel = viewModel
    self.party = party
    _title = State(initialValue: party?.title ?? "")
    _description = State(initialValue: party?.description ?? "")
    _date = State(initialValue: party?.date ?? Date())
    _partyItems = State(initialValue: party?.partyItems ?? [])
  }

  var body: some View {
    NavigationStack {
      ZStack {
        Color.customBackground.ignoresSafeArea()
        ScrollView {
          VStack {
            PhotosPicker(
              selection: $selectedItems, maxSelectionCount: 1, matching: .images,
              preferredItemEncoding: .automatic
            ) {

              ZStack(alignment: .bottomTrailing) {
                if viewModel.isImageLoading {
                  ProgressView()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                } else if let data = partyImageData, let image = UIImage(data: data) {
                  Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                } else {
                  Image(systemName: "photo.on.rectangle.angled")
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .foregroundColor(.gray)
                    .overlay(
                      Circle()
                        .stroke(Color.gray, lineWidth: 2)  // Ajout d'une bordure noire
                    )
                }
                Image(systemName: "pencil")
                  .foregroundColor(.white)
                  .frame(width: 25, height: 25)
                  .background(Color.flamingo)
                  .clipShape(Circle())
                  .overlay(Circle().stroke(.customBackground, lineWidth: 2))
                  .padding([.bottom, .trailing], 8)
              }
            }
            .onChange(of: selectedItems) { _ in
              guard let item = selectedItems.first else {
                return
              }
              viewModel.isImageLoading = true
              item.loadTransferable(type: Data.self) { result in
                DispatchQueue.main.async {
                  viewModel.isImageLoading = false
                  switch result {
                  case .success(let data):
                    self.partyImageData = data
                  case .failure(let error):
                    print("Error loading image data: \(error.localizedDescription)")
                  }
                }
              }
            }

            CustomFormField(text: $title, header: "TITRE", icon: "party.popper.fill")
              .disableAutocorrection(true)
              .submitLabel(.next)

            CustomDateField(selectedDate: $date, header: "DATE", icon: "calendar")

            CustomDisclosureGroup(title: "Liste", icon: "list.clipboard") {
              VStack(alignment: .leading) {
                ForEach(partyItems) { item in
                  PartyItemView(
                    item: item,
                    deleteAction: {
                      deleteListItem(item: item)
                    })
                }
                HStack {
                  Spacer()
                  Button(action: {
                    showPartyItemSheet = true
                  }) {
                    Label("Ajouter un élément", systemImage: "plus")
                  }
                  .sheet(isPresented: $showPartyItemSheet) {
                    PartyItemSheet(isPresented: $showPartyItemSheet, partyItems: $partyItems)
                  }
                  Spacer()
                }
                .padding(.top, 10)
              }

            }
            .padding(.top, 20)
          }
          .padding()
        }
      }
      .onAppear {
        loadImage()
      }
      .navigationTitle(party?.title ?? "Nouvelle soirée")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          if party != nil {
            Button(action: {
              viewModel.deleteParty(party!)
              dismiss()
            }) {
              Image(systemName: "trash")
                .foregroundStyle(.red)
            }
          }
        }
        ToolbarItem(placement: .navigationBarTrailing) {
          Button(action: {
            saveParty()
            dismiss()
          }) {
            Text("Enregistrer")
              .foregroundStyle(.flamingo)
              .fontWeight(.semibold)
          }
          .disabled(title.isEmpty)
        }
      }
    }
  }

  private func deleteListItem(item: PartyItem) {
    withAnimation {
      if let index = partyItems.firstIndex(where: { $0.id == item.id }) {
        partyItems.remove(at: index)
      }
    }
  }

  private func saveParty() {
    let updatedParty = Party(
      id: party?.id, title: title, date: date, description: description, partyItems: partyItems,
      imageUrl: party?.imageUrl)

    if let imageData = partyImageData {
      if let image = UIImage(data: imageData) {
        viewModel.saveParty(party: updatedParty, originalImage: image)
      } else {
        print("Failed to convert image data to UIImage.")
      }
    } else {
      viewModel.updateFirestoreWithParty(updatedParty)
    }
  }

  private func loadImage() {
    guard let party = party else { return }
    viewModel.loadImageForParty(party: party) { data in
      self.partyImageData = data
    }
  }
}

#Preview {
  AddPartyView(viewModel: PartyListViewModel())
}
