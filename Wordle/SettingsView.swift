//
//  SettingsView.swift
//  Wordle
//
//  Created by Jonathan French on 20.10.22.
//

import SwiftUI

struct SettingsView: View {
    @Binding var showingSettings: Bool

    var body: some View {
        VStack {
          Text("Settings")
          Spacer()
          Button("Cancel")
          { self.showingSettings = false
          }
        }
    }
}

//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsView()
//    }
//}
