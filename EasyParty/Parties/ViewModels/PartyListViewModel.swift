//
//  PartyListViewModel.swift
//  EasyParty
//
//  Created by Hugues Fils on 20/03/2024.
//

import FirebaseFirestore
import FirebaseStorage
import Foundation
import SwiftUI

class PartyListViewModel: ObservableObject {
  @Published var parties = [Party]()
  @Published var editingParty: Party?
  @Published var showingAddPartyView = false
  @Published var showingScrolledTitle = false

  @Published var isImageLoading = false

  private var firestoreService = FirestoreService()

  init() {
    fetchParties()
  }

  func startEditingParty(_ party: Party) {
    editingParty = party
    showingAddPartyView = true
  }

  func prepareForNewParty() {
    editingParty = nil
    showingAddPartyView = true
  }

  func saveParty(party: Party, originalImage: UIImage) {
    if let compressedImageData = compressImage(originalImage, maxSize: 1) {  // Taille maximale de 1 Mo
      let partyId = party.id ?? UUID().uuidString
      firestoreService.uploadPartyImage(partyId: partyId, imageData: compressedImageData) {
        [weak self] result in
        switch result {
        case .success(let imageUrl):
          var updatedParty = party
          updatedParty.id = partyId
          updatedParty.imageUrl = imageUrl
          self?.updateFirestoreWithParty(updatedParty)
        case .failure(let error):
          self?.handleError(error: error)
        }
      }
    } else {
      print("Failed to compress image")
    }
  }

  func updateFirestoreWithParty(_ party: Party) {
    if let _ = party.id {
      firestoreService.updateParty(party) { [weak self] error in
        self?.handleError(error: error)
        self?.fetchParties()
      }
    } else {
      firestoreService.addDocument(party) { [weak self] error in
        self?.handleError(error: error)
        self?.fetchParties()
      }
    }
  }

  func loadImageForParty(party: Party?, completion: @escaping (Data?) -> Void) {
    guard let imageUrl = party?.imageUrl else {
      completion(nil)
      return
    }
    isImageLoading = true
    FirestoreService().loadImageData(url: imageUrl) { result in
      DispatchQueue.main.async {
        self.isImageLoading = false
        switch result {
        case .success(let data):
          completion(data)
        case .failure(let error):
          print("Error loading image: \(error.localizedDescription)")
          completion(nil)
        }
      }
    }
  }

  func deleteParty(_ party: Party) {
    guard let partyId = party.id else {
      print("Error: Party has no id.")
      return
    }
    if let imageUrl = party.imageUrl {
      firestoreService.deleteImage(url: imageUrl) { [weak self] error in
        if let error = error {
          print("Failed to delete image: \(error.localizedDescription)")
          return
        }
        self?.firestoreService.deleteParty(withId: partyId) { error in
          if let error = error {
            print(error.localizedDescription)
          } else {
            DispatchQueue.main.async {
              if let index = self?.parties.firstIndex(where: { $0.id == party.id }) {
                self?.parties.remove(at: index)
              }
            }
          }
        }
      }
    } else {
      firestoreService.deleteParty(withId: partyId) { [weak self] error in
        if let error = error {
          print(error.localizedDescription)
        } else {
          DispatchQueue.main.async {
            if let index = self?.parties.firstIndex(where: { $0.id == party.id }) {
              self?.parties.remove(at: index)
            }
          }
        }
      }
    }
  }

  private func fetchParties() {
    firestoreService.fetchLists { [weak self] result in
      switch result {
      case .success(let fetchedParties):
        self?.parties = fetchedParties.sorted { $0.date < $1.date }
      case .failure(let error):
        self?.handleError(error: error)
      }
    }
  }

  private func handleError(error: Error?) {
    if let error = error {
      print("Firestore error: \(error.localizedDescription)")
    }
  }

  static let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .none
    return formatter
  }()

  func scrollDetector(topInsets: CGFloat) -> some View {
    GeometryReader { proxy in
      let minY = proxy.frame(in: .global).minY
      let isUnderToolbar = minY - topInsets < 0
      Color.clear
        .onChange(of: isUnderToolbar) { newVal in
          self.showingScrolledTitle = newVal
        }
    }
  }
}
