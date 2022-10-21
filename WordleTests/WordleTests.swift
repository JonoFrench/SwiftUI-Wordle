//
//  WordleTests.swift
//  WordleTests
//
//  Created by Jonathan French on 12.10.22.
//

import XCTest
@testable import Wordle

final class WordleTests: XCTestCase {

    let words = GameWords()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testToday() throws {
        
        let word = words.getWord()
        // test for a word that is 5 characters long
        XCTAssert(!word.isEmpty)
        XCTAssert(words.todaysWord.count == 5)
        
        XCTAssert(words.checkWord(word: "hello") == true)
        XCTAssert(words.checkWord(word: "jofwe") == false)

        print("hello \(words.checkAnswer(word: "hello"))")
        print("basic \(words.checkAnswer(word: "basic"))")
        print("Todays word \(words.getWord())")
        
        

    }
    
    func testWordLists() throws {
        let answers = words.readAnswers()
        let allWords = words.readWordList()
        XCTAssert(answers != [])
        XCTAssert(allWords != [])
        XCTAssert(answers.count == 2310)
        XCTAssert(allWords.count == 12948)

    }

    func testCorrect() throws {
        var results: [wordResults] = [.yes,.yes,.yes,.yes,.yes]
        words.todaysWord = "hello"
        // Test for correct guess
        XCTAssert(words.checkGuess(word: "hello") == results)
        
        //test guess contains one letter in correct place
        results = [.yes,.no,.no,.no,.no]
        XCTAssert(words.checkGuess(word: "hxxxx") == results)

        //test guess contains no letters in any place
        results = [.no,.no,.no,.no,.no]
        XCTAssert(words.checkGuess(word: "xxxxx") == results)

        //test guess contains one letter in incorrect place
        results = [.no,.included,.no,.no,.no]
        XCTAssert(words.checkGuess(word: "xhxxx") == results)

        //test guess contains same two letters in correct place
        results = [.no,.no,.yes,.yes,.no]
        XCTAssert(words.checkGuess(word: "xxllx") == results)

        //test guess contains same two letters in incorrect place
        results = [.included,.included,.no,.no,.no]
        XCTAssert(words.checkGuess(word: "llxxx") == results)
        
        //test guess contains one letter in correct place one letter incorrect place
        results = [.no,.no,.yes,.no,.included]
        XCTAssert(words.checkGuess(word: "xxlxl") == results)

        
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
