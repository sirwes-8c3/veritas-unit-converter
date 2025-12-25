//
//  CategoryTabContent.swift
//  VeritasUnitConverter
//

import SwiftUI

struct CategoryTabContent: View {
    let category: ConversionCategory

    @State private var units: [Unit] = []
    @State private var loadError: String?
    @State private var isLoading = true

    var body: some View {
        Group {
            if let error = loadError {
                // Error state
                ContentUnavailableView {
                    Label("Error Loading Units", systemImage: "exclamationmark.triangle")
                } description: {
                    Text(error)
                }
            } else if isLoading {
                // Loading state
                VStack {
                    ProgressView()
                    Text("Loading...")
                        .padding(.top, 8)
                }
            } else if units.isEmpty {
                // Empty state
                ContentUnavailableView {
                    Label("No Units Available", systemImage: "questionmark.circle")
                } description: {
                    Text("This category has no units configured.")
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
        isLoading = false
    }
}

#Preview {
    NavigationStack {
        CategoryTabContent(category: .weight)
    }
}
