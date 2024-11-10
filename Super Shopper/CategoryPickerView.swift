// CategoryPickerView.swift

import SwiftUI

struct CategoryPickerView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: CategorizedListViewModel
    
    // Define grid columns
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    // Define an array of colors
    let categoryColors: [Color] = [
        .red, .blue, .green, .orange, .purple, .pink, .yellow, .teal, .indigo, .brown
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(Array(viewModel.mainCategoryNames.enumerated()), id: \.1) { index, mainCategory in
                        NavigationLink(destination: SubcategoryPickerView(viewModel: viewModel, mainCategory: mainCategory)) {
                            VStack {
                                Text(viewModel.emojiForMainCategory(mainCategory))
                                    .font(.largeTitle)
                                Text(mainCategory)
                                    .font(.headline)
                                    .multilineTextAlignment(.center)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 100)
                            .background(categoryColors[index % categoryColors.count])
                            .cornerRadius(10)
                        }
                    }
                }
                .padding()
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
    
    // Define grid columns
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    // Define an array of colors
    let categoryColors: [Color] = [
        .red, .blue, .green, .orange, .purple, .pink, .yellow, .teal, .indigo, .brown
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(Array(viewModel.subcategories(for: mainCategory).enumerated()), id: \.1) { index, subCategory in
                    Button(action: {
                        viewModel.reassignItem(toMain: mainCategory, toSub: subCategory)
                        presentationMode.wrappedValue.dismiss() // Dismiss SubcategoryPickerView
                        presentationMode.wrappedValue.dismiss() // Dismiss CategoryPickerView
                    }) {
                        VStack {
                            Text(viewModel.emojiForSubCategory(subCategory))
                                .font(.largeTitle)
                            Text(subCategory)
                                .font(.headline)
                                .multilineTextAlignment(.center)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 100)
                        .background(categoryColors[index % categoryColors.count])
                        .cornerRadius(10)
                    }
                }
            }
            .padding()
        }
        .navigationTitle(mainCategory)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Back") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
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
