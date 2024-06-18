//
//  CustomDateField.swift
//  EasyParty
//
//  Created by Hugues Fils on 27/04/2024.
//

import SwiftUI

extension Date {
    func toString(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

public struct CustomDateField: View {
    @Binding var selectedDate: Date
    var header: String
    var icon: String
    
    public var body: some View {
        VStack(alignment: .leading) {
            Text(header)
                .padding(.horizontal)
                .font(.footnote)
                .foregroundColor(.gray)
            ZStack(alignment: .leading) {
                HStack {
                    Image(systemName: icon)
                        .color(.ds.flamingo)
                    
                    HStack(alignment: .firstTextBaseline) {
                        Text(selectedDate.toString("dd/MM/yyyy"))
                            .padding(.horizontal, 10)
                            .overlay {
                                DatePicker(
                                    "",
                                    selection: $selectedDate,
                                    displayedComponents: .date
                                )
                                .blendMode(.destinationOver)
                            }
                        Spacer()
                    }.frame(maxWidth: .infinity)
                }
                .padding()
                .background(Color.white.opacity(0.5))
                .cornerRadius(10)
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.top, 15)
    }
}
//
//#Preview {
//    CustomDateField(selectedDate: Date(), header: "Date", icon: "calendar")
//}
