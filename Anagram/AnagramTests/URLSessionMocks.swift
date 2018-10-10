//
//  URLSessionMocks.swift
//  AnagramTests
//
//  Created by Krzysztof Grobelny on 10/10/2018.
//  Copyright © 2018 Mobica. All rights reserved.
//

import Foundation

class URLSessionDataTaskMock: URLSessionDataTask
{
    private let closure: () -> Void

    init(closure: @escaping () -> Void)
    {
        self.closure = closure
    }

    override func resume()
    {
        closure()
    }
}

class URLSessionMock: URLSession
{
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void

    var data: Data?
    var error: Error?
    override func dataTask(with url: URL,
                           completionHandler: @escaping CompletionHandler) -> URLSessionDataTask
    {
        let data = self.data
        let error = self.error
        return URLSessionDataTaskMock {
            completionHandler(data, nil, error)
        }
    }
}
