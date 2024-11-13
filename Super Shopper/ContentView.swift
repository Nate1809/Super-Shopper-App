// ContentView.swift
// Super Shopper

import SwiftUI
import CoreData

struct ContentView: View {
    // Access the managed object context from the environment
    @Environment(\.managedObjectContext) private var viewContext

    // FetchRequest to retrieve ShoppingLists sorted by dateCreated
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CDShoppingList.dateCreated, ascending: true)],
        animation: .default)
    private var shoppingLists: FetchedResults<CDShoppingList>

    // State variables for user interactions
    @State private var selectedStore: String = "Generic Store" // Default store
    @State private var newItemName: String = ""
    @FocusState private var isItemNameFocused: Bool

    // State variables for modal presentations
    @State private var showStoreSelection: Bool = false
    @State private var showTutorial: Bool = false

    var body: some View {
        // Define currentList within the body to make it accessible
        let currentList = shoppingLists.first

        NavigationView {
            VStack {
                // List of Shopping Items
                List {
                    ForEach(currentList?.itemsArray ?? []) { item in
                        ShoppingItemRow(item: item)
                    }
                    .onDelete(perform: deleteItems)
                }
                .listStyle(PlainListStyle())

                // "Next" Button Positioned Above the Item Input Field
                NavigationLink(destination: CategorizedListView(
                    shoppingItems: currentList?.itemsArray ?? [],
                    selectedStore: selectedStore,
                    context: viewContext // Passing the Core Data context
                )) {
                    Text(nextButtonLabel)
                        .font(.headline)
                        .foregroundColor((currentList?.itemsArray.isEmpty ?? true) ? Color.white.opacity(0.6) : Color.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background((currentList?.itemsArray.isEmpty ?? true) ? Color.gray : Color.blue)
                        .cornerRadius(10)
                }
                .disabled(currentList?.itemsArray.isEmpty ?? true)
                .padding([.horizontal, .top])
                .buttonStyle(PressableButtonStyle()) // Apply custom button style

                // Input Fields at the Bottom
                VStack {
                    Divider()
                    HStack {
                        TextField("Item Name", text: $newItemName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .focused($isItemNameFocused)
                            .submitLabel(.done)

                        Button(action: {
                            triggerHaptic()
                            addItem()
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Add")
                            }
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(Color.green)
                            .cornerRadius(8)
                        }
                        .disabled(newItemName.trimmingCharacters(in: .whitespaces).isEmpty) // Disable button if input is empty
                        .buttonStyle(PressableButtonStyle()) // Apply custom button style
                    }
                    .padding()
                }
                .background(Color(UIColor.systemBackground))
            }
            .navigationTitle("Super Shopper")
            .toolbar {
                // Shopping Cart Button for Store Selection
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        triggerHaptic()
                        showStoreSelection = true
                    }) {
                        Image(systemName: "cart.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                            .accessibilityLabel("Select Store")
                    }
                    .buttonStyle(PressableButtonStyle()) // Apply custom button style
                }

                // "?" Button for Tutorial
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        triggerHaptic()
                        showTutorial = true
                    }) {
                        Image(systemName: "questionmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                            .accessibilityLabel("Show Tutorial")
                    }
                    .buttonStyle(PressableButtonStyle()) // Apply custom button style
                }
            }
            .onAppear {
                isItemNameFocused = true
                // If no ShoppingList exists, create one
                if shoppingLists.isEmpty {
                    let newList = CDShoppingList(context: viewContext)
                    newList.id = UUID()
                    newList.name = "My Shopping List"
                    newList.dateCreated = Date()
                    saveContext()
                }
            }
            .padding(.bottom, 8) // Add padding to prevent squishing
            // Store Selection Modal Sheet
            .sheet(isPresented: $showStoreSelection) {
                StoreSelectionView(selectedStore: $selectedStore)
            }
            // Tutorial Modal Sheet
            .sheet(isPresented: $showTutorial) {
                TutorialView()
            }
        }
    }

    /// Computed property to determine the "Next" button label based on its state
    var nextButtonLabel: String {
        (shoppingLists.first?.itemsArray.isEmpty ?? true) ? "Add Items to Continue" : "Proceed to Categories"
    }

    /// Adds a new item to the shopping list
    func addItem() {
        let trimmedName = newItemName.trimmingCharacters(in: .whitespaces)
        guard !trimmedName.isEmpty else { return }

        let currentList = shoppingLists.first
        currentList?.addItem(name: trimmedName, quantity: 1, context: viewContext)

        saveContext()
        newItemName = ""
        isItemNameFocused = true
    }

    /// Deletes items from the shopping list
    func deleteItems(at offsets: IndexSet) {
        guard let currentList = shoppingLists.first else { return }
        let items = currentList.itemsArray
        offsets.map { items[$0] }.forEach { item in
            currentList.removeItem(item, context: viewContext)
        }
        saveContext()
    }

    /// Saves the current context
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            // Handle the Core Data error appropriately in production
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    /// Triggers haptic feedback using UIImpactFeedbackGenerator
    func triggerHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
    }

    /// Custom ButtonStyle for press animations
    struct PressableButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
                .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
        }
    }
}

//// Extension to access items as a sorted array
//extension CDShoppingList {
//    var itemsArray: [CDShoppingItem] {
//        let set = items as? Set<CDShoppingItem> ?? []
//        return set.sorted { ($0.name ?? "") < ($1.name ?? "") }
//    }
//
//    /// Adds a new item to the shopping list
//    /// - Parameters:
//    ///   - name: Name of the item
//    ///   - quantity: Quantity of the item
//    ///   - context: Managed object context
//    func addItem(name: String, quantity: Int16, context: NSManagedObjectContext) {
//        let newItem = CDShoppingItem(context: context)
//        newItem.id = UUID()
//        newItem.name = name
//        newItem.quantity = quantity
//        newItem.isCompleted = false
//        newItem.list = self
//    }
//
//    /// Deletes an item from the shopping list
//    /// - Parameters:
//    ///   - item: The item to delete
//    ///   - context: Managed object context
//    func removeItem(_ item: CDShoppingItem, context: NSManagedObjectContext) {
//        self.removeFromItems(item)
//        context.delete(item)
//    }
//}
