//
//  InertiaApp.swift
//  Inertia
//
//  Created by Grant Rulon on 4/10/23.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, NSApplicationDelegate {
//    func applicationDid(_ application: NSApplication, didFinishLaunchingWithOptions launchOptions: [NSApplication. : Any]? = nil) -> Bool {
//        FirebaseApp.configure()
//        return true
//      }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        FirebaseApp.configure()
    }

}

@main
struct InertiaApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
