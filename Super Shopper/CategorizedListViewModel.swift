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
        // Initialize main categories with empty subcategories
        var tempCategorizedItems: [MainCategory] = []

        // Get unique categories from the model's labels
        let uniqueCategories = Set(productClassifier.model.modelDescription.classLabels as? [String] ?? [])

        // Create main categories and subcategories based on the model's labels
        for category in uniqueCategories {
            // Split main category and subcategory if needed
            // Assuming categories are in the format "MainCategory / SubCategory"
            let components = category.components(separatedBy: " / ")
            let mainCategoryName = components.first ?? "Other"
            let subCategoryName = components.count > 1 ? components[1] : "Miscellaneous"

            // Find or create the main category
            if let mainIndex = tempCategorizedItems.firstIndex(where: { $0.name == mainCategoryName }) {
                // Main category exists, add subcategory if needed
                if !tempCategorizedItems[mainIndex].subcategories.contains(where: { $0.name == subCategoryName }) {
                    tempCategorizedItems[mainIndex].subcategories.append(SubCategory(name: subCategoryName))
                }
            } else {
                // Create new main category with subcategory
                let newMainCategory = MainCategory(name: mainCategoryName, subcategories: [SubCategory(name: subCategoryName)])
                tempCategorizedItems.append(newMainCategory)
            }
        }

        // Initialize items in subcategories
        for i in 0..<tempCategorizedItems.count {
            for j in 0..<tempCategorizedItems[i].subcategories.count {
                tempCategorizedItems[i].subcategories[j].items = []
            }
        }

        // Assign items to categories using the ML model
        for item in shoppingItems {
            let categoryLabel = predictCategory(for: item.name)
            let components = categoryLabel.components(separatedBy: " / ")
            let mainCategoryName = components.first ?? "Other"
            let subCategoryName = components.count > 1 ? components[1] : "Miscellaneous"

            // Find the main category
            if let mainIndex = tempCategorizedItems.firstIndex(where: { $0.name == mainCategoryName }) {
                // Find the subcategory
                if let subIndex = tempCategorizedItems[mainIndex].subcategories.firstIndex(where: { $0.name == subCategoryName }) {
                    tempCategorizedItems[mainIndex].subcategories[subIndex].items.append(item)
                } else {
                    // If subcategory doesn't exist, create it
                    let newSubCategory = SubCategory(name: subCategoryName, items: [item])
                    tempCategorizedItems[mainIndex].subcategories.append(newSubCategory)
                }
            } else {
                // If main category doesn't exist, create it
                let newSubCategory = SubCategory(name: subCategoryName, items: [item])
                let newMainCategory = MainCategory(name: mainCategoryName, subcategories: [newSubCategory])
                tempCategorizedItems.append(newMainCategory)
            }
        }

        // Update the published property
        self.categorizedItems = tempCategorizedItems
    }
    
    // MARK: - Prediction Function
    private func predictCategory(for productName: String) -> String {
        do {
            let prediction = try productClassifier.prediction(text: productName)
            return prediction.label
        } catch {
            print("Error predicting category for '\(productName)': \(error)")
            return "Other / Miscellaneous" // Default category in case of an error
        }
    }
    
    // MARK: - Category Management
    func categoryActionSheetButtons() -> [ActionSheet.Button] {
        // Flatten all subcategories with their main category names
        let buttons: [ActionSheet.Button] = categorizedItems.flatMap { mainCategory in
            mainCategory.subcategories.map { subCategory in
                ActionSheet.Button.default(Text("\(mainCategory.name) / \(subCategory.name)")) { [weak self] in
                    self?.reassignItem(toMain: mainCategory.name, toSub: subCategory.name)
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
