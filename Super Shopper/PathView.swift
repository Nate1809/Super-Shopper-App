// PathView.swift

import SwiftUI

struct PathView: View {
    var categorizedItems: [String: [ShoppingItem]]
    var selectedStore: String
    @State private var pathSections: [StoreSection] = []
    @State private var sectionItemsMapping: [StoreSection: [ShoppingItem]] = [:]
    
    var body: some View {
        List {
            ForEach(pathSections) { section in
                Section(header: Text(section.name)) {
                    if let items = sectionItemsMapping[section] {
                        ForEach(items) { item in
                            HStack {
                                Text(item.name)
                                Spacer()
                                Text("Qty: \(item.quantity)")
                            }
                        }
                    } else {
                        Text("No items for this section.")
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Optimal Path")
        .onAppear {
            calculatePath()
        }
    }
    
    // Calculate Path Function
    func calculatePath() {
        let storeSections = StoreLayout.layout(for: selectedStore)
        let neededCategories = Set(categorizedItems.keys)
        let neededSections = storeSections.filter { neededCategories.contains($0.category) }
        pathSections = neededSections.sorted { $0.position.x < $1.position.x }
        
        // Map each section to its items
        for section in pathSections {
            if let items = categorizedItems[section.category] {
                sectionItemsMapping[section] = items
            }
        }
    }
}

#Preview {
    PathView(categorizedItems: [
        "Produce": [ShoppingItem(name: "Apples", quantity: 2)],
        "Dairy": [ShoppingItem(name: "Milk", quantity: 1)],
        "Bakery": [ShoppingItem(name: "Bread", quantity: 1)],
        "Meat": [ShoppingItem(name: "Chicken", quantity: 3)],
        "Beauty": [ShoppingItem(name: "Shampoo", quantity: 1)]
    ], selectedStore: "Target")
}
