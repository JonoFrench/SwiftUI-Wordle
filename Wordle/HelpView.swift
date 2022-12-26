//
//  HelpView.swift
//  Wordle
//
//  Created by Jonathan French on 20.10.22.
//

import SwiftUI

struct HelpView: View {
    @Binding var showingHelp: Bool
    @EnvironmentObject var manager: UserManager
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            closeButton
            VStack {
                Spacer()
                Text("How To Play").bold()
                Spacer()
                Group {
                    Text("Guess the Wordle in 6 tries.")
                    Spacer()
                    List {
                        Text("Each guess must be a valid 5-letter word")
                        Text("The color of the tiles will change to show how close your guess was to the word.")
                    }
                    Spacer()
                }
                Group {
                    Text("Examples").bold()
                    Spacer()
                    Image("Help1")
                    Text("W is in the word and in the correct spot.")
                    Image("Help2")
                    Text("I is in the word but in the wrong spot.")
                    Image("Help3")
                    Text("U is not in the word in any spot.")
                }
                Spacer()
            }
        }
    }
    var closeButton: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    self.showingHelp = false
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

//struct HelpView_Previews: PreviewProvider {
//    static var previews: some View {
//        HelpView()
//    }
//}
