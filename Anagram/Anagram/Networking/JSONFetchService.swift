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

class JSONFetchService
{
    private static let jsonURLString = "https://raw.githubusercontent.com/tmobil/Anagram/master/english.json"

    class func fetchData(completion: @escaping (FetchResult<DictionaryEntries>) -> Void)
    {
        guard let jsonURL = URL(string: jsonURLString) else {
            return completion(.error("Unable to build a valid URL."))
        }

        let dataTask = URLSession.shared.dataTask(with: jsonURL) { (data, response, error) -> Void in
            guard error == nil else {
                return completion(.error(error!.localizedDescription))
            }
            guard let data = data else {
                return completion(.error("No dictionary received."))
            }

            do {
                let entries = try JSONDecoder().decode(DictionaryEntries.self, from: data)
                return completion(.success(entries))
            }
            catch {
                return completion(.error("Unable to parse the dictionary source."))
            }
        }
        dataTask.resume()
    }
}
