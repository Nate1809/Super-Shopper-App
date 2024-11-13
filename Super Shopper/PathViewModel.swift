// PathViewModel.swift

import Foundation
import SwiftUI
import Combine
import CoreData

class PathViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var path: [AisleCategory] = []
    @Published var currentAisleIndex: Int = 0
    @Published var grabbedItems: Set<UUID> = [] {
        didSet {
            checkAndNavigate()
            checkIfAllItemsGrabbed()
        }
    }
    @Published var allItemsGrabbed: Bool = false

    // MARK: - Store Layout and Aisle Mapping
    private var storeLayout: [StoreSection] = []
    private var aisleMapping: [String: String] = [:] // Corrected Initialization

    // MARK: - Core Data Context
    private var viewContext: NSManagedObjectContext

    // MARK: - Combine Cancellables
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization
    /// Initializes the PathViewModel with categorized items and the selected store.
    /// - Parameters:
    ///   - categorizedItems: The list of categorized shopping items.
    ///   - selectedStore: The name of the selected store.
    ///   - context: The Core Data managed object context.
    init(categorizedItems: [MainCategory], selectedStore: String, context: NSManagedObjectContext) {
        self.viewContext = context
        self.storeLayout = StoreLayout.layout(for: selectedStore)
        self.aisleMapping = CategoryMappings.aisleMappings[selectedStore] ?? CategoryMappings.genericAisleMapping

        // Compute the initial optimal path
        self.path = PathViewModel.computeOptimalPath(from: categorizedItems, with: storeLayout, aisleMapping: aisleMapping)

        // Observe changes to grabbedItems to handle navigation
        observeGrabbedItems()
    }

    // MARK: - Path Computation
    /// Computes the optimal shopping path based on categorized items, store layout, and aisle mappings.
    /// - Parameters:
    ///   - categorizedItems: The list of categorized shopping items.
    ///   - storeLayout: The layout of the store's aisles.
    ///   - aisleMapping: The mapping of subcategories to aisles.
    /// - Returns: An ordered list of `AisleCategory` representing the optimal shopping path.
    static func computeOptimalPath(from categorizedItems: [MainCategory], with storeLayout: [StoreSection], aisleMapping: [String: String]) -> [AisleCategory] {
        // Flatten all items with their corresponding aisles
        var aisleToItems: [String: [CDShoppingItem]] = [:]

        for mainCategory in categorizedItems {
            for subCategory in mainCategory.subcategories {
                let aisleName = aisleMapping[subCategory.name] ?? "Aisle 30: Other"
                aisleToItems[aisleName, default: []] += subCategory.items // Use += for appending
            }
        }

        // Sort aisles based on store layout positions
        let sortedAisles = storeLayout
            .filter { aisleToItems.keys.contains($0.name) }
            .sorted {
                ($0.position.x + $0.position.y) < ($1.position.x + $1.position.y)
            }
            .map { $0.name }

        // Append any aisles not in the store layout at the end
        let remainingAisles = aisleToItems.keys.filter { !sortedAisles.contains($0) }.sorted()
        let allSortedAisles = sortedAisles + remainingAisles

        // Create AisleCategory objects
        var path: [AisleCategory] = []
        for aisle in allSortedAisles {
            if let items = aisleToItems[aisle], !items.isEmpty {
                path.append(AisleCategory(name: aisle, items: items))
            }
        }

        return path
    }

    // MARK: - Observation for Automatic Navigation
    /// Observes changes to `grabbedItems` to handle automatic navigation between aisles.
    private func observeGrabbedItems() {
        // Observe changes to grabbedItems
        $grabbedItems
            .sink { [weak self] _ in
                self?.checkAndNavigate()
            }
            .store(in: &cancellables)
    }

    // MARK: - Check and Navigate Automatically
    /// Checks if all items in the current aisle are grabbed and navigates to the next aisle if necessary.
    private func checkAndNavigate() {
        guard currentAisleIndex < path.count else { return }

        let currentAisleCategory = path[currentAisleIndex]

        // Ensure item IDs are not nil
        let allItemsGrabbedInCurrentAisle = currentAisleCategory.items.allSatisfy { item in
            guard let itemID = item.id else { return false }
            return grabbedItems.contains(itemID)
        }

        if allItemsGrabbedInCurrentAisle {
            moveToNextAisle()
        }
    }

    // MARK: - Check if All Items are Grabbed
    /// Checks if all items across all aisles have been grabbed.
    private func checkIfAllItemsGrabbed() {
        let totalItems = path.flatMap { $0.items }.count

        if grabbedItems.count == totalItems && totalItems > 0 {
            allItemsGrabbed = true
        } else {
            allItemsGrabbed = false
        }
    }

    // MARK: - Navigation Methods
    /// Moves to the next aisle in the path if not at the end.
    func moveToNextAisle() {
        if currentAisleIndex < path.count - 1 {
            currentAisleIndex += 1
        }
    }

    /// Moves to the previous aisle in the path if not at the beginning.
    func moveToPreviousAisle() {
        if currentAisleIndex > 0 {
            currentAisleIndex -= 1
        }
    }

    // MARK: - Item Grabbing Methods
    /// Toggles the grabbed state of a given shopping item.
    /// - Parameter item: The shopping item to toggle.
    func toggleItemGrabbed(_ item: CDShoppingItem) {
        guard let itemID = item.id else { return }

        if grabbedItems.contains(itemID) {
            grabbedItems.remove(itemID)
        } else {
            grabbedItems.insert(itemID)
        }
    }

    /// Checks if a given shopping item has been grabbed.
    /// - Parameter item: The shopping item to check.
    /// - Returns: `true` if the item is grabbed; otherwise, `false`.
    func isItemGrabbed(_ item: CDShoppingItem) -> Bool {
        guard let itemID = item.id else { return false }
        return grabbedItems.contains(itemID)
    }

    // MARK: - Current Aisle
    /// The currently active aisle category.
    var currentAisleCategory: AisleCategory {
        if currentAisleIndex < path.count {
            return path[currentAisleIndex]
        } else {
            return AisleCategory(name: "Unknown Aisle", items: [])
        }
    }

    /// Indicates whether the current aisle is the first in the path.
    var isFirstAisle: Bool {
        currentAisleIndex == 0
    }

    /// Indicates whether the current aisle is the last in the path.
    var isLastAisle: Bool {
        currentAisleIndex >= path.count - 1
    }

    // MARK: - Update Path Method
    /// Updates the shopping path based on new categorized items.
    /// This should be called whenever the categorized items change (e.g., items added/removed or categories changed).
    /// - Parameter categorizedItems: The updated list of categorized shopping items.
    func updatePath(categorizedItems: [MainCategory]) {
        // Recompute the path based on new categorizedItems
        self.path = PathViewModel.computeOptimalPath(from: categorizedItems, with: storeLayout, aisleMapping: aisleMapping)

        // Reset navigation state
        self.currentAisleIndex = 0
        self.grabbedItems = []
        self.allItemsGrabbed = false
    }
}

// MARK: - AisleCategory Struct
struct AisleCategory: Identifiable, Hashable {
    let id = UUID()
    let name: String
    var items: [CDShoppingItem]
}
