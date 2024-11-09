// PathView.swift

import SwiftUI

struct PathView: View {
    @ObservedObject var viewModel: PathViewModel
    @State private var scrollToAisle: UUID? = nil

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
                        ForEach(viewModel.path) { aisleCategory in
                            VStack(alignment: .leading, spacing: 10) {
                                // Aisle Header
                                HStack {
                                    Text(aisleCategory.name)
                                        .font(.title2)
                                        .foregroundColor(viewModel.currentAisleIndex == viewModel.path.firstIndex(of: aisleCategory) ? .blue : .primary)
                                        .scaleEffect(viewModel.currentAisleIndex == viewModel.path.firstIndex(of: aisleCategory) ? 1.05 : 1.0)
                                        .animation(.easeInOut(duration: 0.3), value: viewModel.currentAisleIndex)

                                    Spacer()

                                    if viewModel.currentAisleIndex == viewModel.path.firstIndex(of: aisleCategory) {
                                        Text("Current Aisle")
                                            .font(.subheadline)
                                            .foregroundColor(.blue)
                                    }
                                }
                                .id(aisleCategory.id) // For scrolling

                                // Items List
                                VStack(alignment: .leading, spacing: 5) {
                                    ForEach(aisleCategory.items) { item in
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
                        .padding(.top)
                    }
                }
                .onChange(of: viewModel.currentAisleIndex) { newAisleIndex in
                    if newAisleIndex < viewModel.path.count {
                        let aisle = viewModel.path[newAisleIndex]
                        withAnimation {
                            proxy.scrollTo(aisle.id, anchor: .top)
                        }
                    }
                }
            }

            // Navigation Buttons
            HStack {
                Button(action: {
                    withAnimation {
                        viewModel.moveToPreviousAisle()
                        triggerHaptic()
                    }
                }) {
                    Text("Previous Aisle")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(viewModel.isFirstAisle ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(viewModel.isFirstAisle)
                .accessibilityLabel("Move to previous aisle")

                Button(action: {
                    withAnimation {
                        viewModel.moveToNextAisle()
                        triggerHaptic()
                    }
                }) {
                    Text("Next Aisle")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(viewModel.isLastAisle ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(viewModel.isLastAisle)
                .accessibilityLabel("Move to next aisle")
            }
            .padding()
        }
        .navigationTitle("Optimal Path")
        .padding(.bottom)
    }

    // MARK: - Haptic Feedback Function
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
            MainCategory(name: "Produce", subcategories: [
                SubCategory(name: "Produce", items: sampleItems1)
            ]),
            MainCategory(name: "Dairy", subcategories: [
                SubCategory(name: "Dairy", items: sampleItems2)
            ]),
            MainCategory(name: "Personal Care", subcategories: [
                SubCategory(name: "Bath & Body", items: sampleItems3)
            ])
        ]

        PathView(categorizedItems: sampleMainCategories, selectedStore: "Target")
    }
}
