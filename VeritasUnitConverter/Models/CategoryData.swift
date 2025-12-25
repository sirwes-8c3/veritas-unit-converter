//
//  CategoryData.swift
//  VeritasUnitConverter
//

import Foundation

struct CategoryData: Codable, Identifiable {
    let id: String
    let name: String
    let units: [Unit]

    var category: ConversionCategory? {
        ConversionCategory(rawValue: id)
    }
}

struct ConversionsData: Codable {
    let categories: [CategoryData]
}
