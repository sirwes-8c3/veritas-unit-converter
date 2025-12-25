//
//  ConversionDataLoader.swift
//  VeritasUnitConverter
//

import Foundation

enum ConversionDataError: Error, LocalizedError {
    case fileNotFound
    case decodingFailed(Error)

    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return "conversions.json not found in app bundle"
        case .decodingFailed(let error):
            return "Failed to decode conversions.json: \(error.localizedDescription)"
        }
    }
}

struct ConversionDataLoader {
    static func loadConversions() throws -> ConversionsData {
        guard let url = Bundle.main.url(forResource: "conversions", withExtension: "json") else {
            throw ConversionDataError.fileNotFound
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let conversionsData = try decoder.decode(ConversionsData.self, from: data)
            return conversionsData
        } catch {
            throw ConversionDataError.decodingFailed(error)
        }
    }

    static func getCategoryData(for category: ConversionCategory) throws -> CategoryData? {
        let data = try loadConversions()
        return data.categories.first { $0.id == category.rawValue }
    }

    static func getUnits(for category: ConversionCategory) throws -> [Unit] {
        guard let categoryData = try getCategoryData(for: category) else {
            return []
        }
        return categoryData.units
    }
}
