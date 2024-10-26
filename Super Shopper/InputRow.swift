// InputRow.swift

import SwiftUI

struct InputRow: View {
    @State private var name: String = ""
    @State private var quantity: Int = 1
    @FocusState private var isFocused: Bool

    var onSubmit: (String, Int) -> Void

    var body: some View {
        HStack {
            TextField("Item Name", text: $name, onCommit: {
                submitItem()
            })
            .focused($isFocused)
            .submitLabel(.done)
            Spacer()
            TextField("Qty", value: $quantity, formatter: NumberFormatter.integer)
                .keyboardType(.numberPad)
                .frame(width: 50)
                .focused($isFocused, equals: false)
        }
        .padding(.vertical, 5)
        .onAppear {
            isFocused = true
        }
    }

    private func submitItem() {
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        if !trimmedName.isEmpty {
            onSubmit(trimmedName, quantity)
            name = ""
            quantity = 1
            isFocused = true // Keep focus on the input row
        }
    }
}
