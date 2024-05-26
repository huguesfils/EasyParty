//
//  PartyView.swift
//  EasyParty
//
//  Created by Hugues Fils on 20/03/2024.
//

import SwiftUI

struct PartyView: View {
  var party: Party

  var body: some View {

    VStack(alignment: .leading) {
      Text(party.title).fontWeight(.semibold).padding(.bottom).foregroundStyle(.white)
      HStack {
        Text("🗓️ \(party.date, formatter: PartyListViewModel.dateFormatter)").font(.footnote)
          .foregroundStyle(.white)
        Spacer()
      }
    }
    .padding()  // Ajoute un padding à l'intérieur de la carte
    .background(
      LinearGradient(
        gradient: Gradient(colors: [.green, .blue]), startPoint: .topLeading,
        endPoint: .bottomTrailing)
    )
    .cornerRadius(10)  // Coins arrondis
    .shadow(color: .gray, radius: 2, x: 0, y: 2)  // Ombre pour un effet 3D
    .padding([.horizontal, .vertical], 5)  // Espacement entre les cartes

  }
}

#Preview {
  PartyView(
    party: Party(
      title: "Test", date: Date(), description: "Description de la party", partyItems: []))
}
