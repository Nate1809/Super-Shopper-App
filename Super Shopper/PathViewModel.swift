import Foundation
import SwiftUI

class PathViewModel: ObservableObject {
    @Published var path: [StoreSection] = []
    
    let storeLayout: [StoreSection]
    let requiredSections: [StoreSection]
    
    // MARK: - Initializer
    init(categorizedItems: [MainCategory], selectedStore: String) {
        // Initialize storeLayout first
        self.storeLayout = StoreLayout.layout(for: selectedStore)
        
        // Initialize requiredSections using a static method to avoid using 'self'
        self.requiredSections = PathViewModel.extractSections(from: categorizedItems, with: storeLayout)
        
        // Now that all stored properties are initialized, you can safely call instance methods
        computeOptimalPath()
    }
    
    // MARK: - Extract Sections (Static Method)
    /// Extracts unique store sections that contain items
    /// - Parameters:
    ///   - categorizedItems: The main categories with their subcategories and items
    ///   - storeLayout: The layout of the store
    /// - Returns: An array of unique StoreSection objects that have items
    private static func extractSections(from categorizedItems: [MainCategory], with storeLayout: [StoreSection]) -> [StoreSection] {
        var sectionsSet = Set<StoreSection>()
        
        for mainCategory in categorizedItems {
            for subCategory in mainCategory.subcategories {
                if !subCategory.items.isEmpty {
                    // Find the corresponding StoreSection based on the main category name
                    if let section = storeLayout.first(where: { $0.category == mainCategory.name }) {
                        sectionsSet.insert(section)
                    }
                }
            }
        }
        
        // Convert the set to an array and sort it (optional)
        return Array(sectionsSet).sorted { $0.name < $1.name }
    }
    
    // MARK: - Compute Optimal Path
    /// Computes the optimal path using the A* algorithm
    private func computeOptimalPath() {
        // Starting point: Entrance
        guard let entrance = storeLayout.first(where: { $0.name.lowercased() == "entrance" }) else { return }
        
        var path: [StoreSection] = [entrance]
        var remainingSections = requiredSections.filter { $0.name.lowercased() != "entrance" }
        
        var current = entrance
        
        while !remainingSections.isEmpty {
            // Find the closest section to current
            if let closest = remainingSections.min(by: { manhattanDistance(from: current, to: $0) < manhattanDistance(from: current, to: $1) }) {
                // Find path from current to closest using A*
                if let subPath = aStar(from: current, to: closest) {
                    // Append to path, excluding current as it's already included
                    path += subPath.dropFirst()
                }
                // Update current
                current = closest
                // Remove from remaining
                if let index = remainingSections.firstIndex(of: closest) {
                    remainingSections.remove(at: index)
                }
            }
        }
        
        self.path = path
    }
    
    // MARK: - Manhattan Distance
    /// Calculates Manhattan distance between two sections
    private func manhattanDistance(from: StoreSection, to: StoreSection) -> Int {
        return abs(from.position.x - to.position.x) + abs(from.position.y - to.position.y)
    }
    
    // MARK: - A* Pathfinding Algorithm
    /// Implements the A* algorithm to find the shortest path between two sections
    /// - Parameters:
    ///   - start: Starting StoreSection
    ///   - goal: Goal StoreSection
    /// - Returns: An array of StoreSection objects representing the path, or nil if no path is found
    private func aStar(from start: StoreSection, to goal: StoreSection) -> [StoreSection]? {
        var openSet: Set<StoreSection> = [start]
        var cameFrom: [StoreSection: StoreSection] = [:]
        
        var gScore: [StoreSection: Int] = [:]
        gScore[start] = 0
        
        var fScore: [StoreSection: Int] = [:]
        fScore[start] = manhattanDistance(from: start, to: goal)
        
        while !openSet.isEmpty {
            // Get the section in openSet with the lowest fScore
            guard let current = openSet.min(by: { (a, b) -> Bool in
                (fScore[a] ?? Int.max) < (fScore[b] ?? Int.max)
            }) else { break }
            
            if current == goal {
                // Reconstruct and return the path
                return reconstructPath(cameFrom: cameFrom, current: current)
            }
            
            openSet.remove(current)
            
            // Get neighbors of the current section
            let neighbors = getNeighbors(of: current)
            
            for neighbor in neighbors {
                let tentativeGScore = (gScore[current] ?? Int.max) + 1 // Assuming uniform cost
                
                if tentativeGScore < (gScore[neighbor] ?? Int.max) {
                    cameFrom[neighbor] = current
                    gScore[neighbor] = tentativeGScore
                    fScore[neighbor] = tentativeGScore + manhattanDistance(from: neighbor, to: goal)
                    
                    if !openSet.contains(neighbor) {
                        openSet.insert(neighbor)
                    }
                }
            }
        }
        
        return nil // No path found
    }
    
    // MARK: - Reconstruct Path
    /// Reconstructs the path from the cameFrom map
    /// - Parameters:
    ///   - cameFrom: Dictionary mapping each section to its predecessor
    ///   - current: The current section (goal)
    /// - Returns: An array of StoreSection objects representing the path
    private func reconstructPath(cameFrom: [StoreSection: StoreSection], current: StoreSection) -> [StoreSection] {
        var totalPath = [current]
        var currentNode = current
        
        while let previous = cameFrom[currentNode] {
            totalPath.insert(previous, at: 0)
            currentNode = previous
        }
        
        return totalPath
    }
    
    // MARK: - Get Neighbors
    /// Retrieves adjacent sections in the store layout
    /// - Parameter section: The current StoreSection
    /// - Returns: An array of neighboring StoreSection objects
    private func getNeighbors(of section: StoreSection) -> [StoreSection] {
        return storeLayout.filter { neighbor in
            (abs(neighbor.position.x - section.position.x) == 1 && neighbor.position.y == section.position.y) ||
            (abs(neighbor.position.y - section.position.y) == 1 && neighbor.position.x == section.position.x)
        }
    }
}
