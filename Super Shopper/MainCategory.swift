// MainCategory.swift

import Foundation

struct MainCategory: Identifiable, Hashable {
    let id = UUID()
    let name: String
    var subcategories: [SubCategory]
}

struct SubCategory: Identifiable, Hashable {
    let id = UUID()
    let name: String
    var items: [CDShoppingItem] // Updated to use CDShoppingItem

    init(name: String, items: [CDShoppingItem] = []) { // Updated initializer
        self.name = name
        self.items = items
    }
}
