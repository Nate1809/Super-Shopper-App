// StoreLayout.swift

import Foundation

struct StoreLayout {
    static func layout(for store: String) -> [StoreSection] {
        switch store {
        case "Target":
            return targetLayout()
        default:
            return defaultLayout()
        }
    }

    static func targetLayout() -> [StoreSection] {
        return [
            StoreSection(name: "Aisle 1: Fresh Produce", position: StoreSection.Position(x: 1, y: 1), category: "Grocery"),
            StoreSection(name: "Aisle 2: Dairy Products", position: StoreSection.Position(x: 2, y: 1), category: "Grocery"),
            StoreSection(name: "Aisle 3: Meats and Seafood", position: StoreSection.Position(x: 3, y: 1), category: "Grocery"),
            StoreSection(name: "Aisle 4: Bakery", position: StoreSection.Position(x: 4, y: 1), category: "Grocery"),
            StoreSection(name: "Aisle 5: Frozen Foods", position: StoreSection.Position(x: 5, y: 1), category: "Grocery"),
            StoreSection(name: "Aisle 6: Beverages", position: StoreSection.Position(x: 6, y: 1), category: "Grocery"),
            StoreSection(name: "Aisle 7: Snacks", position: StoreSection.Position(x: 7, y: 1), category: "Grocery"),
            StoreSection(name: "Aisle 8: Breakfast Foods", position: StoreSection.Position(x: 8, y: 1), category: "Grocery"),
            StoreSection(name: "Aisle 9: Baking Supplies", position: StoreSection.Position(x: 9, y: 1), category: "Grocery"),
            StoreSection(name: "Aisle 10: Canned Goods", position: StoreSection.Position(x: 10, y: 1), category: "Grocery"),
            StoreSection(name: "Aisle 11: Pasta and Rice", position: StoreSection.Position(x: 11, y: 1), category: "Grocery"),
            StoreSection(name: "Aisle 12: International Foods", position: StoreSection.Position(x: 12, y: 1), category: "Grocery"),
            // Include other aisles as needed
            StoreSection(name: "Aisle 17: Health and Wellness", position: StoreSection.Position(x: 17, y: 1), category: "Health or Pharmacy"),
            StoreSection(name: "Aisle 18: Baby Products", position: StoreSection.Position(x: 18, y: 1), category: "Baby"),
            StoreSection(name: "Aisle 19: Pet Supplies", position: StoreSection.Position(x: 19, y: 1), category: "Pets"),
            StoreSection(name: "Aisle 20: Household Essentials", position: StoreSection.Position(x: 20, y: 1), category: "Household Essentials"),
            StoreSection(name: "Aisle 30: Other", position: StoreSection.Position(x: 30, y: 1), category: "Other")
        ]
    }

    static func defaultLayout() -> [StoreSection] {
        return targetLayout() // Use Target's layout as the default
    }
}
