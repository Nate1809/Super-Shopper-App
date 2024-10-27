// PathViewModel.swift

import Foundation
import SwiftUI

class PathViewModel: ObservableObject {
    @Published var categorizedItems: [String: [ShoppingItem]]
    @Published var currentSectionIndex: Int = 0
    @Published var grabbedItems: Set<UUID> = []

    init(categorizedItems: [String: [ShoppingItem]]) {
        self.categorizedItems = categorizedItems
    }

    var sectionTitles: [String] {
        Array(categorizedItems.keys).sorted()
    }

    var currentSectionTitle: String {
        sectionTitles[currentSectionIndex]
    }

    func toggleItemGrabbed(_ item: ShoppingItem) {
        if grabbedItems.contains(item.id) {
            grabbedItems.remove(item.id)
        } else {
            grabbedItems.insert(item.id)
        }
    }

    func moveToNextSection() {
        if currentSectionIndex < sectionTitles.count - 1 {
            currentSectionIndex += 1
        }
    }

    func moveToPreviousSection() {
        if currentSectionIndex > 0 {
            currentSectionIndex -= 1
        }
    }

    func isItemGrabbed(_ item: ShoppingItem) -> Bool {
        grabbedItems.contains(item.id)
    }

    func isCurrentSection(_ sectionTitle: String) -> Bool {
        sectionTitle == currentSectionTitle
    }
}
