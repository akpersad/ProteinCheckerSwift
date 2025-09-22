import SwiftUI

struct ProteinSourcePicker: View {
    @Binding var selectedSource: ProteinSource?
    @Binding var selectedCategory: ProteinCategory
    @Binding var searchText: String
    @Environment(\.presentationMode) var presentationMode
    
    private let proteinDatabase = ProteinSourcesDatabase.shared
    
    var filteredSources: [ProteinSource] {
        let sources = proteinDatabase.searchSources(query: searchText, category: selectedCategory)
        return sources
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
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
                
                // Protein Sources List
                List(filteredSources) { source in
                    ProteinSourceRow(
                        source: source,
                        isSelected: selectedSource?.id == source.id,
                        action: {
                            selectedSource = source
                            presentationMode.wrappedValue.dismiss()
                        }
                    )
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Select Protein Source")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search protein sources...", text: $text)
                .textFieldStyle(PlainTextFieldStyle())
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

struct CategoryChip: View {
    let category: ProteinCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(category.displayName)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color(.systemGray6))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
    }
}

struct ProteinSourceRow: View {
    let source: ProteinSource
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(source.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(source.category.displayName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    if let description = source.description {
                        Text(description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    if let diaasScore = source.diaasScore {
                        HStack {
                            Text("DIAAS:")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(String(format: "%.2f", diaasScore))
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(scoreColor(diaasScore))
                        }
                    }
                    
                    if let pdcaasScore = source.pdcaasScore {
                        HStack {
                            Text("PDCAAS:")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(String(format: "%.2f", pdcaasScore))
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(scoreColor(pdcaasScore))
                        }
                    }
                }
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                }
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func scoreColor(_ score: Double) -> Color {
        if score >= 1.0 {
            return .green
        } else if score >= 0.8 {
            return .orange
        } else {
            return .red
        }
    }
}

#Preview {
    ProteinSourcePicker(
        selectedSource: .constant(nil),
        selectedCategory: .constant(.all),
        searchText: .constant("")
    )
}
