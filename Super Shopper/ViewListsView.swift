//
//  ViewListsView.swift
//  Super Shopper
//
//  Created by Nathan Guzman on 11/11/24.
//


import SwiftUI

struct ViewListsView: View {
    var body: some View {
        VStack {
            Text("Past Lists")
                .font(.largeTitle)
                .padding()
            
            // Example placeholder list, replace with actual data and functionality
            List {
                ForEach(1..<6) { index in
                    HStack {
                        Text("List \(index)")
                        Spacer()
                        Button("Copy") {
                            // Add functionality to copy items into the current list
                        }
                        .foregroundColor(.blue)
                    }
                }
            }
        }
        .navigationTitle("View Lists")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ViewListsView()
}
