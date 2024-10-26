//
//  StoreSection.swift
//  Super Shopper
//
//  Created by Nathan Guzman on 10/25/24.
//

// StoreSection.swift

import Foundation

struct StoreSection: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let position: (x: Int, y: Int)
    let category: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: StoreSection, rhs: StoreSection) -> Bool {
        return lhs.id == rhs.id
    }
}
