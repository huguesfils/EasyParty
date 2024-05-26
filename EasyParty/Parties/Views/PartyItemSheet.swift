//
//  PartyItemSheet.swift
//  EasyParty
//
//  Created by Hugues Fils on 03/05/2024.
//

import SwiftUI

struct PartyItemSheet: View {
  @Binding var isPresented: Bool
  @Binding var partyItems: [PartyItem]
  @State private var newItemTitle: String = ""

  var body: some View {
    NavigationView {
      Form {
        TextField("Titre", text: $newItemTitle)
        Button("Ajouter") {
          let newItem = PartyItem(title: newItemTitle, completed: false)
          partyItems.append(newItem)
          newItemTitle = ""
          isPresented = false
        }
        .disabled(newItemTitle.isEmpty)
      }
      .navigationTitle("Nouvel élément")
      .navigationBarItems(
        trailing: Button("Fermer") {
          isPresented = false
        })
    }
  }
}

#Preview {
  PartyItemSheet(isPresented: .constant(true), partyItems: .constant([PartyItem(title: "item1")]))
}
