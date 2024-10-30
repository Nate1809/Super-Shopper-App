import Foundation
import SwiftUI

class PathViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var path: [MainCategory] = []
    @Published var currentMainSectionIndex: Int = 0
    @Published var grabbedItems: Set<UUID> = []
    
    // MARK: - Store Layout
    let storeLayout: [StoreSection]
    
    // MARK: - Initialization
    init(categorizedItems: [MainCategory], selectedStore: String) {
        self.storeLayout = StoreLayout.layout(for: selectedStore)
        self.path = PathViewModel.computeOptimalPath(from: categorizedItems, with: storeLayout)
    }
    
    // MARK: - Path Computation
    static func computeOptimalPath(from categorizedItems: [MainCategory], with storeLayout: [StoreSection]) -> [MainCategory] {
        // Implement your A* or any pathfinding algorithm here.
        // For simplicity, we'll assume the path is predefined or computed elsewhere.
        // This function should return an ordered list of MainCategory with ordered SubCategories.
        
        // Placeholder implementation:
        // Sort main categories based on store layout positions
        return categorizedItems.sorted { main1, main2 in
            guard let pos1 = storeLayout.first(where: { $0.category == main1.name })?.position,
                  let pos2 = storeLayout.first(where: { $0.category == main2.name })?.position else {
                return main1.name < main2.name
            }
            return (pos1.x + pos1.y) < (pos2.x + pos2.y)
        }
    }
    
    // MARK: - Navigation
    func moveToNextMainSection() {
        if currentMainSectionIndex < path.count - 1 {
            currentMainSectionIndex += 1
        }
    }
    
    func moveToPreviousMainSection() {
        if currentMainSectionIndex > 0 {
            currentMainSectionIndex -= 1
        }
    }
    
    // MARK: - Item Grabbing
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
    
    // MARK: - Current Main Section
    var currentMainSection: MainCategory {
        path[currentMainSectionIndex]
    }
    
    var isFirstMainSection: Bool {
        currentMainSectionIndex == 0
    }
    
    var isLastMainSection: Bool {
        currentMainSectionIndex >= path.count - 1
    }
}
