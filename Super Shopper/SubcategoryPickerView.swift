// SubcategoryPickerView.swift

import SwiftUI

struct SubcategoryPickerView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: CategorizedListViewModel
    let mainCategory: String
    @Binding var isScrolling: Bool
    
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
                        if !isScrolling {
                            viewModel.reassignItem(toMain: mainCategory, toSub: subCategory)
                            presentationMode.wrappedValue.dismiss() // Dismiss SubcategoryPickerView
                            // No need to dismiss CategoryPickerView as it's handled by NavigationLink
                        }
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
                    .disabled(isScrolling) // Disable button while scrolling
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
        .navigationTitle(mainCategory)
        .navigationBarBackButtonHidden(true) // Hide the default back button
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss() // Dismiss SubcategoryPickerView
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
                .accessibilityLabel("Back") // Improve accessibility
            }
        }
    }
}


