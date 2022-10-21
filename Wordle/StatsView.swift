//
//  StatsView.swift
//  Wordle
//
//  Created by Jonathan French on 20.10.22.
//

import SwiftUI

struct StatsView: View {
    @Binding var showingStats: Bool

    var body: some View {
        VStack {
          Text("Statistics")
          Spacer()
          Button("Cancel")
          { self.showingStats = false
          }
        }
    }
}

//struct StatsView_Previews: PreviewProvider {
//    @Binding var showingStats: Bool
//    static var previews: some View {
//        StatsView(showingStats: true)
//    }
//}
