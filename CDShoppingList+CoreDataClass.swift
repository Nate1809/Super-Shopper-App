//
//  CDShoppingList+CoreDataClass.swift
//  Super Shopper
//
//  Created by Nathan Guzman on 11/12/24.
//
//

import Foundation
import CoreData

@objc(CDShoppingList)
public class CDShoppingList: NSManagedObject {

}

// CDShoppingList+Extensions.swift

extension CDShoppingList {
    /// Computed property to get items as a sorted array
    var itemsArray: [CDShoppingItem] {
        let set = items as? Set<CDShoppingItem> ?? []
        return set.sorted { ($0.name ?? "") < ($1.name ?? "") }
    }

    /// Adds a new item to the shopping list
    /// - Parameters:
    ///   - name: Name of the item
    ///   - quantity: Quantity of the item
    ///   - context: Managed object context
    func addItem(name: String, quantity: Int16, context: NSManagedObjectContext) {
        let newItem = CDShoppingItem(context: context)
        newItem.id = UUID()
        newItem.name = name
        newItem.quantity = quantity
        newItem.isCompleted = false
        newItem.list = self
    }

    /// Deletes an item from the shopping list
    /// - Parameter item: The item to delete
    func removeItem(_ item: CDShoppingItem, context: NSManagedObjectContext) {
        self.removeFromItems(item)
        context.delete(item)
    }
}

