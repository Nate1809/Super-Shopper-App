// StoreSection.swift

import Foundation

struct StoreSection: Identifiable, Hashable, Equatable {
    let id: UUID
    let name: String
    let position: Position
    let category: String
    
    init(name: String, position: Position, category: String) {
        self.id = UUID()
        self.name = name
        self.position = position
        self.category = category
    }
    
    // Define the Position struct to conform to Equatable
    struct Position: Equatable, Hashable {
        let x: Int
        let y: Int
    }
    
    // Explicitly implement the Equatable protocol
    static func == (lhs: StoreSection, rhs: StoreSection) -> Bool {
        return lhs.id == rhs.id &&
               lhs.name == rhs.name &&
               lhs.position == rhs.position &&
               lhs.category == rhs.category
    }
}
