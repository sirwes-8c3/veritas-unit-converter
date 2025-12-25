//
//  VeritasUnitConverterApp.swift
//  VeritasUnitConverter
//
//  Created by Wesley Yu on 12/24/25.
//

import SwiftUI
import SwiftData

@main
struct VeritasUnitConverterApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    @State private var favoritesManager = FavoritesManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(favoritesManager)
        }
        .modelContainer(sharedModelContainer)
    }
}
