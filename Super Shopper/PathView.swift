import SwiftUI

struct PathView: View {
    @ObservedObject var viewModel: PathViewModel
    @Namespace private var scrollNamespace // For smooth scrolling

    init(categorizedItems: [MainCategory], selectedStore: String) {
        self.viewModel = PathViewModel(categorizedItems: categorizedItems, selectedStore: selectedStore)
    }

    var body: some View {
        VStack {
            // Current Section Header
            Text("Optimal Path")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.blue)
                .padding()

            // List of Sections in Order
            List(viewModel.path) { section in
                HStack {
                    Text(section.name)
                        .font(.headline)
                    Spacer()
                    Text("(\(section.position.x), \(section.position.y))")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                }
                .padding(.vertical, 4)
            }
            .listStyle(PlainListStyle())

            Spacer()
        }
        .navigationTitle("Optimal Path")
        .padding(.bottom) // Extra padding to avoid bottom overlap
    }
}

#Preview {
    let sampleMainCategories = [
        MainCategory(name: "Groceries", subcategories: [
            SubCategory(name: "Flours", items: [ShoppingItem(name: "Flour", quantity: 2)]),
            SubCategory(name: "Dairy", items: [ShoppingItem(name: "Milk", quantity: 1)])
        ]),
        MainCategory(name: "Beauty", subcategories: [
            SubCategory(name: "Hair Care", items: [ShoppingItem(name: "Shampoo", quantity: 1)])
        ])
    ]
    
    // Assuming "Target" store layout includes these sections
    PathView(categorizedItems: sampleMainCategories, selectedStore: "Target")
}
