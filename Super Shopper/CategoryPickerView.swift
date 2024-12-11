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
    
    // State to track if scrolling is occurring
    @State private var isScrolling: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(Array(viewModel.mainCategoryNames.enumerated()), id: \.1) { index, mainCategory in
                        NavigationLink(destination: SubcategoryPickerView(viewModel: viewModel, mainCategory: mainCategory, isScrolling: $isScrolling)) {
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
                // Attach simultaneousGesture to detect scrolling without interfering with ScrollView's gestures
                .simultaneousGesture(
                    DragGesture()
                        .onChanged { _ in
                            isScrolling = true
                        }
                        .onEnded { _ in
                            // Reset isScrolling after a short delay to allow any lingering gestures to finish
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                isScrolling = false
                            }
                        }
                )
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

//struct CategoryPickerView_Previews: PreviewProvider {
//    static var previews: some View {
//        let sampleItems = [
//            CDShoppingItem(name: "Milk", quantity: 2),
//            CDShoppingItem(name: "Flour", quantity: 1),
//            CDShoppingItem(name: "Shampoo", quantity: 1)
//        ]
//        let viewModel = CategorizedListViewModel(shoppingItems: sampleItems, selectedStore: "Target")
//        CategoryPickerView(viewModel: viewModel)
//    }
//}
