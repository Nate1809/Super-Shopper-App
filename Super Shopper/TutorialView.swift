// TutorialView.swift

import SwiftUI

struct TutorialView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("📋 **Super Shopper Tutorial**")
                        .font(.largeTitle)
                        .bold()
                        .padding(.bottom, 10)

                    VStack(alignment: .leading, spacing: 15) {
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "1.circle")
                                .foregroundColor(.blue)
                                .font(.title)
                            Text("**Add Items:** Input the items you wish to purchase using the 'Add' button.")
                                .font(.body)
                        }

                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "2.circle")
                                .foregroundColor(.blue)
                                .font(.title)
                            Text("**Categorize Items:** Tap on an item to assign it to a category for organized shopping.")
                                .font(.body)
                        }

                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "3.circle")
                                .foregroundColor(.blue)
                                .font(.title)
                            Text("**Proceed to Categories:** Once you've added items, tap 'Proceed to Categories' to organize your list.")
                                .font(.body)
                        }

                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "4.circle")
                                .foregroundColor(.blue)
                                .font(.title)
                            Text("**Get Optimal Path:** Access the optimal path view to shop efficiently based on your list.")
                                .font(.body)
                        }
                    }
                    .padding()

                    Spacer()
                }
                .padding()
            }
            .navigationBarTitle("Super Shopper Tutorial", displayMode: .inline) // Single Title
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    TutorialView()
}
