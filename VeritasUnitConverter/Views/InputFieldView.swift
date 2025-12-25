//
//  InputFieldView.swift
//  VeritasUnitConverter
//

import SwiftUI

struct InputFieldView: View {
    @Binding var value: String
    @FocusState.Binding var isFocused: Bool
    let placeholder: String
    let onSubmit: () -> Void

    var body: some View {
        TextField(placeholder, text: $value)
            .keyboardType(.decimalPad)
            .font(.title2)
            .multilineTextAlignment(.center)
            .focused($isFocused)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var value = ""
        @FocusState private var isFocused: Bool

        var body: some View {
            InputFieldView(
                value: $value,
                isFocused: $isFocused,
                placeholder: "0",
                onSubmit: {}
            )
            .padding()
        }
    }

    return PreviewWrapper()
}
