import SwiftUI

struct EducationView: View {
    @State private var selectedTopic: EducationTopic = .overview
    
    var body: some View {
        NavigationView {
            VStack {
                // Topic Selector
                TopicSelector(selectedTopic: $selectedTopic)
                    .padding(.horizontal)
                
                // Content Area
                ScrollView {
                    VStack(spacing: 20) {
                        switch selectedTopic {
                        case .overview:
                            OverviewContent()
                        case .diaas:
                            DIAASContent()
                        case .pdcaas:
                            PDCAASContent()
                        case .proteinSources:
                            ProteinSourcesContent()
                        case .practicalTips:
                            PracticalTipsContent()
                        }
                        
                        Spacer(minLength: 100) // Space for tab bar
                    }
                    .padding()
                }
            }
            .navigationTitle("Learn About Protein")
        }
    }
}

enum EducationTopic: String, CaseIterable {
    case overview = "Overview"
    case diaas = "DIAAS"
    case pdcaas = "PDCAAS"
    case proteinSources = "Sources"
    case practicalTips = "Tips"
    
    var displayName: String {
        switch self {
        case .overview: return "Overview"
        case .diaas: return "DIAAS Score"
        case .pdcaas: return "PDCAAS Score"
        case .proteinSources: return "Protein Sources"
        case .practicalTips: return "Practical Tips"
        }
    }
}

struct TopicSelector: View {
    @Binding var selectedTopic: EducationTopic
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(EducationTopic.allCases, id: \.self) { topic in
                    Button(action: {
                        selectedTopic = topic
                    }) {
                        Text(topic.displayName)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(selectedTopic == topic ? Color.blue : Color(.systemGray6))
                            .foregroundColor(selectedTopic == topic ? .white : .primary)
                            .cornerRadius(20)
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
    }
}

struct OverviewContent: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            EducationCard(
                title: "What is Protein Quality?",
                content: """
                Protein quality refers to how well a protein provides the essential amino acids your body needs. It's determined by two main factors:
                
                • **Amino Acid Profile**: Does it contain all essential amino acids?
                • **Digestibility**: How well can your body absorb and use it?
                
                DIAAS and PDCAAS are scientific methods to measure these factors.
                """
            )
            
            EducationCard(
                title: "Why Does This Matter?",
                content: """
                Understanding protein quality helps you:
                
                • Make informed dietary choices
                • Ensure adequate amino acid intake
                • Optimize muscle protein synthesis
                • Plan balanced meals effectively
                
                Not all proteins are created equal!
                """
            )
            
            EducationCard(
                title: "How to Use This App",
                content: """
                1. **Enter** the protein amount from your food label
                2. **Add** Daily Value % if available (more accurate)
                3. **Select** your protein source from our database
                4. **Calculate** to see the quality-adjusted protein amount
                5. **Review** your history to track patterns
                
                The app uses scientific DIAAS/PDCAAS scores for accuracy.
                """
            )
        }
    }
}

struct DIAASContent: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            EducationCard(
                title: "What is DIAAS?",
                content: """
                **Digestible Indispensable Amino Acid Score (DIAAS)** is the gold standard for measuring protein quality, recommended by the FAO since 2013.
                
                DIAAS measures:
                • Individual amino acid digestibility
                • Limiting amino acid content
                • Real absorption at the end of the small intestine
                """
            )
            
            EducationCard(
                title: "DIAAS Score Interpretation",
                content: """
                **Excellent (≥1.0)**: Complete, high-quality protein
                Examples: Whey (1.25), Milk (1.18), Eggs (1.13)
                
                **Good (0.8-0.99)**: High-quality with minor limitations
                Examples: Soy protein (0.90), Tofu (0.87)
                
                **Fair (0.6-0.79)**: Moderate quality, some limitations
                Examples: Quinoa (0.84), Hemp seeds (0.61)
                
                **Poor (<0.6)**: Significant amino acid limitations
                Examples: Rice protein (0.42), Almonds (0.40)
                """
            )
            
            EducationCard(
                title: "Advantages of DIAAS",
                content: """
                • More accurate than PDCAAS
                • Measures actual absorption
                • Accounts for processing effects
                • Can exceed 1.0 (showing superior quality)
                • Considers individual amino acid digestibility
                """
            )
        }
    }
}

