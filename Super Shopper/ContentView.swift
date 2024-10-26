// ContentView.swift

import SwiftUI

struct ContentView: View {
    @State private var shoppingItems: [ShoppingItem] = []
    @State private var selectedStore: String = "Target"
    @State private var newItemName: String = ""
    @FocusState private var isItemNameFocused: Bool

    var body: some View {
        NavigationView {
            VStack {
                // Store Picker
                Text("Select Your Store:")
                    .font(.headline)
                    .padding(.top)
                    .padding(.bottom, 5)

                Picker("Store", selection: $selectedStore) {
                    Text("Target").tag("Target")
                    Text("Whole Foods").tag("Whole Foods")
                    Text("HEB").tag("HEB")
                    Text("Other").tag("Other")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .padding(.bottom, 20)

                // List of Shopping Items
                List {
                    ForEach(shoppingItems) { item in
                        ShoppingItemRow(item: item)
                    }
                    .onDelete(perform: deleteItems)
                }
                .listStyle(PlainListStyle())

                // Input Fields at the Bottom
                VStack {
                    Divider()
                    HStack {
                        TextField("Item Name", text: $newItemName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .focused($isItemNameFocused)
                            .onSubmit {
                                addItem()
                            }
                        Button(action: {
                            addItem()
                        }) {
                            Text("Add")
                                .foregroundColor(.white)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(Color.green)
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                }
                .background(Color(UIColor.systemBackground))
            }
            .navigationTitle("Super Shopper")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: CategorizedListView(
                        shoppingItems: shoppingItems,
                        selectedStore: selectedStore
                    )) {
                        Text("Next")
                            .foregroundColor(.blue)
                    }
                }
            }
            .onAppear {
                isItemNameFocused = true
            }
            .padding(.bottom, 8) // Add padding to prevent squishing
        }
    }

    func addItem() {
        let trimmedName = newItemName.trimmingCharacters(in: .whitespaces)
        guard !trimmedName.isEmpty else { return }

        let newItem = ShoppingItem(name: trimmedName, quantity: 1)
        shoppingItems.append(newItem)
        newItemName = ""
        isItemNameFocused = true
    }

    func deleteItems(at offsets: IndexSet) {
        shoppingItems.remove(atOffsets: offsets)
    }
}

#Preview {
    ContentView()
}
