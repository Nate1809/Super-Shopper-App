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

import Foundation
import CoreData

extension CDShoppingList {
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
        self.removeItem(<#T##item: CDShoppingItem##CDShoppingItem#>, context: <#T##NSManagedObjectContext#>) // Correct placement
        context.delete(item)
    }
}
