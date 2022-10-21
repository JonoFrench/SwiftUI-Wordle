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
    @StateObject var manager = UserManager()

    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(UserManager())
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
