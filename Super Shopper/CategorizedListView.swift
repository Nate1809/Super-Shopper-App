// CategorizedListView.swift

import SwiftUI

struct CategorizedListView: View {
    @ObservedObject var viewModel: CategorizedListViewModel

    init(shoppingItems: [ShoppingItem], selectedStore: String) {
        self.viewModel = CategorizedListViewModel(shoppingItems: shoppingItems, selectedStore: selectedStore)
    }

    var body: some View {
        VStack(alignment: .leading) {
            // Instructional Text
            Text("Tap on an item to change its category or adjust the quantity.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.horizontal)
                .padding(.top, 4)

            List {
                ForEach(viewModel.categorizedItems) { mainCategory in
                    DisclosureGroup(mainCategory.name) {
                        ForEach(mainCategory.subcategories) { subCategory in
                            if !subCategory.items.isEmpty {
                                VStack(alignment: .leading) {
                                    Text(subCategory.name)
                                        .font(.headline)
                                        .padding(.vertical, 2)
                                    ForEach(subCategory.items) { item in
                                        ShoppingItemRow(item: item, isNameEditable: false)
                                            .onTapGesture {
                                                viewModel.selectedItem = item
                                                viewModel.showCategoryPicker = true
                                            }
                                            .padding(.leading, 16)
                                    }
                                    .onDelete { indices in
                                        let itemsToDelete = indices.map { subCategory.items[$0] }
                                        for item in itemsToDelete {
                                            viewModel.deleteItem(item)
                                        }
                                    }
                                }
                            }
                        }
                        .onDelete { indices in
                            // Handle deletion if needed for subcategories
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())

            NavigationLink(destination: PathView(
                categorizedItems: viewModel.categorizedItems,
                selectedStore: viewModel.selectedStore
            )) {
                Text(showOptimalPathButtonLabel)
                    .font(.headline)
                    .foregroundColor(viewModel.shoppingItems.isEmpty ? Color.white.opacity(0.6) : Color.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.shoppingItems.isEmpty ? Color.gray : Color.green)
                    .cornerRadius(10)
            }
            .disabled(viewModel.shoppingItems.isEmpty)
            .padding([.horizontal, .bottom])
            .buttonStyle(PressableButtonStyle())
        }
        .navigationTitle("Categorized Items")
        .onAppear {
            viewModel.categorizeItems()
            viewModel.mainCategoriesList = viewModel.categorizedItems
        }
        .actionSheet(isPresented: $viewModel.showCategoryPicker) {
            ActionSheet(
                title: Text("Select Category"),
                message: Text("Assign a category to '\(viewModel.selectedItem?.name ?? "")'"),
                buttons: viewModel.categoryActionSheetButtons()
            )
        }
    }

    var showOptimalPathButtonLabel: String {
        viewModel.shoppingItems.isEmpty ? "No Items to Show Path" : "Show Optimal Path"
    }

    struct PressableButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
                .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
        }
    }
}

#Preview {
    let sampleItems = [
        ShoppingItem(name: "Milk", quantity: 2),
        ShoppingItem(name: "Flour", quantity: 1),
        ShoppingItem(name: "Shampoo", quantity: 1)
    ]
    CategorizedListView(shoppingItems: sampleItems, selectedStore: "Target")
}
