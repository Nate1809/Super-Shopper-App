// StoreSelectionView.swift

import SwiftUI

struct StoreSelectionView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedStore: String

    let stores = ["Target", "Whole Foods", "HEB", "Other", "Generic Store"]

    var body: some View {
        NavigationView {
            List {
                ForEach(stores, id: \.self) { store in
                    Button(action: {
                        selectedStore = store
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "cart")
                                .foregroundColor(.blue)
                            Text(store)
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
            .navigationTitle("Select Store")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    StoreSelectionView(selectedStore: .constant("Target"))
}
