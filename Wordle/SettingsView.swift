//
//  SettingsView.swift
//  Wordle
//
//  Created by Jonathan French on 20.10.22.
//

import SwiftUI

struct SettingsView: View {
    @Binding var showingSettings: Bool
    @EnvironmentObject var manager: UserManager
    @Environment(\.colorScheme) var colorScheme
    @State private var setHardMode = false
    @State private var showAlert = false
    
    var body: some View {
        ZStack{
            closeButton
            VStack {
                Text("Settings")
                Spacer()
            }
        }
    }
    var closeButton: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    self.showingSettings = false
                }) {
                    Image(systemName: "xmark.circle")
                        .padding(10)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                }
            }
            .padding(.top, 5)
            Spacer()
            HStack {
                
                Spacer()
                Toggle("Hard Mode", isOn: $setHardMode)
            }.padding(100)
            if setHardMode {
                Text("Hard mode on")
            }
            Spacer()
            
            Button(action: {
                self.showAlert = true
            }) {
                Text("Reset Stats")
                    .foregroundColor(Color.white)
            }.buttonStyle(.borderedProminent)
                .tint(.red)
                .alert(isPresented: $showAlert) { () -> Alert in
                    Alert(title: Text("SwiftUI Wordle"), message: Text("Are you sure you want to reset all data."), primaryButton: .default(Text("Ok"), action: {
                        print("OK Click")
                        let dataManager = DataManager(userManager: manager)
                        dataManager.clearData(entity: "GameStats")
                        dataManager.clearData(entity: "Games")
                        dataManager.fetchStats()
                        dataManager.fetchGames()
                        manager.playerStats = nil
                        manager.reset()
                        self.showingSettings = false
                    }), secondaryButton: .default(Text("Cancel")))
                }
            Spacer()
        }
    }
}

//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsView(showingSettings: $showingSettings)
//    }
//}
