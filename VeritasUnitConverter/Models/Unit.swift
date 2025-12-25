//
//  Unit.swift
//  VeritasUnitConverter
//

import Foundation

struct Unit: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let symbol: String
    let toBase: Double
    let toBaseOffset: Double

    // Memberwise initializer with default toBaseOffset
    init(id: String, name: String, symbol: String, toBase: Double, toBaseOffset: Double = 0) {
        self.id = id
        self.name = name
        self.symbol = symbol
        self.toBase = toBase
        self.toBaseOffset = toBaseOffset
    }

    // Custom decoder to default toBaseOffset to 0 if not present
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        symbol = try container.decode(String.self, forKey: .symbol)
        toBase = try container.decode(Double.self, forKey: .toBase)
        toBaseOffset = try container.decodeIfPresent(Double.self, forKey: .toBaseOffset) ?? 0
    }
}
