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
    var itemsArray: [CDShoppingItem] {
        let set = items as? Set<CDShoppingItem> ?? []
        // Sort by dateAdded ascending to maintain insertion order
        return set.sorted {
            ($0.dateAdded ?? Date.distantPast) < ($1.dateAdded ?? Date.distantPast)
        }
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
        newItem.dateAdded = Date() // Set the dateAdded to current date
        newItem.list = self
    }

    /// Deletes an item from the shopping list
    /// - Parameters:
    ///   - item: The item to delete
    ///   - context: Managed object context
    func removeItem(_ item: CDShoppingItem, context: NSManagedObjectContext) {
        self.removeFromItems(item)
        context.delete(item)
    }
}

