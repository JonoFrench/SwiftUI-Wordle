//
//  WordleTests.swift
//  WordleTests
//
//  Created by Jonathan French on 12.10.22.
//

import XCTest
@testable import Wordle

final class WordleTests: XCTestCase {

    var words = GameWords()

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
        XCTAssert(words.checkGuess(word: "habcd") == results)

        //test guess contains no letters in any place
        results = [.no,.no,.no,.no,.no]
        XCTAssert(words.checkGuess(word: "abcdf") == results)

        //test guess contains one letter in incorrect place
        results = [.no,.included,.no,.no,.no]
        XCTAssert(words.checkGuess(word: "ahbcd") == results)

        //test guess contains same two letters in correct place
        results = [.no,.no,.yes,.yes,.no]
        XCTAssert(words.checkGuess(word: "abllc") == results)

        //test guess contains same two letters in incorrect place
        results = [.included,.included,.no,.no,.no]
        XCTAssert(words.checkGuess(word: "llabc") == results)

        //test guess contains one letter in correct place one letter incorrect place. Correct first
        results = [.no,.no,.yes,.no,.included]
        XCTAssert(words.checkGuess(word: "ablcl") == results)

        //test guess contains one letter in correct place one letter incorrect place. Correct last
        results = [.no,.no,.yes,.no,.no]
        XCTAssert(words.checkGuess(word: "lalbc") == results)

        //test guess contains two same letters, answer has only one in it, one in correct place. Correct last
        results = [.no,.yes,.no,.no,.no]
        XCTAssert(words.checkGuess(word: "eeabc") == results)

        //test guess contains two same letters, answer has only one in it, one in correct place. Correct first
        results = [.no,.yes,.no,.no,.no]
        XCTAssert(words.checkGuess(word: "aebce") == results)

        //test guess contains two same letters, answer has only one in it, one not in correct place. Correct first
        words.todaysWord = "covet"
        results = [.no,.no,.included,.included,.no]
        XCTAssert(words.checkGuess(word: "photo") == results)
        
        words.todaysWord = "morly"
        results = [.no,.no,.no,.yes,.yes]
        XCTAssert(words.checkGuess(word: "telly") == results)


    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
