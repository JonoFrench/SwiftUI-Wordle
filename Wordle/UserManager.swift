//
//  UserManager.swift
//  Wordle
//
//  Created by Jonathan French on 12.10.22.
//

import Foundation
import SwiftUI
import CoreData

class UserManager: ObservableObject {
    var gameWords = GameWords()
    @Environment(\.colorScheme) var colorScheme

    @Published var line1: [KeyItem] = [KeyItem("Q"),KeyItem("W"),KeyItem("E"),KeyItem("R"),KeyItem("T"),KeyItem("Y"),KeyItem("U"),KeyItem("I"),KeyItem("O"),KeyItem("P")]
    @Published var line2: [KeyItem] = [KeyItem("A"),KeyItem("S"),KeyItem("D"),KeyItem("F"),KeyItem("G"),KeyItem("H"),KeyItem("J"),KeyItem("K"),KeyItem("L")]
    @Published var line3: [KeyItem] = [KeyItem("Z"),KeyItem("X"),KeyItem("C"),KeyItem("V"),KeyItem("B"),KeyItem("N"),KeyItem("M")]
    @Published
    var currentLine = 0
    @Published
    var currentPosition = 0
    @Published
    var wordsArray = [[LetterItem]](repeating: [LetterItem](repeating: LetterItem(""), count: 5), count: 6)
    @Published
    var isNotWord = false
    @Published
    var isNotWordView = false
    @Published
    var gameOver = false
    
    var winner = false
    
    @Published
    var showingStats = false
    @Published
    var showBack = [[Bool]](repeating: [Bool](repeating: false, count: 5), count: 6)
    @Published
    var currentFlip = 0

    @Published
    var inputDisabled = false

    
    /// Stats stuff
    
    @Published
    var gameStats = [0,0,0,0,0,0]
    @Published
    var gamesPlayed = 0
    @Published
    var playerStats: GameStats?
    
    var finishMessage : String {
        switch currentLine {
        case 0: return "Wow"
        case 1: return "Excellent"
        case 2: return "Well done"
        case 3: return "Good"
        case 4: return "Ok"
        case 5: return "Phew"
        default : return "Fail"
        }
    }
    
    init() {
        print("init UserManager")
        for x in 0...5 {
            for y in 0...4 {
                wordsArray[x][y] = LetterItem("")
            }
        }
        let dataManager = DataManager(userManager: self)
        //dataManager.clearData(entity: "GameStats")
        //dataManager.clearData(entity: "Games")
        //dataManager.seed()
        dataManager.fetchStats()
        dataManager.fetchGames()
    }
   
    
    func reset() {
        for x in 0...5 {
            for y in 0...4 {
                wordsArray[x][y] = LetterItem("")
                showBack[x][y] = false
            }
        }
        
        for i in 0..<line1.count { line1[i].result = .blank }
        for i in 0..<line2.count { line2[i].result = .blank }
        for i in 0..<line3.count { line3[i].result = .blank }
        currentLine = 0
        currentPosition = 0
        isNotWord = false
        winner = false
        inputDisabled = false
        gameWords.todaysWord = gameWords.getWord()
    }
    
    func checkEnter() {
        isNotWord = false
        if currentPosition != 4 {
            return
        }
        self.inputDisabled = true
        
        let letters = wordsArray[currentLine]
        var word = ""
        for l in letters {
            word += l.key.lowercased()
        }
        print(word)
        
        if gameWords.checkAnswer(word: word) == false {
            // not in word list
            isNotWord = true
            isNotWordView = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.isNotWordView = false
                self.inputDisabled = false
                self.isNotWord = false
            }
            return
        }
        
        let guess = gameWords.checkGuess(word: word)
        for (index, element) in guess.enumerated() {
            wordsArray[currentLine][index].result = element
            print("chars \(wordsArray[currentLine][index].key) Element \(element)")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
                if let index = line1.firstIndex(where: { $0.key == letters[index].key }) {
                    if line1[index].result != .yes {
                        line1[index].result = element
                    }
                } else if let index = line2.firstIndex(where: { $0.key == letters[index].key }) {
                    if line2[index].result != .yes {
                        line2[index].result = element
                    }
                } else if let index = line3.firstIndex(where: { $0.key == letters[index].key }) {
                    if line3[index].result != .yes {
                        line3[index].result = element
                    }
                }
            }
        }
        currentFlip = currentLine
        for i in 0...4 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) / 3) {
                self.showBack[self.currentFlip][i] = true
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            if self.gameWords.compareGuess(word: word) == false {
                self.currentPosition = 0
                if self.currentLine == 5 {
                    self.gameOver = true
                    self.winner = false
                    let dataManager = DataManager(userManager: self)
                    dataManager.update()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.gameOver = false
                        self.showingStats = true
                    }
                } else {
                    self.currentLine += 1
                    self.inputDisabled = false
                }
                print("Failed")
            } else {
                //we have a winner
                print("Winner")
                self.gameOver = true
                self.winner = true
                let dataManager = DataManager(userManager: self)
                dataManager.update()
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.gameOver = false
                    self.showingStats = true
                    return
                }
            }
        }
    }
}

struct LetterItem : Identifiable, Hashable, Equatable {
    var id: String {
        return key
    }
    init(_ key: String){
        self.key = key
        self.result = .blank
    }
    var key: String = ""
    var result: wordResults = .no
}

extension LetterItem {
    var backgroundColor: Color {
        switch (self.result) {
        case .blank: return .gray
        case .yes: return .green
        case .no: return Color(UIColor.lightGray)
        case .included: return .yellow
        }
    }
}

extension KeyItem {
    var backgroundColor: Color {
        switch (self.result) {
        case .blank: return Color(UIColor.systemGray6)
        case .yes: return .green
        case .no: return .gray
        case .included: return .yellow
        }
    }
}

extension KeyItem {
    var foregroundColor: Color {
        switch (self.result) {
        case .blank: return .black
        case .yes: return .white
        case .no: return .white
        case .included: return .white
        }
    }
}

