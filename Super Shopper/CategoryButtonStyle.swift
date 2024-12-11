// CategoryButtonStyle.swift

import SwiftUI

struct CategoryButtonStyle: ButtonStyle {
    let backgroundColor: Color

    func makeBody(configuration: Configuration) -> some View {
        VStack {
            configuration.label
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, minHeight: 100)
        .background(backgroundColor)
        .cornerRadius(10)
        // Removed scaleEffect and animation for snappier responsiveness
    }
}

#Preview {
    Button(action: {
        print("Test Button Tapped")
    }) {
        VStack {
            Text("🍎")
                .font(.largeTitle)
            Text("Produce")
                .font(.headline)
                .multilineTextAlignment(.center)
        }
    }
    .buttonStyle(CategoryButtonStyle(backgroundColor: .red))
    .padding()
}
