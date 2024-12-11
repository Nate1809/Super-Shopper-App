//
//  CDShoppingItem+CoreDataClass.swift
//  Super Shopper
//
//  Created by Nathan Guzman on 11/12/24.
//
//

import Foundation
import CoreData

@objc(CDShoppingItem)
public class CDShoppingItem: NSManagedObject {

}

extension CDShoppingItem {
    /// Unwraps the optional name property
    var wrappedName: String {
        name ?? "Unknown Item"
    }

    /// Toggles the completion status of the item
    func toggleCompletion() {
        isCompleted.toggle()
        saveContext()
    }

    /// Updates the quantity with validation
    /// - Parameter newQuantity: The new quantity value
    func updateQuantity(to newQuantity: Int16) {
        quantity = max(newQuantity, 1)
        saveContext()
    }

    /// Saves the managed object context
    private func saveContext() {
        do {
            try self.managedObjectContext?.save()
        } catch {
            print("Failed to save context after toggling completion: \(error)")
        }
    }
}

