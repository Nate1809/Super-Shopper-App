//
//  ShoppingList.swift
//  Super Shopper
//
//  Created by Nathan Guzman on 10/26/24.
//

// ShoppingList.swift

import Foundation
import Combine

class ShoppingList: ObservableObject {
    @Published var items: [ShoppingItem] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Observe changes to each ShoppingItem in the items array
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
