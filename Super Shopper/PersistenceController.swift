// PersistenceController.swift
// Super Shopper

import CoreData

struct PersistenceController {
    // Singleton instance for the entire app
    static let shared = PersistenceController()

    // Persistent container for Core Data
    let container: NSPersistentContainer

    // Initializer for PersistenceController
    init(inMemory: Bool = false) {
        // Initialize the container with the name matching your .xcdatamodeld file
        container = NSPersistentContainer(name: "SuperShopperModel") // Replace with your actual model name if different

        // If inMemory is true, configure the container for in-memory storage (useful for previews/testing)
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        // Load the persistent stores
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the app to crash. In a production app, handle errors gracefully.
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        // Automatically merge changes from parent contexts
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    /// Preview instance for SwiftUI previews
    static var preview: PersistenceController = {
        // Initialize PersistenceController with inMemory storage
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext

        // Create sample data for previews
        for i in 0..<5 {
            let newList = CDShoppingList(context: viewContext)
            newList.id = UUID()
            newList.name = "Sample List \(i + 1)"
            newList.dateCreated = Date()

            for j in 0..<3 {
                let newItem = CDShoppingItem(context: viewContext)
                newItem.id = UUID()
                newItem.name = "Sample Item \(j + 1)"
                newItem.quantity = Int16(j + 1)
                newItem.isCompleted = false
                newItem.list = newList
            }
        }

        // Save the context to persist the sample data
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error during preview setup: \(nsError), \(nsError.userInfo)")
        }

        return result
    }()
}
