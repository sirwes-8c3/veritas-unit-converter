//
//  ConversionCategory.swift
//  VeritasUnitConverter
//

import Foundation

enum ConversionCategory: String, Codable, CaseIterable, Identifiable {
    case weight
    case length
    case temperature
    case volume
    case favorites

    var id: String {
        rawValue
    }

    var displayName: String {
        rawValue.capitalized
    }

    var iconName: String {
        switch self {
        case .weight: return "scalemass"
        case .length: return "ruler"
        case .temperature: return "thermometer"
        case .volume: return "drop"
        case .favorites: return "star.fill"
        }
    }
}
