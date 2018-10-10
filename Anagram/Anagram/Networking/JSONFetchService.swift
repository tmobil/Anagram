//
//  JSONFetchService.swift
//  Anagram
//
//  Created by Krzysztof Grobelny on 09/10/2018.
//  Copyright © 2018 Mobica. All rights reserved.
//

import Foundation

enum FetchResult<T> {
    case success(T)
    case error(String)
}

let englishDictionaryURLAsString = "https://raw.githubusercontent.com/tmobil/Anagram/master/english.json"

class JSONFetchService
{
    class func fetchData(withSession session: URLSession = .shared,
                         urlString: String = englishDictionaryURLAsString,
                         completion: @escaping (FetchResult<DictionaryEntries>) -> Void)
    {
        guard let jsonURL = URL(string: urlString) else {
            return completion(.error("Unable to build a valid URL."))
        }

        let dataTask = session.dataTask(with: jsonURL) { (data, response, error) -> Void in
            guard error == nil else {
                return completion(.error(error!.localizedDescription))
            }
            guard let data = data else {
                return completion(.error("No dictionary received."))
            }

            do {
                let entries = try JSONDecoder().decode(DictionaryEntries.self, from: data)
                if entries.count == 0 {
                    return completion(.error("The fetched dictionary source is empty."))
                }
                return completion(.success(entries))
            }
            catch {
                return completion(.error("Unable to parse the dictionary source."))
            }
        }
        dataTask.resume()
    }

    class func loadJSONFromBundle(completion: @escaping (DictionaryEntries?) -> Void)
    {
        guard let path = Bundle.main.url(forResource: "english", withExtension: "json") else {
            return completion(nil)
        }

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let data = try Data(contentsOf: path)
                let entries = try JSONDecoder().decode(DictionaryEntries.self, from: data)
                return completion(entries)
            }
            catch {
                return completion(nil)
            }
        }
    }
}
