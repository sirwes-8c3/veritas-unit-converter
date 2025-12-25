//
//  VeritasUnitConverterApp.swift
//  VeritasUnitConverter
//
//  Created by Wesley Yu on 12/24/25.
//

import SwiftUI

@main
struct VeritasUnitConverterApp: App {
    @State private var favoritesManager = FavoritesManager()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(favoritesManager)
        }
    }
}
