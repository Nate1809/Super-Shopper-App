// ShoppingItemRow.swift

import SwiftUI

struct ShoppingItemRow: View {
    @ObservedObject var item: ShoppingItem
    @FocusState private var isQuantityFocused: Bool
    var isNameEditable: Bool = true

    var body: some View {
        HStack {
            if isNameEditable {
                TextField("Item Name", text: $item.name)
                    .focused($isQuantityFocused)
            } else {
                Text(item.name) // Display as plain text if editing is disabled
                    .font(.body)
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
            if isNameEditable && item.name.isEmpty {
                isQuantityFocused = true
            }
        }
    }

    func validateQuantity() {
        if item.quantity < 1 {
            item.quantity = 1
        }
    }
}
