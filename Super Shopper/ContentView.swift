//
//  ContentView.swift
//  Super Shopper
//
//  Created by Nathan Guzman on 10/25/24.
//


// ContentView.swift

import SwiftUI

struct ContentView: View {
    @State private var shoppingItems: [ShoppingItem] = []
    @State private var selectedStore: String = "Target"
    @FocusState private var focusedField: UUID?

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
                    ForEach($shoppingItems) { $item in
                        HStack {
                            TextField("Item Name", text: $item.name)
                                .focused($focusedField, equals: item.id)
                            Spacer()
                            TextField("Qty", value: $item.quantity, formatter: NumberFormatter.integer)
                                .keyboardType(.numberPad)
                                .frame(width: 50)
                        }
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
                    shoppingItems: shoppingItems,
                    selectedStore: selectedStore
                )) {
                    Text("Categorize Items")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding(.top)

                Spacer()
            }
            .padding()
            .navigationTitle("Super Shopper")
        }
    }

    func addItem() {
        let newItem = ShoppingItem(name: "", quantity: 1)
        shoppingItems.append(newItem)
        focusedField = newItem.id
    }

    func deleteItems(at offsets: IndexSet) {
        shoppingItems.remove(atOffsets: offsets)
    }
}


#Preview {
    ContentView()
}
