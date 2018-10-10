//
//  DictionaryModelTests.swift
//  AnagramTests
//
//  Created by Krzysztof Grobelny on 10/10/2018.
//  Copyright © 2018 Mobica. All rights reserved.
//

import XCTest
@testable import Anagram

class DictionaryModelTests: XCTestCase
{
    var wordDictionary: DictionaryEntries {
        var wordDictionary = DictionaryEntries()
        wordDictionary["Car"] = [String]()
        wordDictionary["Arc"] = [String]()
        wordDictionary["Rat"] = [String]()
        wordDictionary["Elbow"] = [String]()
        wordDictionary["Below"] = [String]()
        return wordDictionary
    }

    var jsonDictionary: DictionaryEntries? {
        if let path = Bundle(for: DictionaryModelTests.self).url(forResource: "english", withExtension: "json") {
            do {
                let data = try Data(contentsOf: path)
                let entries = try JSONDecoder().decode(DictionaryEntries.self, from: data)
                return entries
            }
            catch {
                return nil
            }
        }
        return nil
    }

    func testAnagramsForTooShortWord()
    {
        // given
        let word = "a"

        // when
        let expectation = self.expectation(description: "\(#function)")
        let model = DictionaryModel(entries: wordDictionary)
        var anagrams: [String]?

        model.anagramsFor(word: word) { (result) in
            anagrams = result
            expectation.fulfill()
        }

        // then
        wait(for: [expectation], timeout: 3)
        XCTAssertNil(anagrams)
    }

    func testAnagramsForWordOfUnavailableLength()
    {
        // given
        let word = "rainbow"

        // when
        let expectation = self.expectation(description: "\(#function)")
        let model = DictionaryModel(entries: wordDictionary)
        var anagrams: [String]?

        model.anagramsFor(word: word) { (result) in
            anagrams = result
            expectation.fulfill()
        }

        // then
        wait(for: [expectation], timeout: 3)
        XCTAssertNil(anagrams)
    }

    func testAnagramsForWordWithoutAnagrams()
    {
        // given
        let word = "cat"

        // when
        let expectation = self.expectation(description: "\(#function)")
        let model = DictionaryModel(entries: wordDictionary)
        var anagrams: [String]?

        model.anagramsFor(word: word) { (result) in
            anagrams = result
            expectation.fulfill()
        }

        // then
        wait(for: [expectation], timeout: 3)
        XCTAssertNil(anagrams)
    }

    func testAnagramsForWordWithAnagrams()
    {
        // given
        let word = "elbow"

        // when
        let expectation = self.expectation(description: "\(#function)")
        let model = DictionaryModel(entries: wordDictionary)
        var anagrams: [String]?

        model.anagramsFor(word: word) { (result) in
            anagrams = result
            expectation.fulfill()
        }

        // then
        wait(for: [expectation], timeout: 3)
        XCTAssertNotNil(anagrams)
    }

    func testAnagramsForNotIncludingGivenWord()
    {
        // given
        let word = "elbow"

        // when
        let expectation = self.expectation(description: "\(#function)")
        let model = DictionaryModel(entries: wordDictionary)
        var anagrams: [String]?

        model.anagramsFor(word: word) { (result) in
            anagrams = result
            expectation.fulfill()
        }

        // then
        wait(for: [expectation], timeout: 3)
        XCTAssertNotNil(anagrams)
        let anagramsMatchingWord = anagrams?.filter { (anagram) -> Bool in
            return anagram.caseInsensitiveCompare(word) == ComparisonResult.orderedSame
        }
        XCTAssertEqual(anagramsMatchingWord?.count, 0)
    }

    func testAnagramsForWordNotPresentInDictionary()
    {
        // given
        let word = "tar"

        // when
        let expectation = self.expectation(description: "\(#function)")
        let model = DictionaryModel(entries: wordDictionary)
        var anagrams: [String]?

        model.anagramsFor(word: word) { (result) in
            anagrams = result
            expectation.fulfill()
        }

        // then
        wait(for: [expectation], timeout: 3)
        XCTAssertNotNil(anagrams)
    }

    func testAnagramsForFasterSearchWithHashing()
    {
        // given
        let word = "tesla"

        // when1
        var expectation = self.expectation(description: "\(#function) 1st run")
        guard let jsonDictionary = jsonDictionary else {
            XCTFail("Unable to load dictionary from JSON.")
            return
        }
        let model = DictionaryModel(entries: jsonDictionary)
        var anagrams1: [String]?

        var start = DispatchTime.now()
        var executionTime1: UInt64 = 0
        model.anagramsFor(word: word) { (result) in
            anagrams1 = result
            executionTime1 = DispatchTime.now().uptimeNanoseconds - start.uptimeNanoseconds
            expectation.fulfill()
        }

        // then1
        wait(for: [expectation], timeout: 3)
        XCTAssertNotNil(anagrams1)

        // when2
        expectation = self.expectation(description: "\(#function) 2nd run")
        var anagrams2: [String]?

        start = DispatchTime.now()
        var executionTime2: UInt64 = 0
        model.anagramsFor(word: word) { (result) in
            anagrams2 = result
            executionTime2 = DispatchTime.now().uptimeNanoseconds - start.uptimeNanoseconds
            expectation.fulfill()
        }

        // then2
        wait(for: [expectation], timeout: 3)
        XCTAssertNotNil(anagrams2)
        XCTAssertEqual(anagrams1, anagrams2)
        print(String(format: "Execution time 1: %.10f", Double(executionTime1) / 1_000_000_000))
        print(String(format: "Execution time 2: %.10f", Double(executionTime2) / 1_000_000_000))
        XCTAssertTrue(executionTime1 > executionTime2)

    }
}
