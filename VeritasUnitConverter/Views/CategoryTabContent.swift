//
//  CategoryTabContent.swift
//  VeritasUnitConverter
//

import SwiftUI

struct CategoryTabContent: View {
    let category: ConversionCategory

    @State private var units: [Unit] = []
    @State private var loadError: String?

    var body: some View {
        Group {
            if let error = loadError {
                // Error state
                ContentUnavailableView {
                    Label("Error Loading Units", systemImage: "exclamationmark.triangle")
                } description: {
                    Text(error)
                }
            } else if units.isEmpty {
                // Loading state
                VStack {
                    ProgressView()
                    Text("Loading...")
                        .padding(.top, 8)
                }
            } else {
                // Success state
                ConversionView(category: category, units: units)
            }
        }
        .navigationTitle(category.displayName)
        .task {
            await loadUnits()
        }
    }

    private func loadUnits() async {
        do {
            let loadedUnits = try ConversionDataLoader.getUnits(for: category)
            units = loadedUnits
        } catch {
            loadError = error.localizedDescription
        }
    }
}

#Preview {
    NavigationStack {
        CategoryTabContent(category: .weight)
    }
}
