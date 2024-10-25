//
//  ShoppingItem.swift
//  Super Shopper
//
//  Created by Nathan Guzman on 10/25/24.
//

// ShoppingItem.swift

import Foundation

struct ShoppingItem: Identifiable, Equatable {
    var id = UUID()
    var name: String
    var quantity: Int

    static func == (lhs: ShoppingItem, rhs: ShoppingItem) -> Bool {
        return lhs.id == rhs.id
    }
}
