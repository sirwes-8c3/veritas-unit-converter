//
//  UnitPickerView.swift
//  VeritasUnitConverter
//

import SwiftUI

struct UnitPickerView: View {
    @Binding var selectedUnit: Unit?
    let units: [Unit]
    let label: String

    var body: some View {
        Menu {
            ForEach(units, id: \.id) { unit in
                Button(action: {
                    selectedUnit = unit
                }) {
                    HStack {
                        Text("\(unit.name) (\(unit.symbol))")
                        if selectedUnit?.id == unit.id {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            HStack {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                if let selected = selectedUnit {
                    Text("\(selected.name) (\(selected.symbol))")
                        .font(.headline)
                } else {
                    Text("Select Unit")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                Image(systemName: "chevron.down")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var selectedUnit: Unit?

        var body: some View {
            UnitPickerView(
                selectedUnit: $selectedUnit,
                units: [
                    Unit(id: "gram", name: "Gram", symbol: "g", toBase: 1.0, toBaseOffset: 0),
                    Unit(id: "ounce", name: "Ounce", symbol: "oz", toBase: 28.3495, toBaseOffset: 0)
                ],
                label: "From"
            )
            .padding()
        }
    }

    return PreviewWrapper()
}
