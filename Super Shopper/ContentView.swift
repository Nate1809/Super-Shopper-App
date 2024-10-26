//
//  ContentView.swift
//  Super Shopper
//
//  Created by Nathan Guzman on 10/25/24.
//

// ContentView.swift

import SwiftUI

struct ContentView: View {
    @ObservedObject var shoppingList = ShoppingList()
    @State private var selectedStore: String = "Target"
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Select Your Store:")
                    .font(.headline)
                    .padding(.bottom, 5)
                
                Picker("Store", selection: $selectedStore) {
                    Text("Target").tag("Target")
                    Text("Whole Foods").tag("Whole Foods")
                    Text("HEB").tag("HEB")
                    Text("Other").tag("Other")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.bottom, 20)
                
                Text("Your Shopping List:")
                    .font(.headline)
                    .padding(.bottom, 5)
                
                List {
                    ForEach(shoppingList.items) { item in
                        ShoppingItemRow(item: item)
                    }
                    .onDelete(perform: deleteItems)
                    
                    Button(action: addItem) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                            Text("Add Item")
                        }
                    }
                }
                
                NavigationLink(destination: CategorizedListView(
                    shoppingItems: shoppingList.items,
                    selectedStore: selectedStore
                )) {
                    Text("Categorize Items")
                        .foregroundColor(.white)
                        .padding()
                        .background(canProceed ? Color.blue : Color.gray)
                        .cornerRadius(8)
                }
                .padding(.top)
                .disabled(!canProceed)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Super Shopper")
        }
    }
    
    private func addItem() {
        let newItem = ShoppingItem(name: "", quantity: 1)
        shoppingList.items.append(newItem)
    }
    
    private func deleteItems(at offsets: IndexSet) {
        shoppingList.items.remove(atOffsets: offsets)
    }
    
    // Computed property to check if we can proceed
    private var canProceed: Bool {
        !shoppingList.items.isEmpty && shoppingList.items.allSatisfy { !$0.name.trimmingCharacters(in: .whitespaces).isEmpty }
    }
}

#Preview {
    ContentView()
}
