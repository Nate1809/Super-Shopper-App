// ContentView.swift

import SwiftUI
import UIKit // Import UIKit for haptic feedback

struct ContentView: View {
    @State private var shoppingItems: [ShoppingItem] = []
    @State private var selectedStore: String = "Generic Store" // Default to Generic Store
    @State private var newItemName: String = ""
    @FocusState private var isItemNameFocused: Bool
    
    // State variables for store selection sheet and tutorial
    @State private var showStoreSelection: Bool = false
    @State private var showTutorial: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                // List of Shopping Items
                List {
                    ForEach(shoppingItems) { item in
                        ShoppingItemRow(item: item)
                    }
                    .onDelete(perform: deleteItems)
                }
                .listStyle(PlainListStyle())
                
                // "Next" Button Positioned Above the Item Input Field
                NavigationLink(destination: CategorizedListView(
                    shoppingItems: shoppingItems,
                    selectedStore: selectedStore
                )) {
                    Text(nextButtonLabel)
                        .font(.headline)
                        .foregroundColor(shoppingItems.isEmpty ? Color.white.opacity(0.6) : Color.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(shoppingItems.isEmpty ? Color.gray : Color.blue)
                        .cornerRadius(10)
                }
                .disabled(shoppingItems.isEmpty) // Disable the button if the list is empty
                .padding([.horizontal, .top])
                .buttonStyle(PressableButtonStyle()) // Apply custom button style
                
                // Input Fields at the Bottom
                VStack {
                    Divider()
                    HStack {
                        TextField("Item Name", text: $newItemName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .focused($isItemNameFocused)
                            .submitLabel(.done) // Optional: Change the return key label
                        
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
        shoppingItems.isEmpty ? "Add Items to Continue" : "Proceed to Categories"
    }

    /// Adds a new item to the shopping list
    func addItem() {
        let trimmedName = newItemName.trimmingCharacters(in: .whitespaces)
        guard !trimmedName.isEmpty else { return }

        let newItem = ShoppingItem(name: trimmedName, quantity: 1)
        shoppingItems.append(newItem)
        newItemName = ""
        isItemNameFocused = true
    }

    /// Deletes items from the shopping list
    func deleteItems(at offsets: IndexSet) {
        shoppingItems.remove(atOffsets: offsets)
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

#Preview {
    ContentView()
}
