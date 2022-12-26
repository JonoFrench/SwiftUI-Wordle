//
//  ContentView.swift
//  Wordle
//
//  Created by Jonathan French on 12.10.22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var manager: UserManager
    @Environment(\.colorScheme) var colorScheme
    @State private var showingSettings = false
    @State private var showingHelp = false

    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                Color("Background")
                if manager.isNotWordView {
                    noWord()
                }
                if manager.gameOver {
                    finishView()
                }
                VStack {
                    Spacer()
                    GameView()
                    Spacer()
                    HStack {
                        Spacer()
                        KeyboardView()
                        Spacer()
                    }
                    Spacer()
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {showingSettings = true}) {
                            Label("Settings", systemImage: "gearshape.fill")
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                        }.popover(isPresented: $showingSettings) {
                            SettingsView(showingSettings: $showingSettings)
                        }
                    }                    
                    ToolbarItem {
                        Button(action: {showingHelp = true}) {
                            Label("Help", systemImage: "questionmark.circle")
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                        }.popover(isPresented: $showingHelp) {
                            HelpView(showingHelp: $showingHelp)
                         }
                    }
                    ToolbarItem {
                        Button(action: {manager.showingStats = true}) {
                            Label("Statistics", systemImage: "rectangle.3.offgrid")
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                        }.popover(isPresented: $manager.showingStats) {
                            StatsView()
                         }
                    }
                }.navigationTitle("SwiftUI Wordle")
            }
        }
    }
    
    struct noWord: View {
        @EnvironmentObject var manager: UserManager
        @Environment(\.colorScheme) var colorScheme
        var body: some View {
            VStack {
                Label ("Not a word", image: "")
                    .font(.caption)
                    .fontWeight(.bold)
                    .labelStyle(.titleOnly)
                    .frame(width: 100, height: 30,alignment: .center)
                    .foregroundColor(colorScheme == .dark ? .black : .white)
                    .background(colorScheme == .dark ? .white : .black)
            }.padding(.top, 20)
        }
    }

    struct finishView: View {
        @EnvironmentObject var manager: UserManager
        @Environment(\.colorScheme) var colorScheme
        var body: some View {
            VStack {
                Label (manager.winner == true ? manager.finishMessage : manager.gameWords.todaysWord, image: "")
                    .font(.caption)
                    .fontWeight(.bold)
                    .labelStyle(.titleOnly)
                    .frame(width: 100, height: 30,alignment: .center)
                    .foregroundColor(colorScheme == .dark ? .black : .white)
                    .background(colorScheme == .dark ? .white : .black)
            }.padding(.top, 20)
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView().environment(\.managedObjectContext, //PersistenceController.preview.container.viewContext)
//    }
//}
