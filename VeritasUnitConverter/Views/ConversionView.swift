//
//  ConversionView.swift
//  VeritasUnitConverter
//

import SwiftUI

struct ConversionView: View {
    let category: ConversionCategory
    let units: [Unit]

    @State private var leftValue: String = ""
    @State private var rightValue: String = ""
    @State private var leftUnit: Unit?
    @State private var rightUnit: Unit?
    @FocusState private var leftFocused: Bool
    @FocusState private var rightFocused: Bool

    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 16) {
                // Left side
                VStack(spacing: 12) {
                    UnitPickerView(
                        selectedUnit: $leftUnit,
                        units: units,
                        label: "From"
                    )

                    InputFieldView(
                        value: $leftValue,
                        isFocused: $leftFocused,
                        placeholder: "0",
                        onSubmit: convertLeftToRight
                    )
                }

                // Arrow icon
                Image(systemName: "arrow.left.arrow.right")
                    .font(.title2)
                    .foregroundColor(.secondary)

                // Right side
                VStack(spacing: 12) {
                    UnitPickerView(
                        selectedUnit: $rightUnit,
                        units: units,
                        label: "To"
                    )

                    InputFieldView(
                        value: $rightValue,
                        isFocused: $rightFocused,
                        placeholder: "0",
                        onSubmit: convertRightToLeft
                    )
                }
            }
            .padding()
        }
        .navigationTitle(category.rawValue.capitalized)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Convert") {
                    if leftFocused {
                        convertLeftToRight()
                    } else if rightFocused {
                        convertRightToLeft()
                    }
                    leftFocused = false
                    rightFocused = false
                }
                .fontWeight(.semibold)
            }
        }
        .onChange(of: leftFocused) { _, isFocused in
            if isFocused {
                rightValue = ""
            }
        }
        .onChange(of: rightFocused) { _, isFocused in
            if isFocused {
                leftValue = ""
            }
        }
        .onAppear {
            // Auto-select first unit for left, last unit for right
            if leftUnit == nil {
                leftUnit = units.first
            }
            if rightUnit == nil {
                rightUnit = units.last
            }
        }
    }

    private func convertLeftToRight() {
        guard let fromUnit = leftUnit,
              let toUnit = rightUnit,
              let value = Double(leftValue) else {
            rightValue = ""
            return
        }

        let result = ConversionService.convert(
            value: value,
            from: fromUnit,
            to: toUnit
        )

        rightValue = ConversionService.format(value: result, decimals: 2)
    }

    private func convertRightToLeft() {
        guard let fromUnit = rightUnit,
              let toUnit = leftUnit,
              let value = Double(rightValue) else {
            leftValue = ""
            return
        }

        let result = ConversionService.convert(
            value: value,
            from: fromUnit,
            to: toUnit
        )

        leftValue = ConversionService.format(value: result, decimals: 2)
    }
}

#Preview {
    NavigationStack {
        ConversionView(
            category: .weight,
            units: [
                Unit(id: "gram", name: "Gram", symbol: "g", toBase: 1.0, toBaseOffset: 0),
                Unit(id: "ounce", name: "Ounce", symbol: "oz", toBase: 28.3495, toBaseOffset: 0)
            ]
        )
    }
}
