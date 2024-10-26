// ShoppingItemRow.swift

import SwiftUI

struct ShoppingItemRow: View {
    @ObservedObject var item: ShoppingItem
    @FocusState private var isNameFocused: Bool
    @FocusState private var isQuantityFocused: Bool

    var body: some View {
        HStack {
            TextField("Item Name", text: $item.name)
                .focused($isNameFocused)
                .onSubmit {
                    validateItemName()
                }
            Spacer()
            TextField("Qty", value: $item.quantity, formatter: NumberFormatter.integer)
                .keyboardType(.numberPad)
                .frame(width: 50)
                .multilineTextAlignment(.center)
                .focused($isQuantityFocused)
                .onSubmit {
                    validateQuantity()
                }
        }
        .padding(.vertical, 4)
        .onAppear {
            // Optionally, focus the name field when the item is empty
            if item.name.isEmpty {
                isNameFocused = true
            }
        }
    }

    func validateItemName() {
        item.name = item.name.trimmingCharacters(in: .whitespaces)
        if item.name.isEmpty {
            item.name = "Unnamed Item"
        }
    }

    func validateQuantity() {
        if item.quantity < 1 {
            item.quantity = 1
        }
    }
}
