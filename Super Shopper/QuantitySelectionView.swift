import SwiftUI

struct QuantitySelectionView: View {
    @Binding var quantity: Int
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            VStack {
                Stepper("Quantity: \(quantity)", value: $quantity, in: 1...100)
                    .padding()
                Spacer()
            }
            .navigationTitle("Select Quantity")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
