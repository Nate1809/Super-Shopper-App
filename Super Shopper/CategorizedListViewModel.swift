// CategorizedListViewModel.swift

import Foundation
import SwiftUI
import CoreData
import CoreML
import NaturalLanguage

class CategorizedListViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var shoppingItems: [CDShoppingItem] = [] // Updated to CDShoppingItem
    @Published var categorizedItems: [MainCategory] = []
    @Published var selectedStore: String
    @Published var showCategoryPicker: Bool = false
    @Published var selectedItem: CDShoppingItem? = nil // Updated to CDShoppingItem
    @Published var mainCategoriesList: [MainCategory] = []

    // New Published Property for Category Picker
    @Published var selectedMainCategory: String? = nil

    // MARK: - Core Data Context
    private var viewContext: NSManagedObjectContext

    // MARK: - ML Model
    private let productClassifier = ProductCategoryClassifier()

    // MARK: - Initializer
    init(shoppingItems: [CDShoppingItem], selectedStore: String, context: NSManagedObjectContext) {
        self.viewContext = context
        self.shoppingItems = shoppingItems
        self.selectedStore = selectedStore
        categorizeItems()
    }

    // MARK: - Categorization Logic
    func categorizeItems() {
        // Get the mapping for the selected store
        let mapping = CategoryMappings.mappings[selectedStore] ?? CategoryMappings.genericMapping

        // Initialize main categories
        var tempCategorizedItems: [MainCategory] = []

        // Get unique main categories from the mapping
        let mainCategoriesSet = Set(mapping.values)
        for mainCategoryName in mainCategoriesSet {
            tempCategorizedItems.append(MainCategory(name: mainCategoryName, subcategories: []))
        }

        // Assign items to categories
        for item in shoppingItems {
            // Check if the user has assigned categories
            let mainCategoryName: String
            let subCategoryName: String

            if let userMainCategory = item.userAssignedMainCategory,
               let userSubCategory = item.userAssignedSubCategory {
                // Use user-assigned categories
                mainCategoryName = userMainCategory
                subCategoryName = userSubCategory
            } else {
                // Preprocess the item name
                let preprocessedName = TextPreprocessor.preprocess(text: item.wrappedName)

                // Use model prediction
                let predictedSubCategory = predictCategory(for: preprocessedName)
                subCategoryName = predictedSubCategory
                mainCategoryName = mapping[predictedSubCategory] ?? "Other"
            }

            // Find or create the main category
            if let mainIndex = tempCategorizedItems.firstIndex(where: { $0.name == mainCategoryName }) {
                // Main category exists
                var subcategories = tempCategorizedItems[mainIndex].subcategories
                // Find or create the subcategory
                if let subIndex = subcategories.firstIndex(where: { $0.name == subCategoryName }) {
                    // Subcategory exists, add the item
                    subcategories[subIndex].items.append(item)
                } else {
                    // Create new subcategory
                    let newSubCategory = SubCategory(name: subCategoryName, items: [item])
                    subcategories.append(newSubCategory)
                }
                tempCategorizedItems[mainIndex].subcategories = subcategories
            } else {
                // Main category doesn't exist, create it
                let newSubCategory = SubCategory(name: subCategoryName, items: [item])
                let newMainCategory = MainCategory(name: mainCategoryName, subcategories: [newSubCategory])
                tempCategorizedItems.append(newMainCategory)
            }
        }

        // Update the published property
        DispatchQueue.main.async {
            self.categorizedItems = tempCategorizedItems
        }
    }

    // MARK: - Prediction Function
    private func predictCategory(for preprocessedName: String) -> String {
        do {
            let prediction = try productClassifier.prediction(text: preprocessedName)
            return prediction.label
        } catch {
            print("Error predicting category for '\(preprocessedName)': \(error)")
            return "Other" // Default subcategory in case of an error
        }
    }

    // MARK: - Category Management
    /// Returns a list of all main category names.
    var mainCategoryNames: [String] {
        let mapping = CategoryMappings.mappings[selectedStore] ?? CategoryMappings.genericMapping
        let mainCategories = Set(mapping.values)
        return mainCategories.sorted()
    }

    /// Returns the subcategories for a given main category.
    func subcategories(for mainCategory: String) -> [String] {
        let mapping = CategoryMappings.mappings[selectedStore] ?? CategoryMappings.genericMapping
        let subcategories = mapping.filter { $0.value == mainCategory }.map { $0.key }
        return subcategories.sorted()
    }

    /// Returns the emoji for a given main category.
    func emojiForMainCategory(_ mainCategory: String) -> String {
        return CategoryMappings.mainCategoryEmojis[mainCategory] ?? ""
    }

    /// Returns the emoji for a given subcategory.
    func emojiForSubCategory(_ subCategory: String) -> String {
        return CategoryMappings.subcategoryEmojis[subCategory] ?? ""
    }

    // MARK: - Reassigning Categories
    func reassignItem(toMain main: String, toSub sub: String) {
        guard let item = selectedItem else { return }

        // Update the Core Data entity
        item.userAssignedMainCategory = main
        item.userAssignedSubCategory = sub

        saveChanges()

        // Re-categorize items
        categorizeItems()

        // Reset selection
        selectedItem = nil
        showCategoryPicker = false
        selectedMainCategory = nil
    }

    // MARK: - Deletion Functionality
    func deleteItem(_ item: CDShoppingItem) {
        viewContext.delete(item)
        saveChanges()
        categorizeItems()
    }

    // MARK: - Saving Changes
    func saveChanges() {
        do {
            try viewContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }

    // MARK: - Computed Properties
    /// Returns only the main categories that have items in their subcategories.
    var nonEmptyCategorizedItems: [MainCategory] {
        categorizedItems.filter { mainCategory in
            mainCategory.subcategories.contains(where: { !$0.items.isEmpty })
        }
    }
}
