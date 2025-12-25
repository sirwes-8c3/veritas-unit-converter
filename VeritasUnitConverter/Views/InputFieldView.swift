//
//  InputFieldView.swift
//  VeritasUnitConverter
//

import SwiftUI

struct InputFieldView: View {
    @Binding var value: String
    let isFocused: Bool

    var body: some View {
        Text("TODO: InputFieldView")
    }
}

#Preview {
    InputFieldView(
        value: .constant(""),
        isFocused: false
    )
}
