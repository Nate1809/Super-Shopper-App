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
            Spacer()
            TextField("Qty", value: $item.quantity, formatter: NumberFormatter.integer)
                .keyboardType(.numberPad)
                .frame(width: 50)
        }
        .onAppear {
            if item.name.isEmpty {
                isFocused = true
            }
        }
    }
}
