//
//  KeyboardView.swift
//  Wordle
//
//  Created by Jonathan French on 12.10.22.
//

import SwiftUI

struct KeyboardView: View {
    @EnvironmentObject var manager: UserManager
    
    var body: some View {
        VStack {
            KeyboardLine(line: manager.line1)
            KeyboardLine(line: manager.line2)
            HStack {
                EnterButton()
                KeyboardLine(line: manager.line3)
                BackButton()
            }
        }
    }
}

func KeyboardLine(line: [KeyItem]) -> some View {
    HStack {
        ForEach(line) { letter in
            KeyButton(keyItem: letter)
        }
    }
}

struct KeyButton : View {
    var keyItem: KeyItem
    @EnvironmentObject var manager: UserManager
    
    var body: some View {
        Button(action: {
            manager.wordsArray[manager.currentLine][manager.currentPosition].key = keyItem.key.uppercased()
            if manager.currentPosition < 4 {
                manager.currentPosition += 1
            }
            print(keyItem.key,keyItem.used)
        }){
            Text(keyItem.key)
                .foregroundColor(keyItem.foregroundColor)
                .font(.system(size: 10, weight: Font.Weight.bold))
                .frame(minHeight: 30)
                .ignoresSafeArea()
        }
        .background(keyItem.backgroundColor)
        .buttonStyle(.bordered)
    }
}

struct BackButton : View {
    @EnvironmentObject var manager: UserManager
    
    var body: some View {
        Button(action: {
            if manager.wordsArray[manager.currentLine][manager.currentPosition].key == "" {
                if manager.currentPosition > 0 {
                    manager.currentPosition -= 1
                }
            }
            manager.wordsArray[manager.currentLine][manager.currentPosition].key = ""
            if manager.currentPosition <= 0 {
                manager.currentPosition = 0
            }
            
        }){
            Label("", systemImage: "delete.left")
                .background(Color(UIColor.systemGray5))
                .foregroundColor(.black)
                .frame(maxWidth: 16, minHeight: 30)
        }
        .buttonStyle(.bordered)
    }
    
}
struct EnterButton : View {
    @EnvironmentObject var manager: UserManager
    
    var body: some View {
        Button(action: {
            manager.checkEnter()
        }){
            Text("Enter")
                .foregroundColor(.black)
                .font(.system(size: 10, weight: Font.Weight.bold))
                .frame(minHeight: 30)
        }
        .buttonStyle(.bordered)
    }
}

struct KeyItem : Identifiable, Hashable {
    var id: String {
        return key
    }
    init(_ key: String){
        self.key = key
    }
    var key: String = ""
    var used: Bool = false
    var result: wordResults = .blank
}

//struct KeyboardView_Previews: PreviewProvider {
//    @State static var value = false
//
//    static var previews: some View {
//        KeyboardView(showingStats: $value)
//    }
//}
