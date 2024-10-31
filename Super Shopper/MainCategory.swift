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
    var items: [ShoppingItem]
    
    init(name: String, items: [ShoppingItem] = []) {
        self.name = name
        self.items = items
    }
}
