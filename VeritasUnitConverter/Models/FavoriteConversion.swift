//
//  FavoriteConversion.swift
//  VeritasUnitConverter
//

import Foundation

struct FavoriteConversion: Codable, Identifiable, Hashable {
    let id: UUID
    let categoryId: String
    let leftUnitId: String
    let rightUnitId: String

    init(id: UUID = UUID(), categoryId: String, leftUnitId: String, rightUnitId: String) {
        self.id = id
        self.categoryId = categoryId
        self.leftUnitId = leftUnitId
        self.rightUnitId = rightUnitId
    }
}
