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
        }
    }
}

//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsView()
//    }
//}
