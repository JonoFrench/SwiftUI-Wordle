//
//  gameWords.swift
//  Wordle
//
//  Created by Jonathan French on 14.10.22.
//

import Foundation

enum wordResults {
    case blank,no,included,yes
}

struct GameWords {
    
    var answers:[String] = []
    var allWords:[String] = []
    var todaysWord = ""
        
    init() {
        print("init GameWords")
        answers = readAnswers()
        allWords = readWordList()
        todaysWord = getWord()
        print(answers.count)
        print(allWords.count)
        print(todaysWord)
    }
        
    func checkWord(word: String) -> Bool {
        return allWords.contains(word)
    }
    
    func checkAnswer(word: String) -> Bool {
        return answers.contains(word)
    }
    
    func checkGuess(word: String) -> [wordResults] {
        var results: [wordResults] = []
        var todaysChars: [Character] = []
        var guessChars: [Character] = []
        var usedChars: [Character] = []
        for (_, char) in word.enumerated() {
//            print("index = \(index), character = \(char)")
            guessChars.append(char)
        }
 
        for (_, char) in todaysWord.enumerated() {
//            print("index = \(index), character = \(char)")
            todaysChars.append(char)
        }
        print("todays chars \(todaysChars)")
        print("guess chars \(guessChars)")

        for i in 0...4 {
            print("guess letter \(guessChars[i])")
            print("today letter \(todaysChars[i])")
           if guessChars[i] == todaysChars[i] {
                results.append(.yes)
                usedChars.append(guessChars[i])
            } else if todaysChars.filter({$0 == guessChars[i]}).count > 1 && !usedChars.contains(guessChars[i]){
                results.append(.included)
                usedChars.append(guessChars[i])

            }  else if todaysChars.filter({$0 == guessChars[i]}).count > 1 && guessChars.filter({$0 == guessChars[i]}).count > 1 {
                results.append(.included)
                usedChars.append(guessChars[i])
            } else if todaysChars.filter({$0 == guessChars[i]}).count > 1 && usedChars.contains(guessChars[i]){
                results.append(.no)
            } else if todaysChars.filter({$0 == guessChars[i]}).count > 1 && !usedChars.contains(guessChars[i]) && usedChars.count > 0 {
                results.append(.included) //.no
                usedChars.append(guessChars[i])
            }
            
            else if todaysChars.contains(guessChars[i]) && !usedChars.contains(guessChars[i]){
                results.append(.included)
                usedChars.append(guessChars[i])
            } else {
                results.append(.no)
            }
        }
        
        // duplicate handling
        // if we have duplicate letters in the guess and the answer has only one and say the first is included and the second is correct
        // then we want to set the first included to no.
        let duplicateArray = usedChars.filter({ c in
           return usedChars.filter({ $0 == c }).count > 1
        })
        let duplicates = Array(Set(duplicateArray))
        var someCorrect = false
        
        for dupe in duplicates  {
            for i in 0...4 {
                if guessChars[i] == dupe && results[i] == .yes {
                    someCorrect = true
                }
            }
                    
            print("duplicate chars \(duplicates)")
            if someCorrect {
                for i in 0...4 {
                    if guessChars[i] == dupe && results[i] == .yes {
                        break
                    } else if guessChars[i] == dupe && results[i] == .included {
                        results[i] = .no
                    }
                }
            }
        }
        print("used chars \(usedChars)")
        print("results chars \(results)")

        return results
    }
    
    func getWord() -> String {
        let index = Int.random(in: 0..<answers.count)
        //todaysWord = answers[index]
        //todaysWord = "slate"
        return answers[index]
    }

    func compareGuess(word: String) -> Bool {
        return word == todaysWord
    }
    
    func readAnswers () -> [String] {
        if let path = Bundle.main.path(forResource: "answerlist", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let answerStrings = data.components(separatedBy: .newlines)
                return answerStrings
            } catch {
                print(error)
            }
        }
        return []
    }

    func readWordList () -> [String] {
        if let path = Bundle.main.path(forResource: "wordlist", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let wordsStrings = data.components(separatedBy: .newlines)
                return wordsStrings
            } catch {
                print(error)
            }
        }
        return []
    }
}
