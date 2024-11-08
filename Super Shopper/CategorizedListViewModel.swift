import Foundation
import SwiftUI
import CoreML
import NaturalLanguage

class CategorizedListViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var shoppingItems: [ShoppingItem] = []
    @Published var categorizedItems: [MainCategory] = []
    @Published var selectedStore: String
    @Published var showCategoryPicker: Bool = false
    @Published var selectedItem: ShoppingItem? = nil
    @Published var mainCategoriesList: [MainCategory] = []

    // MARK: - ML Model
    private let productClassifier = ProductCategoryClassifier()

    // MARK: - Initializer
    init(shoppingItems: [ShoppingItem], selectedStore: String) {
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
                let preprocessedName = TextPreprocessor.preprocess(text: item.name)
                
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
        self.categorizedItems = tempCategorizedItems
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
    func categoryActionSheetButtons() -> [ActionSheet.Button] {
        // Use all possible categories from the mappings
        let mapping = CategoryMappings.mappings[selectedStore] ?? CategoryMappings.genericMapping

        // Build a dictionary of main categories to their subcategories
        var mainToSubcategories: [String: [String]] = [:]

        for (subCategory, mainCategory) in mapping {
            mainToSubcategories[mainCategory, default: []].append(subCategory)
        }

        // Sort main categories and subcategories for consistent order
        let sortedMainCategories = mainToSubcategories.keys.sorted()

        let buttons: [ActionSheet.Button] = sortedMainCategories.flatMap { mainCategoryName in
            let subCategories = mainToSubcategories[mainCategoryName]?.sorted() ?? []
            return subCategories.map { subCategoryName in
                ActionSheet.Button.default(Text("\(mainCategoryName) / \(subCategoryName)")) { [weak self] in
                    self?.reassignItem(toMain: mainCategoryName, toSub: subCategoryName)
                }
            }
        } + [.cancel()]

        return buttons
    }

    func reassignItem(toMain main: String, toSub sub: String) {
        guard let item = selectedItem else { return }

        // Remove item from its current category
        for mainIndex in categorizedItems.indices {
            for subIndex in categorizedItems[mainIndex].subcategories.indices {
                if let itemIndex = categorizedItems[mainIndex].subcategories[subIndex].items.firstIndex(of: item) {
                    categorizedItems[mainIndex].subcategories[subIndex].items.remove(at: itemIndex)
                    break
                }
            }
        }

        // Save the user-assigned categories to the item
        item.userAssignedMainCategory = main
        item.userAssignedSubCategory = sub

        // Add the item to the new category
        if let mainIndex = categorizedItems.firstIndex(where: { $0.name == main }) {
            if let subIndex = categorizedItems[mainIndex].subcategories.firstIndex(where: { $0.name == sub }) {
                categorizedItems[mainIndex].subcategories[subIndex].items.append(item)
            } else {
                // If subcategory doesn't exist, create it
                let newSubCategory = SubCategory(name: sub, items: [item])
                categorizedItems[mainIndex].subcategories.append(newSubCategory)
            }
        } else {
            // If main category doesn't exist, create it
            let newSubCategory = SubCategory(name: sub, items: [item])
            let newMainCategory = MainCategory(name: main, subcategories: [newSubCategory])
            categorizedItems.append(newMainCategory)
        }

        // Reset selection
        selectedItem = nil
        showCategoryPicker = false
    }

    // MARK: - Deletion Functionality
    func deleteItem(_ item: ShoppingItem) {
        if let index = shoppingItems.firstIndex(of: item) {
            shoppingItems.remove(at: index)
            categorizeItems()
        }
    }
}
