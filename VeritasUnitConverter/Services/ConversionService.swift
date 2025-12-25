//
//  ConversionService.swift
//  VeritasUnitConverter
//

import Foundation

struct ConversionService {
    /// Converts a value from one unit to another using the unified affine formula
    /// - Parameters:
    ///   - value: The numeric value to convert
    ///   - sourceUnit: The unit to convert from
    ///   - targetUnit: The unit to convert to
    /// - Returns: The converted value
    static func convert(value: Double, from sourceUnit: Unit, to targetUnit: Unit) -> Double {
        // Edge case: Same unit conversion
        if sourceUnit.id == targetUnit.id {
            return value
        }

        // Step 1: Convert to base unit using affine formula
        let baseValue = value * sourceUnit.toBase + sourceUnit.toBaseOffset

        // Step 2: Convert from base to target unit using inverse affine formula
        let result = (baseValue - targetUnit.toBaseOffset) / targetUnit.toBase

        return result
    }

    /// Formats a numeric value for display with configurable decimal places
    /// - Parameters:
    ///   - value: The numeric value to format
    ///   - decimals: Number of decimal places (default: 4)
    /// - Returns: Formatted string representation
    static func format(value: Double, decimals: Int = 4) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = decimals
        formatter.usesGroupingSeparator = true

        return formatter.string(from: NSNumber(value: value)) ?? String(format: "%.\(decimals)f", value)
    }
}
