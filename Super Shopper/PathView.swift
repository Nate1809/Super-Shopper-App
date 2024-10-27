// PathView.swift

import SwiftUI

struct PathView: View {
    @ObservedObject var viewModel: PathViewModel
    @Namespace private var scrollNamespace // For smooth scrolling

    init(categorizedItems: [String: [ShoppingItem]], selectedStore: String) {
        let viewModel = PathViewModel(categorizedItems: categorizedItems)
        self.viewModel = viewModel
        self.viewModel.onAutoAdvance = { [weak viewModel] in
            withAnimation {
                viewModel?.moveToNextSection()
            }
        }
    }

    var body: some View {
        VStack {
            // Current Section Header
            Text("Current Section: \(viewModel.currentSectionTitle)")
                .font(.title) // Larger font size for emphasis
                .fontWeight(.bold)
                .foregroundColor(.blue)
                .padding(.top)

            // Full List with Scroll and Section Containers
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(viewModel.sectionTitles, id: \.self) { sectionTitle in
                            VStack(alignment: .leading, spacing: 4) {
                                // Section Title with Divider
                                HStack {
                                    Text(sectionTitle)
                                        .font(.title3)
                                        .fontWeight(viewModel.isCurrentSection(sectionTitle) ? .bold : .regular)
                                        .foregroundColor(viewModel.isCurrentSection(sectionTitle) ? .blue : .primary)
                                    Spacer()
                                }
                                .padding(.bottom, 2)
                                Divider()
                                    .background(viewModel.isCurrentSection(sectionTitle) ? Color.blue.opacity(0.5) : Color.gray.opacity(0.3))

                                // Section Items in a Rounded Container
                                VStack(spacing: 4) {
                                    ForEach(viewModel.categorizedItems[sectionTitle] ?? []) { item in
                                        HStack {
                                            Text(item.name)
                                                .strikethrough(viewModel.isItemGrabbed(item), color: .gray)
                                                .foregroundColor(viewModel.isItemGrabbed(item) ? .gray : .primary)
                                            Spacer()
                                            Text("Qty: \(item.quantity)")
                                                .foregroundColor(viewModel.isItemGrabbed(item) ? .gray : .secondary)
                                            Button(action: {
                                                viewModel.toggleItemGrabbed(item)
                                            }) {
                                                Image(systemName: viewModel.isItemGrabbed(item) ? "checkmark.circle.fill" : "circle")
                                                    .foregroundColor(viewModel.isItemGrabbed(item) ? .green : .gray)
                                            }
                                            .buttonStyle(BorderlessButtonStyle())
                                        }
                                        .padding(.vertical, 4)
                                        .padding(.horizontal, 8)
                                        .background(viewModel.isCurrentSection(sectionTitle) ? Color.blue.opacity(0.05) : Color.clear)
                                        .cornerRadius(8)
                                    }
                                }
                                .padding()
                                .background(viewModel.isCurrentSection(sectionTitle) ? Color.blue.opacity(0.1) : Color.gray.opacity(0.1))
                                .cornerRadius(12)
                                .shadow(color: viewModel.isCurrentSection(sectionTitle) ? Color.blue.opacity(0.2) : Color.clear, radius: 5, x: 0, y: 3)
                            }
                            .padding(.horizontal)
                            .id(sectionTitle) // For scroll targeting
                        }
                    }
                    .onChange(of: viewModel.currentSectionIndex) { index in
                        // Smooth scroll to the new current section
                        let sectionTitle = viewModel.sectionTitles[index]
                        withAnimation {
                            proxy.scrollTo(sectionTitle, anchor: .top)
                        }
                    }
                }
            }

            // Previous and Next Section Buttons at the Bottom
            HStack {
                Button(action: {
                    withAnimation {
                        viewModel.moveToPreviousSection()
                    }
                }) {
                    Text("Previous Section")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(viewModel.currentSectionIndex > 0 ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(viewModel.currentSectionIndex == 0)

                Button(action: {
                    withAnimation {
                        viewModel.moveToNextSection()
                    }
                }) {
                    Text("Next Section")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(viewModel.currentSectionIndex < viewModel.sectionTitles.count - 1 ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(viewModel.currentSectionIndex >= viewModel.sectionTitles.count - 1)
            }
            .padding()
        }
        .navigationTitle("Optimal Path")
        .padding(.bottom) // Extra padding to avoid bottom overlap
    }
}

#Preview {
    PathView(categorizedItems: [
        "Produce": [ShoppingItem(name: "Apple", quantity: 2)],
        "Dairy": [ShoppingItem(name: "Milk", quantity: 1)]
    ], selectedStore: "Generic Store")
}
