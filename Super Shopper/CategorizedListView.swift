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
                    Section(header: Text(category)) {
                        ForEach(viewModel.categorizedItems[category]!) { item in
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
            .listStyle(PlainListStyle())

            NavigationLink(destination: PathView(
                categorizedItems: viewModel.categorizedItems,
                selectedStore: viewModel.selectedStore
            )) {
                Text("Show Optimal Path")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(8)
            }
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
        // Optional: Handle Confirmation Alert
        .alert(isPresented: $viewModel.showReassignConfirmation) {
            Alert(
                title: Text("Confirm Reassignment"),
                message: Text("Move '\(viewModel.selectedItem?.name ?? "")' to '\(viewModel.categoryToReassign ?? "")'?"),
                primaryButton: .default(Text("Yes"), action: {
                    if let category = viewModel.categoryToReassign {
                        viewModel.reassignItem(to: category)
                    }
                }),
                secondaryButton: .cancel()
            )
        }
    }
}
