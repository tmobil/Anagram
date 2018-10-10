//
//  DictionaryModel.swift
//  Anagram
//
//  Created by Krzysztof Grobelny on 09/10/2018.
//  Copyright © 2018 Mobica. All rights reserved.
//

import Foundation

typealias DictionaryEntries = [String: [String]]
typealias AnagramSets = [String: Set<String>]

class DictionaryModel
{
    private var words: Set<String>?
    private var hashSet = [Int: AnagramSets]()

    init(entries: DictionaryEntries)
    {
        // collecting only keys from the fetched dictionary, as word definitions are irrelevant
        // storing them as set for faster searching
        words = Set(entries.keys)
    }

    func anagramsFor(word: String, completion: @escaping (Set<String>?) -> ())
    {
        // ignoring words shorter than 2 letters
        guard word.count > 1 else {
            return completion(nil)
        }

        DispatchQueue.global(qos: .userInitiated).async {
            // checking if we have already hashed words of given length
            // if so - quick find in set is called
            if let hashedWordsOfLength = self.hashSet[word.count] {
                return completion(self.findHashedWord(word, inHashed: hashedWordsOfLength))
            }

            // we don't have words of given length hashed yet
            // thus we are selecting them and building hash of each one
            // then inserting it into local hashSet along with removing
            // already hashed words from the list
            // this way another search for a word of the same length is going to be way faster
            if let filteredByLength = self.words?.filter({ $0.count == word.count }),
                filteredByLength.count > 0 {
                self.words = self.words?.subtracting(filteredByLength)
                let justHashed = self.buildHash(ofWords: filteredByLength)
                self.hashSet[word.count] = justHashed
                return completion(self.findHashedWord(word, inHashed: justHashed))
            }

            // if no word of given length is found we return nil
            return completion(nil)
        }
    }

    private func buildHash(ofWords words: Set<String>) -> AnagramSets
    {
        // set is build by lowercasing and sorting characters in each letter
        // 'Car' and 'Arc' lead to the same hash - 'acr', and are group together
        // searching for any of these words will result in finding that list quickly
        var hashed = AnagramSets()
        for word in words {
            let sorted = String(word.lowercased().sorted())
            var alreadyHashed = hashed[sorted] ?? Set<String>()
            alreadyHashed.insert(word)
            hashed[sorted] = alreadyHashed
        }
        return hashed
    }

    private func findHashedWord(_ word: String, inHashed hashed: AnagramSets) -> Set<String>?
    {
        // finding word's anagrams in hashed set and excluding the word itself
        let sorted = String(word.lowercased().sorted())
        return hashed[sorted]?.filter { $0.caseInsensitiveCompare(word) != ComparisonResult.orderedSame }
    }
}
