//
//  CategoryData.swift
//  VeritasUnitConverter
//

import Foundation

struct CategoryData: Codable {
    let id: String
    let name: String
    let units: [Unit]
}

struct ConversionsData: Codable {
    let categories: [CategoryData]
}
