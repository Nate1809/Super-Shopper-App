//
//  StoreLayout.swift
//  Super Shopper
//
//  Created by Nathan Guzman on 10/25/24.
//

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
            StoreSection(name: "Produce", position: (x: 1, y: 1), category: "Produce"),
            StoreSection(name: "Dairy", position: (x: 2, y: 1), category: "Dairy"),
            StoreSection(name: "Bakery", position: (x: 3, y: 1), category: "Bakery"),
            StoreSection(name: "Meat", position: (x: 4, y: 1), category: "Meat"),
            StoreSection(name: "Seafood", position: (x: 5, y: 1), category: "Seafood"),
            StoreSection(name: "Cleaning Supplies", position: (x: 6, y: 1), category: "Cleaning Supplies"),
            StoreSection(name: "Beauty", position: (x: 7, y: 1), category: "Beauty")
        ]
    }

    static func wholeFoodsLayout() -> [StoreSection] {
        // Define Whole Foods layout
        return []
    }

    static func hebLayout() -> [StoreSection] {
        // Define HEB layout
        return []
    }

    static func defaultLayout() -> [StoreSection] {
        // Define a default layout
        return []
    }
}
