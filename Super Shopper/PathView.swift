// PathView.swift

import SwiftUI
import ConfettiSwiftUI // Import the ConfettiSwiftUI package

struct PathView: View {
    @ObservedObject var viewModel: PathViewModel
    @State private var scrollToAisle: UUID? = nil
    @State private var confettiCounter: Int = 0 // State variable for confetti

    init(categorizedItems: [MainCategory], selectedStore: String) {
        self.viewModel = PathViewModel(categorizedItems: categorizedItems, selectedStore: selectedStore)
    }

    var body: some View {
        ZStack {
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
                            ForEach(Array(viewModel.path.enumerated()), id: \.1.id) { index, aisleCategory in
                                AisleSectionView(
                                    aisleCategory: aisleCategory,
                                    isCurrentAisle: viewModel.currentAisleIndex == index,
                                    viewModel: viewModel
                                )
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

            // Confetti View
            if viewModel.allItemsGrabbed {
                ConfettiCannon(counter: $confettiCounter, num: 100, rainHeight: 800.0, radius: 350.0)
                    .onAppear {
                        confettiCounter += 1
                        triggerSuccessHaptic()
                    }
            }
        }
    }

    // MARK: - Haptic Feedback Functions

    func triggerHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
    }

    func triggerSuccessHaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}

// MARK: - AisleSectionView

struct AisleSectionView: View {
    let aisleCategory: AisleCategory
    let isCurrentAisle: Bool
    @ObservedObject var viewModel: PathViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Aisle Header
            HStack {
                if isCurrentAisle {
                    Image(systemName: "arrow.right.circle.fill")
                        .foregroundColor(.white)
                        .padding(.leading)
                } else {
                    Spacer()
                        .frame(width: 24)
                }

                Text(aisleCategory.name)
                    .font(.title2)
                    .foregroundColor(isCurrentAisle ? .white : .primary)
                    .padding(.leading, 4)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .allowsTightening(true)

                Spacer()
            }
            .padding(.vertical, 8)
            .id(aisleCategory.id) // For scrolling

            // Items List
            VStack(alignment: .leading, spacing: 5) {
                ForEach(aisleCategory.items) { item in
                    ItemRowView(item: item, isCurrentAisle: isCurrentAisle, viewModel: viewModel)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 5)
            .background(isCurrentAisle ? Color.white.opacity(0.1) : Color.gray.opacity(0.05))
            .cornerRadius(10)
        }
        .padding(.horizontal)
        .padding(.top, isCurrentAisle ? 10 : 0)
        .padding(.bottom, isCurrentAisle ? 10 : 0)
        .background {
            if isCurrentAisle {
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.blue]),
                               startPoint: .topLeading, endPoint: .bottomTrailing)
                    .cornerRadius(15)
                    .shadow(color: Color.blue.opacity(0.4), radius: 5, x: 0, y: 3)
            } else {
                Color.clear
            }
        }
        .animation(.easeInOut(duration: 0.3), value: isCurrentAisle)
    }
}

// MARK: - ItemRowView

struct ItemRowView: View {
    let item: ShoppingItem
    let isCurrentAisle: Bool
    @ObservedObject var viewModel: PathViewModel

    var body: some View {
        HStack {
            Text(item.name)
                .strikethrough(viewModel.isItemGrabbed(item), color: strikethroughColor)
                .foregroundColor(textColor)
            Spacer()
            Text("Qty: \(item.quantity)")
                .foregroundColor(textColor)
            Button(action: {
                withAnimation {
                    viewModel.toggleItemGrabbed(item)
                    triggerHaptic()
                }
            }) {
                Image(systemName: viewModel.isItemGrabbed(item) ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(viewModel.isItemGrabbed(item) ? .green : isCurrentAisle ? .white : .gray)
            }
            .buttonStyle(BorderlessButtonStyle())
            .accessibilityLabel(viewModel.isItemGrabbed(item) ? "Uncheck \(item.name)" : "Check \(item.name)")
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
        .background(itemBackgroundColor)
        .cornerRadius(8)
    }

    // Haptic Feedback Function
    func triggerHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
    }

    // MARK: - Computed Properties

    var textColor: Color {
        if viewModel.isItemGrabbed(item) {
            return isCurrentAisle ? .white : .gray
        } else {
            return isCurrentAisle ? .white : .primary
        }
    }

    var strikethroughColor: Color {
        if viewModel.isItemGrabbed(item) {
            return isCurrentAisle ? Color.white.opacity(0.6) : .gray
        } else {
            return Color.clear
        }
    }

    var itemBackgroundColor: Color {
        if viewModel.isItemGrabbed(item) {
            return isCurrentAisle ? Color.black.opacity(0.2) : Color.gray.opacity(0.1)
        } else {
            return Color.clear
        }
    }
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
