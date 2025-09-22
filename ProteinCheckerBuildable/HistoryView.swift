import SwiftUI

struct HistoryView: View {
    @State private var calculationHistory: [ProteinCalculation] = []
    @State private var searchText = ""
    @State private var selectedCategory: ProteinCategory = .all
    @State private var showingStatistics = false
    @State private var showingClearAlert = false
    
    private let dataManager = DataManager.shared
    
    var filteredHistory: [ProteinCalculation] {
        var history = calculationHistory
        
        // Filter by category
        if selectedCategory != .all {
            history = history.filter { $0.proteinSource.category == selectedCategory }
        }
        
        // Filter by search text
        if !searchText.isEmpty {
            history = history.filter { calculation in
                calculation.proteinSource.name.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return history
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if calculationHistory.isEmpty {
                    EmptyHistoryView()
                } else {
                    VStack {
                        // Search and Filter
                        SearchBar(text: $searchText)
                            .padding(.horizontal)
                        
                        // Category Filter
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(ProteinCategory.allCases, id: \.self) { category in
                                    CategoryChip(
                                        category: category,
                                        isSelected: selectedCategory == category,
                                        action: {
                                            selectedCategory = category
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical, 8)
                        
                        // History List
                        List {
                            ForEach(filteredHistory) { calculation in
                                HistoryRow(calculation: calculation)
                            }
                            .onDelete(perform: deleteCalculations)
                        }
                        .listStyle(PlainListStyle())
                    }
                }
            }
            .navigationTitle("Calculation History")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Statistics") {
                        showingStatistics = true
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Clear History") {
                            showingClearAlert = true
                        }
                        Button("Export Data") {
                            exportHistory()
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .onAppear {
                loadHistory()
            }
            .sheet(isPresented: $showingStatistics) {
                StatisticsView()
            }
            .alert(isPresented: $showingClearAlert) {
                Alert(
                    title: Text("Clear History"),
                    message: Text("This will permanently delete all calculation history. This action cannot be undone."),
                    primaryButton: .destructive(Text("Clear All")) {
                        clearHistory()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
    
    private func loadHistory() {
        calculationHistory = dataManager.getCalculationHistory()
    }
    
    private func deleteCalculations(at offsets: IndexSet) {
        for index in offsets {
            let calculation = filteredHistory[index]
            dataManager.deleteCalculation(withId: calculation.id)
        }
        loadHistory()
    }
    
    private func clearHistory() {
        dataManager.clearCalculationHistory()
        loadHistory()
    }
    
    private func exportHistory() {
        guard let data = dataManager.exportCalculationHistory() else { return }
        
        let activityController = UIActivityViewController(
            activityItems: [data],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityController, animated: true)
        }
    }
}

struct EmptyHistoryView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "clock.badge.questionmark")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text("No Calculations Yet")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Your protein calculations will appear here. Start by using the calculator tab.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
}

struct HistoryRow: View {
    let calculation: ProteinCalculation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header with protein source and timestamp
            HStack {
                Text(calculation.proteinSource.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text(formatDate(calculation.timestamp))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Results summary
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Stated: \(formatProteinAmount(calculation.statedProtein))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("Quality-Adjusted: \(formatProteinAmount(calculation.digestibleProtein))")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(calculation.calculationMethod.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .cornerRadius(4)
                    
                    Text(formatPercentage(calculation.digestibilityPercentage))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(colorForPercentage(calculation.digestibilityPercentage))
                }
            }
            
            // DV% if available
            if let dvPercentage = calculation.dvPercentage {
                Text("Daily Value: \(formatPercentage(dvPercentage))")
                    .font(.caption)
                    .foregroundColor(.orange)
            }
        }
        .padding(.vertical, 4)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
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

struct StatisticsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var statistics: CalculationStatistics?
    
    private let dataManager = DataManager.shared
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if let stats = statistics {
                    VStack(spacing: 16) {
                        // Total Calculations
                        StatCard(
                            title: "Total Calculations",
                            value: "\(stats.totalCalculations)",
                            icon: "number.circle"
                        )
                        
                        // Average Protein
                        StatCard(
                            title: "Average Stated Protein",
                            value: formatProteinAmount(stats.averageStatedProtein),
                            icon: "scalemass"
                        )
                        
                        // Average Quality-Adjusted
                        StatCard(
                            title: "Average Quality-Adjusted",
                            value: formatProteinAmount(stats.averageQualityAdjustedProtein),
                            icon: "star.circle"
                        )
                        
                        // Most Used Sources
                        if !stats.mostUsedSources.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Most Used Sources")
                                    .font(.headline)
                                
                                ForEach(Array(stats.mostUsedSources.enumerated()), id: \.offset) { index, source in
                                    HStack {
                                        Text("\(index + 1).")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        
                                        Text(source.0)
                                            .font(.subheadline)
                                        
                                        Spacer()
                                        
                                        Text("\(source.1) times")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        }
                    }
                    .padding()
                } else {
                    Text("Loading statistics...")
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .navigationTitle("Statistics")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .onAppear {
                loadStatistics()
            }
        }
    }
    
    private func loadStatistics() {
        statistics = dataManager.getCalculationStatistics()
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    HistoryView()
}
