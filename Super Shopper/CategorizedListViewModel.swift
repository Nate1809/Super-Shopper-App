// CategorizedListViewModel.swift

import Foundation
import SwiftUI

class CategorizedListViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var shoppingItems: [ShoppingItem] = []
    @Published var categorizedItems: [String: [ShoppingItem]] = [:]
    @Published var selectedStore: String
    @Published var showCategoryPicker: Bool = false
    @Published var selectedItem: ShoppingItem? = nil
    @Published var categoriesList: [String] = []
    
    // Removed properties related to confirmation alerts
    // @Published var showReassignConfirmation: Bool = false
    // @Published var categoryToReassign: String? = nil
    
    // MARK: - Initializer
    init(shoppingItems: [ShoppingItem], selectedStore: String) {
        self.shoppingItems = shoppingItems
        self.selectedStore = selectedStore
        categorizeItems()
    }
    
    // MARK: - Categorization Logic
    /// Categorizes shopping items based on predefined keywords
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
            let lowercasedItemName = item.name.lowercased()
            var foundCategory = false
            
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
    
    // MARK: - Category Management
    /// Retrieves all categories, including predefined and custom ones
    func getAllCategories() -> Set<String> {
        let predefinedCategories = [
            "Produce", "Dairy", "Bakery", "Meat", "Seafood", "Cleaning Supplies", "Beauty"
        ]
        let otherCategories = categorizedItems.keys
        return Set(predefinedCategories).union(otherCategories)
    }
    
    /// Generates action sheet buttons for category selection using map for cleaner code
    func categoryActionSheetButtons() -> [ActionSheet.Button] {
        // Use map to transform categoriesList into ActionSheet buttons
        let categoryButtons = categoriesList.map { category in
            ActionSheet.Button.default(Text(category)) { [weak self] in
                self?.reassignItem(to: category)
            }
        }
        
        // Append the cancel button
        return categoryButtons + [.cancel()]
    }
    
    /// Reassigns the selected item to a new category without confirmation
    func reassignItem(to newCategory: String) {
        guard let item = selectedItem else { return }
        
        // Identify the current category of the item
        var currentCategory: String? = nil
        for (categoryName, items) in categorizedItems {
            if items.contains(item) {
                currentCategory = categoryName
                break
            }
        }
        
        // Remove the item from its current category
        if let category = currentCategory,
           let index = categorizedItems[category]?.firstIndex(of: item) {
            categorizedItems[category]?.remove(at: index)
            
            // If the category is now empty, remove it from the dictionary
            if categorizedItems[category]?.isEmpty == true {
                categorizedItems.removeValue(forKey: category)
            }
        }
        
        // Add the item to the new category
        categorizedItems[newCategory, default: []].append(item)
        
        // Reset the reassignment properties
        selectedItem = nil
        showCategoryPicker = false
    }
}
