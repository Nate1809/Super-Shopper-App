// ShoppingItemRow.swift

import SwiftUI

struct ShoppingItemRow: View {
    @ObservedObject var item: CDShoppingItem // Updated to CDShoppingItem
    @FocusState private var isQuantityFocused: Bool
    var isNameEditable: Bool = true

    var body: some View {
        HStack {
            if isNameEditable {
                TextField("Item Name", text: Binding(
                    get: { item.wrappedName },
                    set: { newValue in
                        item.name = newValue
                        saveContext()
                    }
                ))
                .focused($isQuantityFocused)
            } else {
                Text(item.wrappedName) // Display as plain text if editing is disabled
                    .font(.body)
            }
            Spacer()
            TextField("Qty", value: Binding(
                get: { Int(item.quantity) },
                set: { newValue in
                    item.updateQuantity(to: Int16(newValue))
                    saveContext()
                }
            ), formatter: NumberFormatter.integer)
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
            if isNameEditable && item.wrappedName.isEmpty {
                isQuantityFocused = true
            }
        }
    }

    func validateQuantity() {
        if item.quantity < 1 {
            item.updateQuantity(to: 1)
            saveContext()
        }
    }

    func saveContext() {
        do {
            try item.managedObjectContext?.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}

struct ShoppingItemRow_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let sampleItem = CDShoppingItem(context: context)
        sampleItem.id = UUID()
        sampleItem.name = "Milk"
        sampleItem.quantity = 2
        sampleItem.isCompleted = false

        return ShoppingItemRow(item: sampleItem)
            .environment(\.managedObjectContext, context)
    }
}
