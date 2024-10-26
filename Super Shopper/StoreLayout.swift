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
            StoreSection(name: "Produce", position: StoreSection.Position(x: 1, y: 1), category: "Produce"),
            StoreSection(name: "Dairy", position: StoreSection.Position(x: 2, y: 1), category: "Dairy"),
            StoreSection(name: "Bakery", position: StoreSection.Position(x: 3, y: 1), category: "Bakery"),
            StoreSection(name: "Meat", position: StoreSection.Position(x: 4, y: 1), category: "Meat"),
            StoreSection(name: "Seafood", position: StoreSection.Position(x: 5, y: 1), category: "Seafood"),
            StoreSection(name: "Cleaning Supplies", position: StoreSection.Position(x: 6, y: 1), category: "Cleaning Supplies"),
            StoreSection(name: "Beauty", position: StoreSection.Position(x: 7, y: 1), category: "Beauty")
        ]
    }

    static func wholeFoodsLayout() -> [StoreSection] {
        return [
            StoreSection(name: "Produce", position: StoreSection.Position(x: 1, y: 1), category: "Produce"),
            StoreSection(name: "Dairy", position: StoreSection.Position(x: 2, y: 1), category: "Dairy"),
            StoreSection(name: "Bakery", position: StoreSection.Position(x: 3, y: 1), category: "Bakery"),
            StoreSection(name: "Meat", position: StoreSection.Position(x: 4, y: 1), category: "Meat"),
            StoreSection(name: "Seafood", position: StoreSection.Position(x: 5, y: 1), category: "Seafood"),
            StoreSection(name: "Health & Beauty", position: StoreSection.Position(x: 6, y: 1), category: "Beauty"),
            StoreSection(name: "Household", position: StoreSection.Position(x: 7, y: 1), category: "Cleaning Supplies")
        ]
    }

    static func hebLayout() -> [StoreSection] {
        return [
            StoreSection(name: "Produce", position: StoreSection.Position(x: 1, y: 1), category: "Produce"),
            StoreSection(name: "Dairy", position: StoreSection.Position(x: 2, y: 1), category: "Dairy"),
            StoreSection(name: "Bakery", position: StoreSection.Position(x: 3, y: 1), category: "Bakery"),
            StoreSection(name: "Meat", position: StoreSection.Position(x: 4, y: 1), category: "Meat"),
            StoreSection(name: "Seafood", position: StoreSection.Position(x: 5, y: 1), category: "Seafood"),
            StoreSection(name: "Cleaning Supplies", position: StoreSection.Position(x: 6, y: 1), category: "Cleaning Supplies"),
            StoreSection(name: "Beauty", position: StoreSection.Position(x: 7, y: 1), category: "Beauty")
        ]
    }

    static func defaultLayout() -> [StoreSection] {
        return [
            StoreSection(name: "Produce", position: StoreSection.Position(x: 1, y: 1), category: "Produce"),
            StoreSection(name: "Dairy", position: StoreSection.Position(x: 2, y: 1), category: "Dairy"),
            StoreSection(name: "Bakery", position: StoreSection.Position(x: 3, y: 1), category: "Bakery"),
            StoreSection(name: "Meat", position: StoreSection.Position(x: 4, y: 1), category: "Meat"),
            StoreSection(name: "Seafood", position: StoreSection.Position(x: 5, y: 1), category: "Seafood"),
            StoreSection(name: "Cleaning Supplies", position: StoreSection.Position(x: 6, y: 1), category: "Cleaning Supplies"),
            StoreSection(name: "Beauty", position: StoreSection.Position(x: 7, y: 1), category: "Beauty")
        ]
    }
}
