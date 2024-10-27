// CategorizedListView.swift

import SwiftUI

struct CategorizedListView: View {
    @ObservedObject var viewModel: CategorizedListViewModel

    init(shoppingItems: [ShoppingItem], selectedStore: String) {
        self.viewModel = CategorizedListViewModel(shoppingItems: shoppingItems, selectedStore: selectedStore)
    }

    var body: some View {
        VStack {
            List {
                ForEach(viewModel.categorizedItems.keys.sorted(), id: \.self) { category in
                    // Only display categories that have items
                    if let items = viewModel.categorizedItems[category], !items.isEmpty {
                        Section(header: Text(category)) {
                            ForEach(items) { item in
                                HStack {
                                    Text(item.name)
                                    Spacer()
                                    Text("Qty: \(item.quantity)")
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    viewModel.selectedItem = item
                                    viewModel.showCategoryPicker = true
                                }
                            }
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())

            NavigationLink(destination: PathView(
                categorizedItems: viewModel.categorizedItems,
                selectedStore: viewModel.selectedStore
            )) {
                Text("Show Optimal Path")
                    .foregroundColor(.white)
                    .padding()
                    .background(viewModel.categorizedItems.values.flatMap { $0 }.isEmpty ? Color.gray : Color.green)
                    .cornerRadius(8)
            }
            .disabled(viewModel.categorizedItems.values.flatMap { $0 }.isEmpty) // Disable if no items
            .padding()
        }
        .navigationTitle("Categorized Items")
        .onAppear {
            viewModel.categorizeItems()
            viewModel.categoriesList = Array(viewModel.getAllCategories())
        }
        .actionSheet(isPresented: $viewModel.showCategoryPicker) {
            ActionSheet(
                title: Text("Select Category"),
                message: Text("Assign a category to '\(viewModel.selectedItem?.name ?? "")'"),
                buttons: viewModel.categoryActionSheetButtons()
            )
        }
    }
}

#Preview {
    CategorizedListView(shoppingItems: [ShoppingItem(name: "Milk", quantity: 2)], selectedStore: "Target")
}
