//
//  TestDictionary.swift
//  AnagramTests
//
//  Created by Krzysztof Grobelny on 10/10/2018.
//  Copyright © 2018 Mobica. All rights reserved.
//

import Foundation
@testable import Anagram

struct TestDictionary
{
    static var wordDictionary: DictionaryEntries {
        var wordDictionary = DictionaryEntries()
        wordDictionary["Car"] = [String]()
        wordDictionary["Arc"] = [String]()
        wordDictionary["Rat"] = [String]()
        wordDictionary["Elbow"] = [String]()
        wordDictionary["Below"] = [String]()
        return wordDictionary
    }

    static var jsonDictionary: DictionaryEntries? {
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

    static var emptyDictionaryData: Data? {
        do {
            return try JSONEncoder().encode(DictionaryEntries())
        }
        catch {
            return nil
        }
    }

    static var validDictionaryData: Data? {
        do {
            return try JSONEncoder().encode(wordDictionary)
        }
        catch {
            return nil
        }
    }

}
