import Foundation

// MARK: - Constants

private let FDA_DAILY_VALUE_PROTEIN: Double = 50.0 // grams per day

// MARK: - Main Calculation Function

/**
 * Calculate quality-adjusted protein using DIAAS or PDCAAS scores
 *
 * Note: DIAAS/PDCAAS scores indicate protein quality (amino acid completeness and digestibility),
 * not absorption rates. A score of 0.6 means the protein can meet 60% of amino acid requirements
 * due to limiting amino acids, making it "60% as effective" as a complete protein.
 */
func calculateDigestibleProtein(input: CalculationInput) -> CalculationResult {
    let statedProtein = input.statedProtein
    let dvPercentage = input.dvPercentage
    let proteinSource = input.proteinSource
    
    // Use DV% to calculate protein amount if provided, otherwise use stated protein
    var adjustedProtein = statedProtein
    var dvDiscrepancy: Double?
    
    if let dvPercentage = dvPercentage, dvPercentage > 0 {
        let proteinFromDV = (dvPercentage / 100) * FDA_DAILY_VALUE_PROTEIN
        adjustedProtein = proteinFromDV
        
        // Note discrepancy for educational purposes
        let discrepancy = abs(proteinFromDV - statedProtein)
        if discrepancy > 0.5 {
            dvDiscrepancy = discrepancy
        }
    }
    
    // Use DIAAS if available, otherwise fall back to PDCAAS
    let score: Double
    let method: CalculationMethod
    
    if let diaasScore = proteinSource.diaasScore {
        score = diaasScore
        method = .diaas
    } else if let pdcaasScore = proteinSource.pdcaasScore {
        score = pdcaasScore
        method = .pdcaas
    } else {
        // Fallback for sources without scores
        score = 0.75
        method = .diaas
    }
    
    let qualityAdjustedProtein = adjustedProtein * score
    let proteinQualityPercentage = (qualityAdjustedProtein / statedProtein) * 100
    
    return CalculationResult(
        qualityAdjustedProtein: qualityAdjustedProtein,
        proteinQualityPercentage: proteinQualityPercentage,
        calculationMethod: method,
        adjustedProtein: dvPercentage != nil ? adjustedProtein : nil,
        scoreUsed: score,
        dvDiscrepancy: dvDiscrepancy
    )
}

// MARK: - Helper Functions

/**
 * Create a full calculation record
 */
func createCalculationRecord(input: CalculationInput, result: CalculationResult) -> ProteinCalculation {
    return ProteinCalculation(
        statedProtein: input.statedProtein,
        dvPercentage: input.dvPercentage,
        proteinSource: input.proteinSource,
        digestibleProtein: result.qualityAdjustedProtein,
        digestibilityPercentage: result.proteinQualityPercentage,
        calculationMethod: result.calculationMethod
    )
}

/**
 * Format protein amount for display
 */
func formatProteinAmount(_ amount: Double) -> String {
    return String(format: "%.1fg", amount)
}

/**
 * Format percentage for display
 */
func formatPercentage(_ percentage: Double) -> String {
    return String(format: "%.1f%%", percentage)
}

/**
 * Calculate protein from DV percentage
 */
func calculateProteinFromDV(_ dvPercentage: Double) -> Double {
    return (dvPercentage / 100) * FDA_DAILY_VALUE_PROTEIN
}

/**
 * Calculate DV percentage from protein amount
 */
func calculateDVFromProtein(_ proteinGrams: Double) -> Double {
    return (proteinGrams / FDA_DAILY_VALUE_PROTEIN) * 100
}

/**
 * Compare protein quality scores
 */
func compareProteinQuality(_ sourceA: ProteinSource, _ sourceB: ProteinSource) -> ComparisonResult {
    let scoreA = sourceA.diaasScore ?? sourceA.pdcaasScore ?? 0
    let scoreB = sourceB.diaasScore ?? sourceB.pdcaasScore ?? 0
    
    if scoreA > scoreB {
        return .orderedDescending
    } else if scoreA < scoreB {
        return .orderedAscending
    } else {
        return .orderedSame
    }
}

/**
 * Get protein quality rating
 */
func getProteinQualityRating(for source: ProteinSource) -> ProteinQualityRating {
    let score = source.diaasScore ?? source.pdcaasScore ?? 0
    
    if score >= 1.0 {
        return ProteinQualityRating(rating: .excellent, description: "Complete, high-quality protein")
    } else if score >= 0.8 {
        return ProteinQualityRating(rating: .high, description: "Good quality protein with minor limitations")
    } else if score >= 0.6 {
        return ProteinQualityRating(rating: .good, description: "Moderate quality protein")
    } else if score >= 0.4 {
        return ProteinQualityRating(rating: .fair, description: "Lower quality protein")
    } else if score > 0 {
        return ProteinQualityRating(rating: .poor, description: "Limited protein quality")
    } else {
        return ProteinQualityRating(rating: .incomplete, description: "Missing essential amino acids")
    }
}

/**
 * Get digestibility color based on percentage
 */
func getDigestibilityColor(for percentage: Double) -> String {
    if percentage <= 40 {
        return "#FF5252" // Bright red - AAA compliant on dark backgrounds
    } else if percentage <= 80 {
        return "#FFD54F" // Bright yellow - AAA compliant on dark backgrounds
    } else {
        return "#66BB6A" // Bright green - AAA compliant on dark backgrounds
    }
}
