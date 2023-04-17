//
//  InertiaApp.swift
//  Inertia
//
//  Created by Grant Rulon on 4/10/23.
//

import SwiftUI

@main
struct InertiaApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
