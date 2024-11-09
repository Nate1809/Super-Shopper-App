// CategoryPickerView.swift

import SwiftUI

struct CategoryPickerView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: CategorizedListViewModel

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.mainCategoryNames, id: \.self) { mainCategory in
                    NavigationLink(destination: SubcategoryPickerView(viewModel: viewModel, mainCategory: mainCategory)) {
                        Text(mainCategory)
                    }
                }
            }
            .navigationTitle("Select Category")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                        viewModel.selectedItem = nil // Reset selected item
                    }
                }
            }
        }
    }
}

struct SubcategoryPickerView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: CategorizedListViewModel
    let mainCategory: String

    var body: some View {
        List {
            ForEach(viewModel.subcategories(for: mainCategory).sorted(), id: \.self) { subCategory in
                Button(action: {
                    viewModel.reassignItem(toMain: mainCategory, toSub: subCategory)
                    presentationMode.wrappedValue.dismiss() // Dismiss SubcategoryPickerView
                    presentationMode.wrappedValue.dismiss() // Dismiss CategoryPickerView
                }) {
                    Text(subCategory)
                }
            }
        }
        .navigationTitle(mainCategory)
    }
}

#Preview {
    let sampleItems = [
        ShoppingItem(name: "Milk", quantity: 2),
        ShoppingItem(name: "Flour", quantity: 1),
        ShoppingItem(name: "Shampoo", quantity: 1)
    ]
    let viewModel = CategorizedListViewModel(shoppingItems: sampleItems, selectedStore: "Target")
    CategoryPickerView(viewModel: viewModel)
}
