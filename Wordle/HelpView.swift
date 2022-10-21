//
//  HelpView.swift
//  Wordle
//
//  Created by Jonathan French on 20.10.22.
//

import SwiftUI

struct HelpView: View {
    @Binding var showingHelp: Bool

    var body: some View {
        VStack {
          Text("Help")
          Spacer()
          Button("Cancel")
          { self.showingHelp = false
          }
        }
    }
}

//struct HelpView_Previews: PreviewProvider {
//    static var previews: some View {
//        HelpView()
//    }
//}
