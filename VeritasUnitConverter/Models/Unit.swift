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
}
