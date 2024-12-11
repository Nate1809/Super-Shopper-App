// ShoppingList.swift

import Foundation
import Combine

class ShoppingList: ObservableObject {
    @Published var items: [CDShoppingItem] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Observe changes to each CDShoppingItem in the items array
        $items
            .sink { [weak self] items in
                for item in items {
                    item.objectWillChange
                        .sink { [weak self] _ in
                            self?.objectWillChange.send()
                        }
                        .store(in: &self!.cancellables)
                }
            }
            .store(in: &cancellables)
    }
}
