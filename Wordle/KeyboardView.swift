//
//  KeyboardView.swift
//  Wordle
//
//  Created by Jonathan French on 12.10.22.
//

import SwiftUI

struct KeyboardView: View {
    @EnvironmentObject var manager: UserManager
    @Binding public var showingStats: Bool
    
    var body: some View {
        VStack {
            KeyboardLine(line: manager.line1)
            KeyboardLine(line: manager.line2)
            HStack {
                EnterButton(showingStats: $showingStats)
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
            print("manager.currentPosition \(manager.currentPosition)")
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
    @Binding public var showingStats: Bool
    
    var body: some View {
        Button(action: {
            if manager.currentPosition != 4 {
                return
            }
            
            let letters = manager.wordsArray[manager.currentLine]
            var word = ""
            for l in letters {
                word += l.key.lowercased()
            }
            print(word)
            
            if manager.gameWords.checkAnswer(word: word) == false {
                // not in word list
                manager.isNotWord.toggle()
                manager.isNotWordView = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    manager.isNotWordView = false
                }
                return
            }
            
            let guess = manager.gameWords.checkGuess(word: word)
            for (index, element) in guess.enumerated() {
                manager.wordsArray[manager.currentLine][index].result = element
                print("chars \(manager.wordsArray[manager.currentLine][index].key) Element \(element)")
                if let index = manager.line1.firstIndex(where: { $0.key == letters[index].key }) {
                    if manager.line1[index].result != .yes {
                        manager.line1[index].result = element
                    }
                } else if let index = manager.line2.firstIndex(where: { $0.key == letters[index].key }) {
                    if manager.line2[index].result != .yes {
                        manager.line2[index].result = element
                    }
                } else if let index = manager.line3.firstIndex(where: { $0.key == letters[index].key }) {
                    if manager.line3[index].result != .yes {
                        manager.line3[index].result = element
                    }
                }
            }
            manager.currentFlip = manager.currentLine
            for i in 0...4 {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) / 3) {
                    manager.showBack[manager.currentFlip][i] = true
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                
                if manager.gameWords.compareGuess(word: word) == false {
                    manager.currentPosition = 0
                    manager.currentLine += 1
                } else {
                    //we have a winner
                    showingStats = true
                }
                print("Winner")
            }
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

struct KeyboardView_Previews: PreviewProvider {
    @State static var value = false
    
    static var previews: some View {
        KeyboardView(showingStats: $value)
    }
}
