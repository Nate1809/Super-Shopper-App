//
//  ShoppingItem.swift
//  Super Shopper
//
//  Created by Nathan Guzman on 10/25/24.
//

// ShoppingItem.swift

import Foundation

class ShoppingItem: Identifiable, ObservableObject, Equatable {
    var id = UUID()
    @Published var name: String
    @Published var quantity: Int
    
    init(name: String, quantity: Int) {
        self.name = name
        self.quantity = quantity
    }
    
    // Implement the Equatable protocol
    static func == (lhs: ShoppingItem, rhs: ShoppingItem) -> Bool {
        return lhs.id == rhs.id
    }
}
