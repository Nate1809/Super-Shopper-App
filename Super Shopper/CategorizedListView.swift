// CategorizedListView.swift

import SwiftUI

struct CategorizedListView: View {
    @ObservedObject var viewModel: CategorizedListViewModel
    @StateObject var pathViewModel: PathViewModel
    
    init(shoppingItems: [ShoppingItem], selectedStore: String) {
        // Initialize viewModel first
        let vm = CategorizedListViewModel(shoppingItems: shoppingItems, selectedStore: selectedStore)
        vm.categorizeItems() // Ensure categorizedItems is populated
        self._viewModel = ObservedObject(wrappedValue: vm)
        
        // Now initialize pathViewModel using the populated categorizedItems
        self._pathViewModel = StateObject(wrappedValue: PathViewModel(
            categorizedItems: vm.categorizedItems,
            selectedStore: selectedStore
        ))
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
                ForEach(viewModel.nonEmptyCategorizedItems) { mainCategory in
                    DisclosureGroup("\(viewModel.emojiForMainCategory(mainCategory.name)) \(mainCategory.name)") {
                        ForEach(mainCategory.subcategories) { subCategory in
                            if !subCategory.items.isEmpty {
                                VStack(alignment: .leading) {
                                    Text("\(viewModel.emojiForSubCategory(subCategory.name)) \(subCategory.name)")
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
                    }
                }
            }
            .listStyle(PlainListStyle())
            
            NavigationLink(destination: PathView(
                viewModel: pathViewModel // Pass the existing pathViewModel
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
            // Update mainCategoriesList if needed
            viewModel.mainCategoriesList = viewModel.categorizedItems
        }
        .onChange(of: viewModel.categorizedItems) { newCategorizedItems in
            // Update the path in pathViewModel when categorizedItems change
            pathViewModel.updatePath(categorizedItems: newCategorizedItems)
        }
        .sheet(isPresented: $viewModel.showCategoryPicker) {
            CategoryPickerView(viewModel: viewModel)
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
