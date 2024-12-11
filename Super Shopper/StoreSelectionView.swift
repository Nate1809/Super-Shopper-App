// StoreSelectionView.swift

import SwiftUI
import UIKit // Import UIKit for haptic feedback

struct StoreSelectionView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedStore: String

    let stores = ["Target", "Whole Foods", "HEB", "Other", "Generic Store"]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(stores, id: \.self) { store in
                    Button(action: {
                        triggerHaptic()
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
                    .buttonStyle(PressableButtonStyle()) // Apply custom button style
                }
            }
            .navigationTitle("Select Store")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .buttonStyle(PressableButtonStyle()) // Apply custom button style
                }
            }
        }
    }
    
    /// Triggers haptic feedback using UIImpactFeedbackGenerator
    func triggerHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
    }
    
    /// Custom ButtonStyle for press animations
    struct PressableButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
                .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
        }
    }
}

#Preview {
    StoreSelectionView(selectedStore: .constant("Target"))
}
