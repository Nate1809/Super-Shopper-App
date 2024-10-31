// PathView.swift

import SwiftUI

struct PathView: View {
    @ObservedObject var viewModel: PathViewModel
    @State private var scrollToID: UUID? = nil
    
    init(categorizedItems: [MainCategory], selectedStore: String) {
        self.viewModel = PathViewModel(categorizedItems: categorizedItems, selectedStore: selectedStore)
    }
    
    var body: some View {
        VStack {
            // Instructional Text
            Text("Tap the circle to check off items.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.horizontal)
                .padding(.top, 4)
            
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 20) {
                        ForEach(Array(viewModel.path.enumerated()), id: \.element.id) { index, mainCategory in
                            VStack(alignment: .leading, spacing: 10) {
                                // Main Section Header without scaling and shadow
                                HStack {
                                    Text(mainCategory.name)
                                        .font(.title2)
                                        .fontWeight(.regular)
                                        .foregroundColor(viewModel.currentMainSectionIndex == index ? .blue : .primary)
                                        .animation(.easeInOut(duration: 0.3), value: viewModel.currentMainSectionIndex)
                                    
                                    Spacer()
                                    
                                    if viewModel.currentMainSectionIndex == index {
                                        Text("Current Section")
                                            .font(.subheadline)
                                            .foregroundColor(.blue)
                                    }
                                }
                                .id(mainCategory.id) // For scrolling
                
                                // Sub-Sections
                                ForEach(mainCategory.subcategories) { subCategory in
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(subCategory.name)
                                            .font(.headline)
                                            .foregroundColor(.secondary)
                
                                        // Items List
                                        VStack(alignment: .leading, spacing: 5) {
                                            ForEach(subCategory.items) { item in
                                                HStack {
                                                    Text(item.name)
                                                        .strikethrough(viewModel.isItemGrabbed(item), color: .gray)
                                                        .foregroundColor(viewModel.isItemGrabbed(item) ? .gray : .primary)
                                                    Spacer()
                                                    Text("Qty: \(item.quantity)")
                                                        .foregroundColor(viewModel.isItemGrabbed(item) ? .gray : .secondary)
                                                    Button(action: {
                                                        withAnimation {
                                                            viewModel.toggleItemGrabbed(item)
                                                            triggerHaptic()
                                                        }
                                                    }) {
                                                        Image(systemName: viewModel.isItemGrabbed(item) ? "checkmark.circle.fill" : "circle")
                                                            .foregroundColor(viewModel.isItemGrabbed(item) ? .green : .gray)
                                                    }
                                                    .buttonStyle(BorderlessButtonStyle())
                                                    .accessibilityLabel(viewModel.isItemGrabbed(item) ? "Uncheck \(item.name)" : "Check \(item.name)")
                                                }
                                                .padding(.vertical, 4)
                                                .padding(.horizontal, 8)
                                                .background(viewModel.isItemGrabbed(item) ? Color.gray.opacity(0.1) : Color.clear)
                                                .cornerRadius(8)
                                            }
                                        }
                                        .padding(.horizontal)
                                        .padding(.vertical, 5)
                                        .background(Color.gray.opacity(0.05))
                                        .cornerRadius(10)
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .onAppear {
                                // Automatically scroll to current section
                                if viewModel.currentMainSectionIndex == index {
                                    withAnimation {
                                        proxy.scrollTo(mainCategory.id, anchor: .top)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.top)
                }
                .onChange(of: viewModel.currentMainSectionIndex) { newIndex in
                    if newIndex < viewModel.path.count {
                        let mainCategory = viewModel.path[newIndex]
                        withAnimation {
                            proxy.scrollTo(mainCategory.id, anchor: .top)
                        }
                    }
                }
            }
            
            // Navigation Buttons
            HStack {
                Button(action: {
                    withAnimation {
                        viewModel.moveToPreviousMainSection()
                        triggerHaptic()
                    }
                }) {
                    Text("Previous Section")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(viewModel.isFirstMainSection ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(viewModel.isFirstMainSection)
                .accessibilityLabel("Move to previous section")
    
                Button(action: {
                    withAnimation {
                        viewModel.moveToNextMainSection()
                        triggerHaptic()
                    }
                }) {
                    Text("Next Section")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(viewModel.isLastMainSection ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(viewModel.isLastMainSection)
                .accessibilityLabel("Move to next section")
            }
            .padding()
        }
        .navigationTitle("Optimal Path")
        .padding(.bottom)
    }
    
    // MARK: - Haptic Feedback Function
    // Defined inside the PathView struct
    func triggerHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
    }
    
    #Preview {
        let sampleItems1 = [
            ShoppingItem(name: "Apple", quantity: 2),
            ShoppingItem(name: "Banana", quantity: 3)
        ]
        let sampleItems2 = [
            ShoppingItem(name: "Milk", quantity: 1),
            ShoppingItem(name: "Cheese", quantity: 2)
        ]
        let sampleItems3 = [
            ShoppingItem(name: "Shampoo", quantity: 1),
            ShoppingItem(name: "Conditioner", quantity: 1)
        ]
        let sampleMainCategories = [
            MainCategory(name: "Groceries", subcategories: [
                SubCategory(name: "Fruits", items: sampleItems1),
                SubCategory(name: "Dairy", items: sampleItems2)
            ]),
            MainCategory(name: "Beauty", subcategories: [
                SubCategory(name: "Hair Care", items: sampleItems3)
            ])
        ]
        
        PathView(categorizedItems: sampleMainCategories, selectedStore: "Target")
    }
}
