//
//  WordleApp.swift
//  Wordle
//
//  Created by Jonathan French on 12.10.22.
//

import SwiftUI
import CoreData

@main
struct WordleApp: App {
    @StateObject private var manager = UserManager()
    
    init() {
    }
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(manager)        }
    }
}
