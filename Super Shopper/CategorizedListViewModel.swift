import Foundation
import SwiftUI

class CategorizedListViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var shoppingItems: [ShoppingItem] = []
    @Published var categorizedItems: [MainCategory] = []
    @Published var selectedStore: String
    @Published var showCategoryPicker: Bool = false
    @Published var selectedItem: ShoppingItem? = nil
    @Published var mainCategoriesList: [MainCategory] = []
    
    // MARK: - Category Mappings
    private let categoryMappings: [String: (main: String, sub: String)] = [
        "flour": ("Groceries", "Flours"),
        "milk": ("Groceries", "Dairy"),
        "apple": ("Groceries", "Fruits"),
        "bread": ("Groceries", "Bakery"),
        "chicken": ("Groceries", "Meat"),
        "salmon": ("Groceries", "Seafood"),
        "detergent": ("Cleaning", "Detergents"),
        "shampoo": ("Beauty", "Hair Care"),
        "conditioner": ("Beauty", "Hair Care"),
        "toothpaste": ("Beauty", "Personal Hygiene")
        // Add more mappings as needed
    ]
    
    // MARK: - Initializer
    init(shoppingItems: [ShoppingItem], selectedStore: String) {
        self.shoppingItems = shoppingItems
        self.selectedStore = selectedStore
        categorizeItems()
    }
    
    // MARK: - Categorization Logic
    func categorizeItems() {
        // Define main categories and their subcategories
        var tempCategorizedItems: [MainCategory] = [
            MainCategory(name: "Groceries", subcategories: [
                SubCategory(name: "Flours"),
                SubCategory(name: "Fruits"),
                SubCategory(name: "Dairy"),
                SubCategory(name: "Bakery"),
                SubCategory(name: "Meat"),
                SubCategory(name: "Seafood")
            ]),
            MainCategory(name: "Beauty", subcategories: [
                SubCategory(name: "Hair Care"),
                SubCategory(name: "Skincare"),
                SubCategory(name: "Personal Hygiene")
            ]),
            MainCategory(name: "Cleaning", subcategories: [
                SubCategory(name: "Detergents"),
                SubCategory(name: "Cleaning Tools")
            ]),
            MainCategory(name: "Menswear", subcategories: [
                SubCategory(name: "Shirts"),
                SubCategory(name: "Pants"),
                SubCategory(name: "Accessories")
            ]),
            MainCategory(name: "Other", subcategories: [
                SubCategory(name: "Miscellaneous")
            ])
        ]
        
        // Initialize items in subcategories
        for i in 0..<tempCategorizedItems.count {
            for j in 0..<tempCategorizedItems[i].subcategories.count {
                tempCategorizedItems[i].subcategories[j].items = []
            }
        }
        
        // Assign items to categories based on mapping
        for item in shoppingItems {
            let lowercasedName = item.name.lowercased()
            var assigned = false
            
            for (keyword, (main, sub)) in categoryMappings {
                if lowercasedName.contains(keyword) {
                    if let mainIndex = tempCategorizedItems.firstIndex(where: { $0.name == main }) {
                        if let subIndex = tempCategorizedItems[mainIndex].subcategories.firstIndex(where: { $0.name == sub }) {
                            tempCategorizedItems[mainIndex].subcategories[subIndex].items.append(item)
                            assigned = true
                            break
                        }
                    }
                }
            }
            
            if !assigned {
                // Assign to "Other > Miscellaneous"
                if let otherMainIndex = tempCategorizedItems.firstIndex(where: { $0.name == "Other" }) {
                    if let miscSubIndex = tempCategorizedItems[otherMainIndex].subcategories.firstIndex(where: { $0.name == "Miscellaneous" }) {
                        tempCategorizedItems[otherMainIndex].subcategories[miscSubIndex].items.append(item)
                    }
                }
            }
        }
        
        self.categorizedItems = tempCategorizedItems
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
            }
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
