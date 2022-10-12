//
//  WordleApp.swift
//  Wordle
//
//  Created by Jonathan French on 12.10.22.
//

import SwiftUI

@main
struct WordleApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
