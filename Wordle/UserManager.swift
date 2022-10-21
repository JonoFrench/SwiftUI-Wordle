//
//  UserManager.swift
//  Wordle
//
//  Created by Jonathan French on 12.10.22.
//

import Foundation
import SwiftUI

class UserManager: ObservableObject {
    @Published var line1: [KeyItem] = [KeyItem("Q"),KeyItem("W"),KeyItem("E"),KeyItem("R"),KeyItem("T"),KeyItem("Y"),KeyItem("U"),KeyItem("I"),KeyItem("O"),KeyItem("P")]
    @Published var line2: [KeyItem] = [KeyItem("A"),KeyItem("S"),KeyItem("D"),KeyItem("F"),KeyItem("G"),KeyItem("H"),KeyItem("K"),KeyItem("L")]
    @Published var line3: [KeyItem] = [KeyItem("Z"),KeyItem("X"),KeyItem("C"),KeyItem("V"),KeyItem("B"),KeyItem("N"),KeyItem("M")]
    @Published
    var gameWords = GameWords()
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
    private var showingStats = false
    @Published
    var showBack = [[Bool]](repeating: [Bool](repeating: false, count: 5), count: 6)
    @Published
    var currentFlip = 0
    
    init() {
        for x in 0...5 {
            for y in 0...4 {
                wordsArray[x][y] = LetterItem("")
            }
        }
   }
    
    func reset() {
        for x in 0...5 {
            for y in 0...4 {
                wordsArray[x][y] = LetterItem("")
                showBack[x][y] = false
            }
        }
        currentLine = 0
        currentPosition = 0
        isNotWord = false
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

