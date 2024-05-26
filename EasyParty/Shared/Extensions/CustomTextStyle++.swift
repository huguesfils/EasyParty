//
//  CustomTextStyle.swift
//  EasyParty
//
//  Created by Hugues Fils on 25/03/2024.
//

import SwiftUI

struct CustomTextStyle: ViewModifier {
  var size: CGFloat

  func body(content: Content) -> some View {
    content
      .font(.custom("Lobster-Regular", size: size))
  }
}

extension View {
  func customTextStyle(size: CGFloat) -> some View {
    self.modifier(CustomTextStyle(size: size))
  }
}
