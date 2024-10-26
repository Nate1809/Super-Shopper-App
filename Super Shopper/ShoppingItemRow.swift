//
//  ShoppingItemRow.swift
//  Super Shopper
//
//  Created by Nathan Guzman on 10/25/24.
//

// ShoppingItemRow.swift

import SwiftUI

struct ShoppingItemRow: View {
    @ObservedObject var item: ShoppingItem
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack {
            TextField("Item Name", text: $item.name)
                .focused($isFocused)
                .onSubmit {
                    validateName()
                }
            Spacer()
            TextField("Qty", value: $item.quantity, formatter: NumberFormatter.integer)
                .keyboardType(.numberPad)
                .frame(width: 50)
                .onSubmit {
                    validateQuantity()
                }
        }
        .onAppear {
            if item.name.isEmpty {
                isFocused = true
            }
        }
    }
    
    // Input validation methods
    private func validateName() {
        item.name = item.name.trimmingCharacters(in: .whitespaces)
        if item.name.isEmpty {
            item.name = "Unnamed Item"
        }
    }
    
    private func validateQuantity() {
        if item.quantity <= 0 {
            item.quantity = 1
        }
    }
}
