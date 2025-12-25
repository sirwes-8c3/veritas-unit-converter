//
//  UnitPickerView.swift
//  VeritasUnitConverter
//

import SwiftUI

struct UnitPickerView: View {
    let units: [Unit]
    @Binding var selectedUnit: Unit?

    var body: some View {
        Text("TODO: UnitPickerView")
    }
}

#Preview {
    UnitPickerView(
        units: [],
        selectedUnit: .constant(nil)
    )
}
