//
//  ConversionCategory.swift
//  VeritasUnitConverter
//

import Foundation

enum ConversionCategory: String, Codable, CaseIterable {
    case weight
    case length
    case temperature
    case volume
    case favorites

    var displayName: String {
        rawValue.capitalized
    }
}
