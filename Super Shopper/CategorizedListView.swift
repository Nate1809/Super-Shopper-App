//
//  CategorizedListView.swift
//  Super Shopper
//
//  Created by Nathan Guzman on 10/25/24.
//


// CategorizedListView.swift

import SwiftUI

struct CategorizedListView: View {
    var shoppingItems: [ShoppingItem]
    var selectedStore: String
    @State private var categorizedItems: [String: [ShoppingItem]] = [:]
    @State private var showCategoryPicker: Bool = false
    @State private var selectedItem: ShoppingItem?
    @State private var categoriesList: [String] = []

    var body: some View {
        VStack {
            List {
                ForEach(categorizedItems.keys.sorted(), id: \.self) { category in
                    Section(header: Text(category)) {
                        ForEach(categorizedItems[category]!) { item in
                            HStack {
                                Text(item.name)
                                Spacer()
                                Text("Qty: \(item.quantity)")
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedItem = item
                                showCategoryPicker = true
                            }
                        }
                    }
                }
            }

            NavigationLink(destination: PathView(
                categorizedItems: categorizedItems,
                selectedStore: selectedStore
            )) {
                Text("Show Optimal Path")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(8)
            }
            .padding()
        }
        .navigationTitle("Categorized Items")
        .onAppear {
            categorizeItems()
            categoriesList = Array(getAllCategories())
        }
        .actionSheet(isPresented: $showCategoryPicker) {
            ActionSheet(
                title: Text("Select Category"),
                message: Text("Assign a category to '\(selectedItem?.name ?? "")'"),
                buttons: categoryActionSheetButtons()
            )
        }
    }

    func categorizeItems() {
        let categories = [
            "Produce": ["apple", "banana", "carrot", "lettuce"],
            "Dairy": ["milk", "cheese", "yogurt"],
            "Bakery": ["bread", "bagel", "muffin"],
            "Meat": ["chicken", "beef", "pork"],
            "Seafood": ["salmon", "shrimp", "tuna"],
            "Cleaning Supplies": ["detergent", "bleach", "soap"],
            "Beauty": ["shampoo", "conditioner", "toothpaste"]
        ]

        var tempCategorizedItems: [String: [ShoppingItem]] = [:]

        for item in shoppingItems {
            var foundCategory = false
            let lowercasedItemName = item.name.lowercased()

            for (category, keywords) in categories {
                if keywords.contains(where: { lowercasedItemName.contains($0) }) {
                    tempCategorizedItems[category, default: []].append(item)
                    foundCategory = true
                    break
                }
            }

            if !foundCategory {
                tempCategorizedItems["Other", default: []].append(item)
            }
        }

        self.categorizedItems = tempCategorizedItems
    }

    func getAllCategories() -> Set<String> {
        let predefinedCategories = [
            "Produce", "Dairy", "Bakery", "Meat", "Seafood", "Cleaning Supplies", "Beauty"
        ]
        let otherCategories = categorizedItems.keys
        return Set(predefinedCategories).union(otherCategories)
    }

    func categoryActionSheetButtons() -> [ActionSheet.Button] {
        var buttons: [ActionSheet.Button] = []

        for category in categoriesList {
            buttons.append(.default(Text(category)) {
                reassignItem(to: category)
            })
        }

        buttons.append(.cancel())
        return buttons
    }

    func reassignItem(to newCategory: String) {
        guard let item = selectedItem else { return }
        
        // Remove from current category
        for (category, items) in categorizedItems {
            if let index = items.firstIndex(of: item) {
                categorizedItems[category]?.remove(at: index)
                break
            }
        }
        
        // Add to new category
        categorizedItems[newCategory, default: []].append(item)
    }
}