struct PDCAASContent: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            EducationCard(
                title: "What is PDCAAS?",
                content: """
                **Protein Digestibility Corrected Amino Acid Score (PDCAAS)** was the previous gold standard for protein quality assessment (1989-2013).
                
                PDCAAS considers:
                • Amino acid composition
                • Overall protein digestibility
                • Limiting amino acid
                """
            )
            
            EducationCard(
                title: "PDCAAS Limitations",
                content: """
                • Capped at 1.0 (can't show superior quality)
                • Uses fecal digestibility (less accurate)
                • Assumes all amino acids digest equally
                • Doesn't account for processing effects
                • Overestimates some plant protein quality
                """
            )
            
            EducationCard(
                title: "When We Use PDCAAS",
                content: """
                This app uses PDCAAS as a fallback when DIAAS data isn't available. Many protein sources still only have PDCAAS scores in scientific literature.
                
                While less accurate than DIAAS, PDCAAS still provides valuable insight into protein quality and is widely used in nutrition labeling.
                """
            )
        }
    }
}

struct ProteinSourcesContent: View {
    private let proteinDatabase = ProteinSourcesDatabase.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            EducationCard(
                title: "Animal vs. Plant Proteins",
                content: """
                **Animal Proteins** typically score higher because they:
                • Contain all essential amino acids
                • Have better digestibility
                • Match human amino acid needs closely
                
                **Plant Proteins** often score lower due to:
                • Missing or limited amino acids
                • Lower digestibility
                • Anti-nutritional factors
                """
            )
            
            // Top Quality Sources
            VStack(alignment: .leading, spacing: 12) {
                Text("Highest Quality Sources")
                    .font(.title2)
                    .fontWeight(.bold)
                
                let topSources = proteinDatabase.getHighestQualitySources(limit: 8)
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 12) {
                    ForEach(topSources) { source in
                        ProteinSourceCard(source: source)
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            
            EducationCard(
                title: "Combining Plant Proteins",
                content: """
                You can improve plant protein quality by combining sources:
                
                **Complementary Proteins**:
                • Rice + Beans = Complete amino acid profile
                • Peanut Butter + Whole Wheat = Better balance
                • Hummus + Pita = Improved quality
                
                You don't need to combine at every meal - just throughout the day!
                """
            )
        }
    }
}

struct PracticalTipsContent: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            EducationCard(
                title: "Reading Nutrition Labels",
                content: """
                **Look for**:
                • Protein grams per serving
                • Daily Value percentage (more accurate for calculations)
                • Ingredient list (identifies protein source)
                
                **Red Flags**:
                • "Protein blend" without specifics
                • Very cheap protein powders
                • Missing amino acid information
                """
            )
            
            EducationCard(
                title: "Daily Protein Needs",
                content: """
                **General Population**: 0.8g per kg body weight
                **Active Individuals**: 1.2-1.6g per kg body weight
                **Athletes/Bodybuilders**: 1.6-2.2g per kg body weight
                
                **Example**: 70kg person needs 56-154g protein daily
                
                Quality matters as much as quantity!
                """
            )
            
            EducationCard(
                title: "Meal Planning Tips",
                content: """
                • Include a high-quality protein at each meal
                • Combine different plant proteins throughout the day
                • Don't rely solely on supplements
                • Consider protein timing around workouts
                • Aim for 20-30g high-quality protein per meal
                """
            )
            
            EducationCard(
                title: "Common Mistakes",
                content: """
                ❌ **Assuming all proteins are equal**
                ✅ Check DIAAS/PDCAAS scores
                
                ❌ **Only counting total grams**
                ✅ Consider quality-adjusted amounts
                
                ❌ **Ignoring Daily Value percentages**
                ✅ Use DV% for more accurate calculations
                
                ❌ **Not varying protein sources**
                ✅ Diversify for complete nutrition
                """
            )
        }
    }
}

struct EducationCard: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.blue)
            
            Text(content)
                .font(.body)
                .lineSpacing(2)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct ProteinSourceCard: View {
    let source: ProteinSource
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(source.name)
                .font(.headline)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
            
            if let diaasScore = source.diaasScore {
                HStack {
                    Text("DIAAS:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(String(format: "%.2f", diaasScore))
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(scoreColor(diaasScore))
                }
            } else if let pdcaasScore = source.pdcaasScore {
                HStack {
                    Text("PDCAAS:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(String(format: "%.2f", pdcaasScore))
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(scoreColor(pdcaasScore))
                }
            }
            
            Text(source.category.displayName)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 1)
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
    EducationView()
}
