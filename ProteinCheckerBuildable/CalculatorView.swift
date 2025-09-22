import SwiftUI

struct CalculatorView: View {
    @State private var statedProtein: String = ""
    @State private var dvPercentage: String = ""
    @State private var selectedCategory: ProteinCategory = .all
    @State private var selectedProteinSource: ProteinSource?
    @State private var calculationResult: CalculationResult?
    @State private var showingProteinPicker = false
    @State private var searchText = ""
    
    private let dataManager = DataManager.shared
    private let proteinDatabase = ProteinSourcesDatabase.shared
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Protein Quality Calculator")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        
                        Text("Calculate quality-adjusted protein using DIAAS/PDCAAS scores")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top)
                    
                    // Input Section
                    VStack(spacing: 16) {
                        // Protein Amount Input
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Protein Amount")
                                .font(.headline)
                            
                            HStack {
                                TextField("Enter protein grams", text: $statedProtein)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.decimalPad)
                                Text("g")
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        // DV Percentage Input (Optional)
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Daily Value % (Optional)")
                                .font(.headline)
                            
                            HStack {
                                TextField("e.g., 25", text: $dvPercentage)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.decimalPad)
                                Text("%")
                                    .foregroundColor(.secondary)
                            }
                            
                            Text("If provided, DV% will be used to calculate protein amount")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        // Protein Source Selection
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Protein Source")
                                .font(.headline)
                            
                            Button(action: {
                                showingProteinPicker = true
                            }) {
                                HStack {
                                    Text(selectedProteinSource?.name ?? "Select protein source")
                                        .foregroundColor(selectedProteinSource == nil ? .secondary : .primary)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Calculate Button
                    Button(action: calculateProtein) {
                        Text("Calculate Quality-Adjusted Protein")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(canCalculate ? Color.blue : Color.gray)
                            .cornerRadius(12)
                    }
                    .disabled(!canCalculate)
                    .padding(.horizontal)
                    
                    // Results Section
                    if let result = calculationResult {
                        ResultsCard(result: result, statedProtein: Double(statedProtein) ?? 0)
                            .padding(.horizontal)
                    }
                    
                    Spacer(minLength: 100) // Space for tab bar
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingProteinPicker) {
                ProteinSourcePicker(
                    selectedSource: $selectedProteinSource,
                    selectedCategory: $selectedCategory,
                    searchText: $searchText
                )
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
    
    private var canCalculate: Bool {
        !statedProtein.isEmpty && 
        selectedProteinSource != nil && 
        Double(statedProtein) != nil &&
        Double(statedProtein)! > 0
    }
    
    private func calculateProtein() {
        guard let statedProteinValue = Double(statedProtein),
              let proteinSource = selectedProteinSource else {
            return
        }
        
        let dvPercentageValue = Double(dvPercentage.isEmpty ? "0" : dvPercentage)
        
        let input = CalculationInput(
            statedProtein: statedProteinValue,
            dvPercentage: dvPercentageValue == 0 ? nil : dvPercentageValue,
            proteinSource: proteinSource
        )
        
        let result = calculateDigestibleProtein(input: input)
        self.calculationResult = result
        
        // Save to history
        let calculationRecord = createCalculationRecord(input: input, result: result)
        dataManager.saveCalculation(calculationRecord)
        
        hideKeyboard()
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct ResultsCard: View {
    let result: CalculationResult
    let statedProtein: Double
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Results")
                .font(.title2)
                .fontWeight(.bold)
            
            VStack(spacing: 12) {
                // Main Result
                HStack {
                    VStack(alignment: .leading) {
                        Text("Quality-Adjusted Protein")
                            .font(.headline)
                        Text("Based on \(result.calculationMethod.rawValue) score")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Text(formatProteinAmount(result.qualityAdjustedProtein))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
                
                Divider()
                
                // Quality Percentage
                HStack {
                    Text("Protein Quality")
                        .font(.headline)
                    Spacer()
                    Text(formatPercentage(result.proteinQualityPercentage))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(colorForPercentage(result.proteinQualityPercentage))
                }
                
                // Score Used
                HStack {
                    Text("\(result.calculationMethod.rawValue) Score")
                        .font(.headline)
                    Spacer()
                    Text(String(format: "%.2f", result.scoreUsed))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                }
                
                // DV Adjustment (if applicable)
                if let adjustedProtein = result.adjustedProtein {
                    Divider()
                    HStack {
                        Text("DV% Adjusted Amount")
                            .font(.headline)
                        Spacer()
                        Text(formatProteinAmount(adjustedProtein))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.orange)
                    }
                }
                
                // DV Discrepancy Warning
                if let discrepancy = result.dvDiscrepancy, discrepancy > 0.5 {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.orange)
                        Text("Note: Stated protein differs from DV% by \(formatProteinAmount(discrepancy))")
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                    .padding(.top, 4)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private func colorForPercentage(_ percentage: Double) -> Color {
        if percentage <= 40 {
            return .red
        } else if percentage <= 80 {
            return .orange
        } else {
            return .green
        }
    }
}

#Preview {
    CalculatorView()
}
