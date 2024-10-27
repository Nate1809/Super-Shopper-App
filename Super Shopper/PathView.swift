// PathView.swift

import SwiftUI

struct PathView: View {
    @ObservedObject var viewModel: PathViewModel
    @Namespace private var scrollNamespace // For smooth scrolling

    init(categorizedItems: [String: [ShoppingItem]], selectedStore: String) {
        self.viewModel = PathViewModel(categorizedItems: categorizedItems)
    }

    var body: some View {
        VStack {
            // Section Navigation Header
            HStack {
                Text("Current Section: \(viewModel.currentSectionTitle)")
                    .font(.headline)
                    .foregroundColor(.blue)
                Spacer()
                Button(action: {
                    withAnimation {
                        viewModel.moveToNextSection()
                    }
                }) {
                    Text("Next Section")
                        .padding(8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(viewModel.currentSectionIndex >= viewModel.sectionTitles.count - 1)
            }
            .padding([.horizontal, .top])

            // Full List with Scroll
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(viewModel.sectionTitles, id: \.self) { sectionTitle in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(sectionTitle)
                                    .font(.title3)
                                    .fontWeight(viewModel.isCurrentSection(sectionTitle) ? .bold : .regular)
                                    .foregroundColor(viewModel.isCurrentSection(sectionTitle) ? .blue : .primary)
                                    .padding(4)
                                    .background(viewModel.isCurrentSection(sectionTitle) ? Color.blue.opacity(0.1) : Color.clear)
                                    .cornerRadius(8)
                                    .id(sectionTitle) // For scroll targeting

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
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .onChange(of: viewModel.currentSectionIndex) { index in
                        // Scroll to the new current section smoothly
                        let sectionTitle = viewModel.sectionTitles[index]
                        withAnimation {
                            proxy.scrollTo(sectionTitle, anchor: .top)
                        }
                    }
                }
            }
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
