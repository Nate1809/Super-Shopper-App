// PathViewModel.swift

import Foundation
import SwiftUI
import Combine

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
    @Published var allItemsGrabbed: Bool = false // New property

    // MARK: - Store Layout and Aisle Mapping
    let storeLayout: [StoreSection]
    let aisleMapping: [String: String]

    // MARK: - Combine Cancellables
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization
    init(categorizedItems: [MainCategory], selectedStore: String) {
        self.storeLayout = StoreLayout.layout(for: selectedStore)
        self.aisleMapping = CategoryMappings.aisleMappings[selectedStore] ?? CategoryMappings.genericAisleMapping

        // Compute the optimal path
        self.path = PathViewModel.computeOptimalPath(from: categorizedItems, with: storeLayout, aisleMapping: aisleMapping)

        // Observe changes to grabbedItems to automatically navigate
        observeGrabbedItems()
    }

    // MARK: - Path Computation
    static func computeOptimalPath(from categorizedItems: [MainCategory], with storeLayout: [StoreSection], aisleMapping: [String: String]) -> [AisleCategory] {
        // Flatten all items with their corresponding aisles
        var aisleToItems: [String: [ShoppingItem]] = [:]

        for mainCategory in categorizedItems {
            for subCategory in mainCategory.subcategories {
                let aisleName = aisleMapping[subCategory.name] ?? "Aisle 30: Other"
                aisleToItems[aisleName, default: []].append(contentsOf: subCategory.items)
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
    private func observeGrabbedItems() {
        // Observe changes to grabbedItems
        $grabbedItems
            .sink { [weak self] _ in
                self?.checkAndNavigate()
            }
            .store(in: &cancellables)
    }

    // MARK: - Check and Navigate Automatically
    private func checkAndNavigate() {
        guard currentAisleIndex < path.count else { return }

        let currentAisleCategory = path[currentAisleIndex]

        let allItemsGrabbedInCurrentAisle = currentAisleCategory.items.allSatisfy { grabbedItems.contains($0.id) }

        if allItemsGrabbedInCurrentAisle {
            moveToNextAisle()
        }
    }

    // MARK: - Check if All Items are Grabbed
    private func checkIfAllItemsGrabbed() {
        let totalItems = path.flatMap { $0.items }.count
        if grabbedItems.count == totalItems && totalItems > 0 {
            allItemsGrabbed = true

            // Optional: Automatically reset after 3 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.allItemsGrabbed = false
            }
        } else {
            allItemsGrabbed = false
        }
    }

    // MARK: - Navigation Methods
    func moveToNextAisle() {
        if currentAisleIndex < path.count - 1 {
            currentAisleIndex += 1
        }
    }

    func moveToPreviousAisle() {
        if currentAisleIndex > 0 {
            currentAisleIndex -= 1
        }
    }

    // MARK: - Item Grabbing Methods
    func toggleItemGrabbed(_ item: ShoppingItem) {
        if grabbedItems.contains(item.id) {
            grabbedItems.remove(item.id)
        } else {
            grabbedItems.insert(item.id)
        }
    }

    func isItemGrabbed(_ item: ShoppingItem) -> Bool {
        grabbedItems.contains(item.id)
    }

    // MARK: - Current Aisle
    var currentAisleCategory: AisleCategory {
        path[currentAisleIndex]
    }

    var isFirstAisle: Bool {
        currentAisleIndex == 0
    }

    var isLastAisle: Bool {
        currentAisleIndex >= path.count - 1
    }
}

// MARK: - AisleCategory Struct
struct AisleCategory: Identifiable, Hashable {
    let id = UUID()
    let name: String
    var items: [ShoppingItem]
}
