import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            CalculatorView()
                .tabItem {
                    Image(systemName: "plus.circle")
                    Text("Calculator")
                }
            
            HistoryView()
                .tabItem {
                    Image(systemName: "clock")
                    Text("History")
                }
            
            EducationView()
                .tabItem {
                    Image(systemName: "book")
                    Text("Learn")
                }
        }
        .accentColor(.blue)
    }
}

#Preview {
    ContentView()
}
