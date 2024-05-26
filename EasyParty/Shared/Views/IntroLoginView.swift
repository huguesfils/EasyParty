//
//  IntroLogin.swift
//  EasyParty
//
//  Created by Hugues Fils on 12/04/2024.
//

import SwiftUI

struct IntroLogin: View {
  var body: some View {
    VStack {
      ZStack {
        Circle()
          .foregroundColor(.blueSky)
          .frame(width: 220, height: 220)
        Image("loginIcon")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 200, height: 200)
      }

      Text("Organisez facilement vos soirées")
        .customTextStyle(size: 20)
    }
  }
}

#Preview {
  IntroLogin()
}
