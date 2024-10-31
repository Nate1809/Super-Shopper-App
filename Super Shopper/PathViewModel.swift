// PathViewModel.swift

import Foundation
import SwiftUI
import Combine

class PathViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var path: [MainCategory] = []
    @Published var currentMainSectionIndex: Int = 0
    @Published var grabbedItems: Set<UUID> = [] {
        didSet {
            checkAndNavigate()
        }
    }
    
    // MARK: - Store Layout
    let storeLayout: [StoreSection]
    
    // MARK: - Combine Cancellables
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(categorizedItems: [MainCategory], selectedStore: String) {
        self.storeLayout = StoreLayout.layout(for: selectedStore)
        self.path = PathViewModel.computeOptimalPath(from: categorizedItems, with: storeLayout)
        
        // Observe changes to grabbedItems to automatically navigate
        observeGrabbedItems()
    }
    
    // MARK: - Path Computation
    static func computeOptimalPath(from categorizedItems: [MainCategory], with storeLayout: [StoreSection]) -> [MainCategory] {
        // Filter out empty subcategories
        let filteredMainCategories = categorizedItems.map { mainCategory -> MainCategory in
            let nonEmptySubcategories = mainCategory.subcategories.filter { !$0.items.isEmpty }
            return MainCategory(name: mainCategory.name, subcategories: nonEmptySubcategories)
        }.filter { !$0.subcategories.isEmpty }
        
        // Sort main categories based on store layout positions (e.g., left to right, top to bottom)
        return filteredMainCategories.sorted { main1, main2 in
            guard let pos1 = storeLayout.first(where: { $0.category == main1.name })?.position,
                  let pos2 = storeLayout.first(where: { $0.category == main2.name })?.position else {
                return main1.name < main2.name
            }
            // Example sorting logic: ascending order based on x + y positions
            return (pos1.x + pos1.y) < (pos2.x + pos2.y)
        }
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
        guard currentMainSectionIndex < path.count else { return }
        
        let currentMainSection = path[currentMainSectionIndex]
        let allItemsGrabbed = currentMainSection.subcategories.flatMap { $0.items }.allSatisfy { grabbedItems.contains($0.id) }
        
        print("Checking navigation: All items in section '\(currentMainSection.name)' grabbed? \(allItemsGrabbed)")
        
        if allItemsGrabbed {
            if currentMainSectionIndex < path.count - 1 {
                currentMainSectionIndex += 1
                print("Automatically moved to next section: \(path[currentMainSectionIndex].name)")
            } else {
                print("All sections completed.")
            }
        }
    }

    
    // MARK: - Navigation Methods
    func moveToNextMainSection() {
        if currentMainSectionIndex < path.count - 1 {
            currentMainSectionIndex += 1
            print("Moved to next section: \(path[currentMainSectionIndex].name)")
        }
    }
    
    func moveToPreviousMainSection() {
        if currentMainSectionIndex > 0 {
            currentMainSectionIndex -= 1
            print("Moved to previous section: \(path[currentMainSectionIndex].name)")
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
