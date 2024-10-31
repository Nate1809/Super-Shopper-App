// StoreLayout.swift

import Foundation

struct StoreLayout {
    static func layout(for store: String) -> [StoreSection] {
        switch store {
        case "Target":
            return targetLayout()
        case "Whole Foods":
            return wholeFoodsLayout()
        case "HEB":
            return hebLayout()
        default:
            return defaultLayout()
        }
    }

    static func targetLayout() -> [StoreSection] {
        return [
            StoreSection(name: "Entrance", position: StoreSection.Position(x: 0, y: 0), category: "Entrance"),
            StoreSection(name: "Produce", position: StoreSection.Position(x: 1, y: 1), category: "Groceries"),
            StoreSection(name: "Dairy", position: StoreSection.Position(x: 2, y: 1), category: "Groceries"),
            StoreSection(name: "Bakery", position: StoreSection.Position(x: 3, y: 1), category: "Groceries"),
            StoreSection(name: "Meat", position: StoreSection.Position(x: 4, y: 1), category: "Groceries"),
            StoreSection(name: "Seafood", position: StoreSection.Position(x: 5, y: 1), category: "Groceries"),
            StoreSection(name: "Detergents", position: StoreSection.Position(x: 6, y: 1), category: "Cleaning"),
            StoreSection(name: "Hair Care", position: StoreSection.Position(x: 7, y: 1), category: "Beauty")
            // Add more sections as needed
        ]
    }

    static func wholeFoodsLayout() -> [StoreSection] {
        return [
            StoreSection(name: "Entrance", position: StoreSection.Position(x: 0, y: 0), category: "Entrance"),
            StoreSection(name: "Produce", position: StoreSection.Position(x: 1, y: 1), category: "Groceries"),
            StoreSection(name: "Dairy", position: StoreSection.Position(x: 2, y: 1), category: "Groceries"),
            StoreSection(name: "Bakery", position: StoreSection.Position(x: 3, y: 1), category: "Groceries"),
            StoreSection(name: "Meat", position: StoreSection.Position(x: 4, y: 1), category: "Groceries"),
            StoreSection(name: "Seafood", position: StoreSection.Position(x: 5, y: 1), category: "Groceries"),
            StoreSection(name: "Detergents", position: StoreSection.Position(x: 6, y: 1), category: "Cleaning"),
            StoreSection(name: "Hair Care", position: StoreSection.Position(x: 7, y: 1), category: "Beauty")
            // Add more sections as needed
        ]
    }

    static func hebLayout() -> [StoreSection] {
        return [
            StoreSection(name: "Entrance", position: StoreSection.Position(x: 0, y: 0), category: "Entrance"),
            StoreSection(name: "Produce", position: StoreSection.Position(x: 1, y: 1), category: "Groceries"),
            StoreSection(name: "Dairy", position: StoreSection.Position(x: 2, y: 1), category: "Groceries"),
            StoreSection(name: "Bakery", position: StoreSection.Position(x: 3, y: 1), category: "Groceries"),
            StoreSection(name: "Meat", position: StoreSection.Position(x: 4, y: 1), category: "Groceries"),
            StoreSection(name: "Seafood", position: StoreSection.Position(x: 5, y: 1), category: "Groceries"),
            StoreSection(name: "Detergents", position: StoreSection.Position(x: 6, y: 1), category: "Cleaning"),
            StoreSection(name: "Hair Care", position: StoreSection.Position(x: 7, y: 1), category: "Beauty")
            // Add more sections as needed
        ]
    }

    static func defaultLayout() -> [StoreSection] {
        return [
            StoreSection(name: "Entrance", position: StoreSection.Position(x: 0, y: 0), category: "Entrance"),
            StoreSection(name: "Produce", position: StoreSection.Position(x: 1, y: 1), category: "Groceries"),
            StoreSection(name: "Dairy", position: StoreSection.Position(x: 2, y: 1), category: "Groceries"),
            StoreSection(name: "Bakery", position: StoreSection.Position(x: 3, y: 1), category: "Groceries"),
            StoreSection(name: "Meat", position: StoreSection.Position(x: 4, y: 1), category: "Groceries"),
            StoreSection(name: "Seafood", position: StoreSection.Position(x: 5, y: 1), category: "Groceries"),
            StoreSection(name: "Detergents", position: StoreSection.Position(x: 6, y: 1), category: "Cleaning"),
            StoreSection(name: "Hair Care", position: StoreSection.Position(x: 7, y: 1), category: "Beauty")
            // Add more sections as needed
        ]
    }
}
