//
//  ContentView.swift
//  Wordle
//
//  Created by Jonathan French on 12.10.22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var manager: UserManager
    @State private var showingSettings = false
    @State private var showingHelp = false
    @State private var showingStats = false

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    let words = GameWords()
        
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                if manager.isNotWordView {
                    noWord()
                }
                
                VStack {
                    Spacer()
                    GameView()
                    Spacer()
                    HStack {
                        Spacer()
                        KeyboardView(showingStats: $showingStats)
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
                        Button(action: {showingStats = true}) {
                            Label("Statistics", systemImage: "rectangle.3.offgrid")
                                .foregroundColor(.black)
                        }.popover(isPresented: $showingStats) {
                            StatsView(showingStats: $showingStats)
                         }
                    }
                }.navigationTitle("SwiftUI Wordle")
            }.onAppear(){
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
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
