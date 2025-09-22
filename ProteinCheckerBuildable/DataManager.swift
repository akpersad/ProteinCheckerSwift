import Foundation

// MARK: - Data Manager

class DataManager {
    static let shared = DataManager()
    
    private let userDefaults = UserDefaults.standard
    private let calculationHistoryKey = "protein_calculation_history"
    private let maxHistoryItems = 100
    
    private init() {}
    
    // MARK: - Calculation History Management
    
    /**
     * Save a new calculation to history
     */
    func saveCalculation(_ calculation: ProteinCalculation) {
        var history = getCalculationHistory()
        
        // Add new calculation to the beginning
        history.insert(calculation, at: 0)
        
        // Limit history size
        if history.count > maxHistoryItems {
            history = Array(history.prefix(maxHistoryItems))
        }
        
        saveCalculationHistory(history)
    }
    
    /**
     * Get all calculation history
     */
    func getCalculationHistory() -> [ProteinCalculation] {
        guard let data = userDefaults.data(forKey: calculationHistoryKey) else {
            return []
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode([ProteinCalculation].self, from: data)
        } catch {
            print("Error decoding calculation history: \(error)")
            return []
        }
    }
    
    /**
     * Save calculation history
     */
    private func saveCalculationHistory(_ history: [ProteinCalculation]) {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(history)
            userDefaults.set(data, forKey: calculationHistoryKey)
        } catch {
            print("Error encoding calculation history: \(error)")
        }
    }
    
    /**
     * Delete a specific calculation from history
     */
    func deleteCalculation(withId id: String) {
        var history = getCalculationHistory()
        history.removeAll { $0.id == id }
        saveCalculationHistory(history)
    }
    
    /**
     * Clear all calculation history
     */
    func clearCalculationHistory() {
        userDefaults.removeObject(forKey: calculationHistoryKey)
    }
    
    /**
     * Get calculation history filtered by date range
     */
    func getCalculationHistory(from startDate: Date, to endDate: Date) -> [ProteinCalculation] {
        let allHistory = getCalculationHistory()
        return allHistory.filter { calculation in
            calculation.timestamp >= startDate && calculation.timestamp <= endDate
        }
    }
    
    /**
     * Get calculation history for a specific protein source
     */
    func getCalculationHistory(for proteinSource: ProteinSource) -> [ProteinCalculation] {
        let allHistory = getCalculationHistory()
        return allHistory.filter { $0.proteinSource.id == proteinSource.id }
    }
    
    /**
     * Get calculation statistics
     */
    func getCalculationStatistics() -> CalculationStatistics {
        let history = getCalculationHistory()
        
        let totalCalculations = history.count
        let averageProtein = history.isEmpty ? 0 : history.map(\.statedProtein).reduce(0, +) / Double(totalCalculations)
        let averageQualityAdjusted = history.isEmpty ? 0 : history.map(\.digestibleProtein).reduce(0, +) / Double(totalCalculations)
        
        let mostUsedSources = Dictionary(grouping: history, by: { $0.proteinSource.name })
            .mapValues { $0.count }
            .sorted { $0.value > $1.value }
            .prefix(5)
            .map { ($0.key, $0.value) }
        
        return CalculationStatistics(
            totalCalculations: totalCalculations,
            averageStatedProtein: averageProtein,
            averageQualityAdjustedProtein: averageQualityAdjusted,
            mostUsedSources: mostUsedSources
        )
    }
    
    // MARK: - Data Export/Import
    
    /**
     * Export calculation history as JSON data
     */
    func exportCalculationHistory() -> Data? {
        let history = getCalculationHistory()
        
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            encoder.outputFormatting = .prettyPrinted
            return try encoder.encode(history)
        } catch {
            print("Error exporting calculation history: \(error)")
            return nil
        }
    }
    
    /**
     * Import calculation history from JSON data
     */
    func importCalculationHistory(from data: Data, replaceExisting: Bool = false) -> Bool {
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let importedHistory = try decoder.decode([ProteinCalculation].self, from: data)
            
            if replaceExisting {
                saveCalculationHistory(importedHistory)
            } else {
                var existingHistory = getCalculationHistory()
                
                // Merge and deduplicate based on ID
                let existingIds = Set(existingHistory.map(\.id))
                let newCalculations = importedHistory.filter { !existingIds.contains($0.id) }
                
                existingHistory.append(contentsOf: newCalculations)
                existingHistory.sort { $0.timestamp > $1.timestamp }
                
                // Limit total history
                if existingHistory.count > maxHistoryItems {
                    existingHistory = Array(existingHistory.prefix(maxHistoryItems))
                }
                
                saveCalculationHistory(existingHistory)
            }
            
            return true
        } catch {
            print("Error importing calculation history: \(error)")
            return false
        }
    }
}

// MARK: - Supporting Types

struct CalculationStatistics {
    let totalCalculations: Int
    let averageStatedProtein: Double
    let averageQualityAdjustedProtein: Double
    let mostUsedSources: [(String, Int)]
}
