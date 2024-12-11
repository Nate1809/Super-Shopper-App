//
//  SettingsView.swift
//  Super Shopper
//
//  Created by Nathan Guzman on 11/11/24.
//


import SwiftUI

struct SettingsView: View {
    @State private var preferredStore: String = "Target" // Example initial store

    let stores = ["Target", "Whole Foods", "HEB", "Walmart", "Generic Store"]

    var body: some View {
        Form {
            Section(header: Text("Preferred Store")) {
                Picker("Store", selection: $preferredStore) {
                    ForEach(stores, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            
            // Additional settings can be added here
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingsView()
}
