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
                        ForEach(Array(viewModel.path.enumerated()), id: \.element.id) { mainIndex, mainCategory in
                            VStack(alignment: .leading, spacing: 10) {
                                // Main Section Header without Bolding
                                HStack {
                                    Text(mainCategory.name)
                                        .font(.title2)
                                        .foregroundColor(viewModel.currentMainSectionIndex == mainIndex ? .blue : .primary)
                                        .scaleEffect(viewModel.currentMainSectionIndex == mainIndex ? 1.05 : 1.0)
                                        .animation(.easeInOut(duration: 0.3), value: viewModel.currentMainSectionIndex)
                                    
                                    Spacer()
                                    
                                    if viewModel.currentMainSectionIndex == mainIndex {
                                        Text("Current Main Section")
                                            .font(.subheadline)
                                            .foregroundColor(.blue)
                                    }
                                }
                                .id(mainCategory.id) // For scrolling
                
                                // Sub-Sections
                                ForEach(Array(mainCategory.subcategories.enumerated()), id: \.element.id) { subIndex, subCategory in
                                    VStack(alignment: .leading, spacing: 5) {
                                        HStack {
                                            Text(subCategory.name)
                                                .font(.headline)
                                                .foregroundColor(viewModel.currentMainSectionIndex == mainIndex && viewModel.currentSubSectionIndex == subIndex ? .green : .secondary)
                                                .scaleEffect(viewModel.currentMainSectionIndex == mainIndex && viewModel.currentSubSectionIndex == subIndex ? 1.05 : 1.0)
                                                .animation(.easeInOut(duration: 0.3), value: viewModel.currentSubSectionIndex)
                                            
                                            Spacer()
                                            
                                            if viewModel.currentMainSectionIndex == mainIndex && viewModel.currentSubSectionIndex == subIndex {
                                                Text("Current Sub-Section")
                                                    .font(.subheadline)
                                                    .foregroundColor(.green)
                                            }
                                        }
                                        .id(subCategory.id) // For scrolling
                                        
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
                                // Automatically scroll to current sub-section
                                if viewModel.currentMainSectionIndex == mainIndex {
                                    let subCategory = viewModel.path[mainIndex].subcategories[viewModel.currentSubSectionIndex]
                                    withAnimation {
                                        proxy.scrollTo(subCategory.id, anchor: .top)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.top)
                }
                .onChange(of: viewModel.currentMainSectionIndex) { newMainIndex in
                    if newMainIndex < viewModel.path.count {
                        let mainCategory = viewModel.path[newMainIndex]
                        let subCategory = mainCategory.subcategories[viewModel.currentSubSectionIndex]
                        withAnimation {
                            proxy.scrollTo(subCategory.id, anchor: .top)
                        }
                    }
                }
                .onChange(of: viewModel.currentSubSectionIndex) { newSubIndex in
                    if newSubIndex < viewModel.path[viewModel.currentMainSectionIndex].subcategories.count {
                        let subCategory = viewModel.path[viewModel.currentMainSectionIndex].subcategories[newSubIndex]
                        withAnimation {
                            proxy.scrollTo(subCategory.id, anchor: .top)
                        }
                    }
                }
            }
            
            // Navigation Buttons
            HStack {
                Button(action: {
                    withAnimation {
                        viewModel.moveToPreviousSubSection()
                        triggerHaptic()
                    }
                }) {
                    Text("Previous Section")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(viewModel.isFirstSubSection ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(viewModel.isFirstSubSection)
                .accessibilityLabel("Move to previous section")
    
                Button(action: {
                    withAnimation {
                        viewModel.moveToNextSubSection()
                        triggerHaptic()
                    }
                }) {
                    Text("Next Section")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(viewModel.isLastSubSection ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(viewModel.isLastSubSection)
                .accessibilityLabel("Move to next section")
            }
            .padding()
        }
        .navigationTitle("Optimal Path")
        .padding(.bottom)
    }
    
    // MARK: - Haptic Feedback Function
    // Defined inside the PathView struct to ensure proper scope
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
