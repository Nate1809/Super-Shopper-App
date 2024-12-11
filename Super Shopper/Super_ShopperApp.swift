//
//  Super_ShopperApp.swift
//  Super Shopper
//
//  Created by Nathan Guzman on 10/25/24.
//

// Super_ShopperApp.swift

import SwiftUI

@main
struct Super_ShopperApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainMenuView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
