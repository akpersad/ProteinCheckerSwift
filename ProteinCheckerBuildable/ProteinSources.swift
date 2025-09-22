import Foundation

// MARK: - Protein Sources Database

class ProteinSourcesDatabase {
    static let shared = ProteinSourcesDatabase()
    
    private init() {}
    
    // MARK: - All Protein Sources
    
    lazy var allSources: [ProteinSource] = [
        // MARK: - Meat & Fish (High DIAAS scores)
        ProteinSource(
            name: "Whey Protein Isolate",
            category: .supplement,
            diaasScore: 1.25,
            pdcaasScore: 1.0,
            description: "Complete protein with excellent amino acid profile"
        ),
        ProteinSource(
            name: "Whey Protein Concentrate",
            category: .supplement,
            diaasScore: 1.20,
            pdcaasScore: 1.0,
            description: "High-quality protein with good bioavailability"
        ),
        ProteinSource(
            name: "Milk (Whole)",
            category: .dairy,
            diaasScore: 1.18,
            pdcaasScore: 1.0,
            description: "Complete protein with casein and whey"
        ),
        ProteinSource(
            name: "Egg (Whole)",
            category: .dairy,
            diaasScore: 1.13,
            pdcaasScore: 1.0,
            description: "Gold standard for protein quality"
        ),
        ProteinSource(
            name: "Beef (Lean)",
            category: .meat,
            diaasScore: 1.11,
            pdcaasScore: 0.92,
            description: "High-quality complete protein"
        ),
        ProteinSource(
            name: "Chicken Breast",
            category: .meat,
            diaasScore: 1.08,
            pdcaasScore: 0.97,
            description: "Lean, complete protein source"
        ),
        ProteinSource(
            name: "Fish (Salmon)",
            category: .meat,
            diaasScore: 1.09,
            pdcaasScore: 1.0,
            description: "Complete protein with omega-3 fatty acids"
        ),
        ProteinSource(
            name: "Pork (Lean)",
            category: .meat,
            diaasScore: 1.06,
            pdcaasScore: 0.87,
            description: "Complete protein source"
        ),
        ProteinSource(
            name: "Turkey Breast",
            category: .meat,
            diaasScore: 1.07,
            pdcaasScore: 0.95,
            description: "Lean, high-quality protein"
        ),
        ProteinSource(
            name: "Greek Yogurt",
            category: .dairy,
            diaasScore: 1.15,
            pdcaasScore: 1.0,
            description: "Concentrated protein with probiotics"
        ),
        
        // MARK: - Plant Sources (Lower DIAAS scores)
        ProteinSource(
            name: "Soy Protein Isolate",
            category: .supplement,
            diaasScore: 0.90,
            pdcaasScore: 1.0,
            description: "Highest quality plant protein"
        ),
        ProteinSource(
            name: "Tofu (Firm)",
            category: .plant,
            diaasScore: 0.87,
            pdcaasScore: 0.95,
            description: "Complete plant protein"
        ),
        ProteinSource(
            name: "Quinoa",
            category: .plant,
            diaasScore: 0.84,
            pdcaasScore: 0.73,
            description: "Complete grain protein"
        ),
        ProteinSource(
            name: "Hemp Seeds",
            category: .plant,
            diaasScore: 0.61,
            pdcaasScore: 0.63,
            description: "Complete plant protein with healthy fats"
        ),
        ProteinSource(
            name: "Spirulina",
            category: .supplement,
            diaasScore: 0.69,
            pdcaasScore: 0.68,
            description: "Blue-green algae protein"
        ),
        ProteinSource(
            name: "Lentils (Cooked)",
            category: .plant,
            diaasScore: 0.63,
            pdcaasScore: 0.52,
            description: "High-fiber legume protein"
        ),
        ProteinSource(
            name: "Chickpeas (Cooked)",
            category: .plant,
            diaasScore: 0.58,
            pdcaasScore: 0.71,
            description: "Versatile legume protein"
        ),
        ProteinSource(
            name: "Black Beans (Cooked)",
            category: .plant,
            diaasScore: 0.56,
            pdcaasScore: 0.65,
            description: "High-fiber bean protein"
        ),
        ProteinSource(
            name: "Pea Protein",
            category: .supplement,
            diaasScore: 0.67,
            pdcaasScore: 0.69,
            description: "Popular plant protein powder"
        ),
        ProteinSource(
            name: "Brown Rice Protein",
            category: .supplement,
            diaasScore: 0.42,
            pdcaasScore: 0.55,
            description: "Hypoallergenic grain protein"
        ),
        ProteinSource(
            name: "Almonds",
            category: .plant,
            diaasScore: 0.40,
            pdcaasScore: 0.52,
            description: "Nut protein with healthy fats"
        ),
        ProteinSource(
            name: "Peanuts",
            category: .plant,
            diaasScore: 0.43,
            pdcaasScore: 0.52,
            description: "Legume with moderate protein quality"
        ),
        ProteinSource(
            name: "Chia Seeds",
            category: .plant,
            diaasScore: 0.58,
            pdcaasScore: nil,
            description: "Seeds with omega-3 fatty acids"
        ),
        ProteinSource(
            name: "Pumpkin Seeds",
            category: .plant,
            diaasScore: 0.46,
            pdcaasScore: nil,
            description: "Mineral-rich seed protein"
        ),
        
        // MARK: - Dairy Products
        ProteinSource(
            name: "Cottage Cheese",
            category: .dairy,
            diaasScore: 1.16,
            pdcaasScore: 1.0,
            description: "High-casein dairy protein"
        ),
        ProteinSource(
            name: "Cheddar Cheese",
            category: .dairy,
            diaasScore: 1.12,
            pdcaasScore: 1.0,
            description: "Complete dairy protein"
        ),
        ProteinSource(
            name: "Casein Protein",
            category: .supplement,
            diaasScore: 1.14,
            pdcaasScore: 1.0,
            description: "Slow-digesting complete protein"
        ),
        
        // MARK: - Grains & Cereals
        ProteinSource(
            name: "Oats",
            category: .plant,
            diaasScore: 0.54,
            pdcaasScore: 0.57,
            description: "Whole grain with moderate protein"
        ),
        ProteinSource(
            name: "Wheat (Whole)",
            category: .plant,
            diaasScore: 0.45,
            pdcaasScore: 0.54,
            description: "Cereal grain protein"
        ),
        ProteinSource(
            name: "Barley",
            category: .plant,
            diaasScore: 0.56,
            pdcaasScore: nil,
            description: "Ancient grain protein"
        ),
        
        // MARK: - Other Supplements
        ProteinSource(
            name: "Collagen Peptides",
            category: .supplement,
            diaasScore: 0.37,
            pdcaasScore: nil,
            description: "Incomplete protein for skin/joint health"
        ),
        ProteinSource(
            name: "BCAA Powder",
            category: .supplement,
            diaasScore: nil,
            pdcaasScore: nil,
            description: "Branched-chain amino acids only"
        ),
        
        // MARK: - Seafood
        ProteinSource(
            name: "Tuna (Canned)",
            category: .meat,
            diaasScore: 1.08,
            pdcaasScore: 1.0,
            description: "Lean fish protein"
        ),
        ProteinSource(
            name: "Sardines",
            category: .meat,
            diaasScore: 1.05,
            pdcaasScore: 1.0,
            description: "Small fish with complete protein"
        ),
        ProteinSource(
            name: "Shrimp",
            category: .meat,
            diaasScore: 1.09,
            pdcaasScore: 1.0,
            description: "Low-fat seafood protein"
        ),
        
        // MARK: - Vegetables
        ProteinSource(
            name: "Broccoli",
            category: .plant,
            diaasScore: 0.58,
            pdcaasScore: nil,
            description: "Vegetable with moderate protein"
        ),
        ProteinSource(
            name: "Spinach",
            category: .plant,
            diaasScore: 0.51,
            pdcaasScore: nil,
            description: "Leafy green with some protein"
        )
    ]
    
    // MARK: - Helper Methods
    
    func getSources(for category: ProteinCategory) -> [ProteinSource] {
        if category == .all {
            return allSources.sorted { $0.name < $1.name }
        }
        return allSources.filter { $0.category == category }.sorted { $0.name < $1.name }
    }
    
    func searchSources(query: String, category: ProteinCategory = .all) -> [ProteinSource] {
        let sources = getSources(for: category)
        
        if query.isEmpty {
            return sources
        }
        
        return sources.filter { source in
            source.name.localizedCaseInsensitiveContains(query) ||
            source.description?.localizedCaseInsensitiveContains(query) == true
        }
    }
    
    func getHighestQualitySources(limit: Int = 10) -> [ProteinSource] {
        return allSources
            .sorted { (sourceA, sourceB) in
                let scoreA = sourceA.diaasScore ?? sourceA.pdcaasScore ?? 0
                let scoreB = sourceB.diaasScore ?? sourceB.pdcaasScore ?? 0
                return scoreA > scoreB
            }
            .prefix(limit)
            .map { $0 }
    }
}
