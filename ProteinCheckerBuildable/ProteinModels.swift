import Foundation

// MARK: - Core Models

struct ProteinSource: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let category: ProteinCategory
    let diaasScore: Double?
    let pdcaasScore: Double?
    let aminoAcidProfile: AminoAcidProfile?
    let description: String?
    
    init(id: String = UUID().uuidString, 
         name: String, 
         category: ProteinCategory, 
         diaasScore: Double? = nil, 
         pdcaasScore: Double? = nil, 
         aminoAcidProfile: AminoAcidProfile? = nil, 
         description: String? = nil) {
        self.id = id
        self.name = name
        self.category = category
        self.diaasScore = diaasScore
        self.pdcaasScore = pdcaasScore
        self.aminoAcidProfile = aminoAcidProfile
        self.description = description
    }
}

struct AminoAcidProfile: Codable, Hashable {
    let histidine: Double
    let isoleucine: Double
    let leucine: Double
    let lysine: Double
    let methionine: Double
    let phenylalanine: Double
    let threonine: Double
    let tryptophan: Double
    let valine: Double
}

enum ProteinCategory: String, CaseIterable, Codable {
    case all = "all"
    case meat = "meat"
    case dairy = "dairy"
    case plant = "plant"
    case supplement = "supplement"
    case other = "other"
    
    var displayName: String {
        switch self {
        case .all: return "All Sources"
        case .meat: return "Meat & Fish"
        case .dairy: return "Dairy & Eggs"
        case .plant: return "Plant Sources"
        case .supplement: return "Supplements"
        case .other: return "Other"
        }
    }
}

// MARK: - Calculation Models

struct ProteinCalculation: Codable, Identifiable, Hashable {
    let id: String
    let statedProtein: Double
    let dvPercentage: Double?
    let proteinSource: ProteinSource
    let digestibleProtein: Double // Keep for backwards compatibility
    let digestibilityPercentage: Double // Keep for backwards compatibility
    let calculationMethod: CalculationMethod
    let timestamp: Date
    
    init(id: String = UUID().uuidString,
         statedProtein: Double,
         dvPercentage: Double? = nil,
         proteinSource: ProteinSource,
         digestibleProtein: Double,
         digestibilityPercentage: Double,
         calculationMethod: CalculationMethod,
         timestamp: Date = Date()) {
        self.id = id
        self.statedProtein = statedProtein
        self.dvPercentage = dvPercentage
        self.proteinSource = proteinSource
        self.digestibleProtein = digestibleProtein
        self.digestibilityPercentage = digestibilityPercentage
        self.calculationMethod = calculationMethod
        self.timestamp = timestamp
    }
}

enum CalculationMethod: String, Codable, CaseIterable {
    case diaas = "DIAAS"
    case pdcaas = "PDCAAS"
}

// MARK: - Calculation Input/Output

struct CalculationInput {
    let statedProtein: Double
    let dvPercentage: Double?
    let proteinSource: ProteinSource
}

struct CalculationResult {
    let qualityAdjustedProtein: Double
    let proteinQualityPercentage: Double
    let calculationMethod: CalculationMethod
    let adjustedProtein: Double?
    let scoreUsed: Double
    let dvDiscrepancy: Double?
}

// MARK: - Quality Rating

struct ProteinQualityRating {
    let rating: QualityRating
    let description: String
}

enum QualityRating: String, CaseIterable {
    case excellent = "Excellent"
    case high = "High"
    case good = "Good"
    case fair = "Fair"
    case poor = "Poor"
    case incomplete = "Incomplete"
    
    var color: String {
        switch self {
        case .excellent: return "#1B5E20"
        case .high: return "#2E7D32"
        case .good: return "#F57F17"
        case .fair: return "#E65100"
        case .poor: return "#C62828"
        case .incomplete: return "#B71C1C"
        }
    }
}
