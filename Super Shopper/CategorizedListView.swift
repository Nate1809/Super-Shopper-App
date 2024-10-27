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
                                ShoppingItemRow(item: item, isNameEditable: false) // Disable name editing
                                    .onTapGesture {
                                        viewModel.selectedItem = item
                                        viewModel.showCategoryPicker = true
                                    }
                            }
                            .onDelete { indices in
                                let itemsToDelete = indices.map { items[$0] }
                                for item in itemsToDelete {
                                    viewModel.deleteItem(item)
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
                Text(showOptimalPathButtonLabel)
                    .font(.headline)
                    .foregroundColor(viewModel.categorizedItems.values.flatMap { $0 }.isEmpty ? Color.white.opacity(0.6) : Color.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.categorizedItems.values.flatMap { $0 }.isEmpty ? Color.gray : Color.green)
                    .cornerRadius(10)
            }
            .disabled(viewModel.categorizedItems.values.flatMap { $0 }.isEmpty) // Disable if no items
            .padding([.horizontal, .bottom])
            .buttonStyle(PressableButtonStyle()) // Apply custom button style
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
    
    /// Computed property to determine the "Show Optimal Path" button label based on its state
    var showOptimalPathButtonLabel: String {
        viewModel.categorizedItems.values.flatMap { $0 }.isEmpty ? "No Items to Show Path" : "Show Optimal Path"
    }
    
    /// Custom ButtonStyle for press animations
    struct PressableButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
                .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
        }
    }
}

#Preview {
    CategorizedListView(shoppingItems: [ShoppingItem(name: "Milk", quantity: 2)], selectedStore: "Target")
}
