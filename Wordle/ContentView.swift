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
    @State private var showingSettings = false
    @State private var showingHelp = false

    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
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
                                .foregroundColor(.black)
                        }.popover(isPresented: $showingSettings) {
                            SettingsView(showingSettings: $showingSettings)
                        }
                    }                    
                    ToolbarItem {
                        Button(action: {showingHelp = true}) {
                            Label("Help", systemImage: "questionmark.circle")
                                .foregroundColor(.black)
                        }.popover(isPresented: $showingHelp) {
                            HelpView(showingHelp: $showingHelp)
                         }
                    }
                    ToolbarItem {
                        Button(action: {manager.showingStats = true}) {
                            Label("Statistics", systemImage: "rectangle.3.offgrid")
                                .foregroundColor(.black)
                        }.popover(isPresented: $manager.showingStats) {
                            StatsView()
                         }
                    }
                }.navigationTitle("SwiftUI Wordle")
            }.navigationBarTitle("Wordle", displayMode: .inline)
        }
    }
    
    struct noWord: View {
        var body: some View {
            VStack {
                Label ("Not a word", image: "")
                    .font(.caption)
                    .fontWeight(.bold)
                    .labelStyle(.titleOnly)
                    .frame(width: 100, height: 30,alignment: .center)
                    .foregroundColor(.white)
                    .background(Color.black)
            }.padding(.top, 20)
        }
    }

    struct finishView: View {
        @EnvironmentObject var manager: UserManager
        var body: some View {
            VStack {
                Label (manager.finishMessage, image: "")
                    .font(.caption)
                    .fontWeight(.bold)
                    .labelStyle(.titleOnly)
                    .frame(width: 100, height: 30,alignment: .center)
                    .foregroundColor(.white)
                    .background(Color.black)
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
