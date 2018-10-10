//
//  DictionaryModel.swift
//  Anagram
//
//  Created by Krzysztof Grobelny on 09/10/2018.
//  Copyright © 2018 Mobica. All rights reserved.
//

import Foundation

typealias DictionaryEntries = [String: [String]]

class DictionaryModel
{
    private var words: Set<String>?
    private var hashSet = [Int: DictionaryEntries]()

    init(entries: DictionaryEntries)
    {
        words = Set(entries.keys)
    }

    func anagramsFor(word: String, completion: @escaping ([String]?) -> ())
    {
        DispatchQueue.global(qos: .userInitiated).async {
            if let hashedWordsOfLength = self.hashSet[word.count] {
                return completion(self.findHashedWord(word, inHashed: hashedWordsOfLength))
            }

            if let filteredByLength = self.words?.filter({ $0.count == word.count }) {
                self.words = self.words?.subtracting(filteredByLength)
                let justHashed = self.buildHash(ofWords: filteredByLength)
                self.hashSet[word.count] = justHashed
                return completion(self.findHashedWord(word, inHashed: justHashed))
            }
            return completion(nil)
        }
    }

    private func buildHash(ofWords words: Set<String>) -> DictionaryEntries
    {
        var hashed = DictionaryEntries()
        for word in words {
            let sorted = String(word.lowercased().sorted())
            var alreadyHashed = hashed[sorted] ?? [String]()
            alreadyHashed.append(word)
            hashed[sorted] = alreadyHashed
        }
        return hashed
    }

    private func findHashedWord(_ word: String, inHashed hashed: DictionaryEntries) -> [String]?
    {
        let sorted = String(word.lowercased().sorted())
        return hashed[sorted]?.filter { $0.caseInsensitiveCompare(word) != ComparisonResult.orderedSame }
    }
}
