//
//  JSONFetchServiceTests.swift
//  AnagramTests
//
//  Created by Krzysztof Grobelny on 10/10/2018.
//  Copyright © 2018 Mobica. All rights reserved.
//

import XCTest
@testable import Anagram

class JSONFetchServiceTests: XCTestCase
{
    func testFetchWithInvalidURL()
    {
        // given
        let session = URLSessionMock()
        let urlString = "invalid URL"

        // when
        let expectation = self.expectation(description: "\(#function)")
        var fetchResult: FetchResult<DictionaryEntries>?
        JSONFetchService.fetchData(withSession: session, urlString: urlString) { (result) in
            fetchResult = result
            expectation.fulfill()
        }

        // then
        self.wait(for: [expectation], timeout: 3)
        XCTAssertNotNil(fetchResult)
        switch fetchResult! {
        case .error(let message):
            XCTAssertEqual(message, "Unable to build a valid URL.")
        default:
            XCTFail("Unexpected fetch success.")
        }
    }

    func testFetchWhenErrorIsReturned()
    {
        // given
        let session = URLSessionMock()
        let errorCode = 111
        session.error = NSError(domain: "test", code: errorCode, userInfo: nil)

        // when
        let expectation = self.expectation(description: "\(#function)")
        var fetchResult: FetchResult<DictionaryEntries>?
        JSONFetchService.fetchData(withSession: session) { (result) in
            fetchResult = result
            expectation.fulfill()
        }

        // then
        self.wait(for: [expectation], timeout: 3)
        XCTAssertNotNil(fetchResult)
        switch fetchResult! {
        case .error(let message):
            XCTAssertTrue(message.contains(String(errorCode)))
        default:
            XCTFail("Unexpected fetch success.")
        }
    }

    func testFetchWhenDataIsNil()
    {
        // given
        let session = URLSessionMock()

        // when
        let expectation = self.expectation(description: "\(#function)")
        var fetchResult: FetchResult<DictionaryEntries>?
        JSONFetchService.fetchData(withSession: session) { (result) in
            fetchResult = result
            expectation.fulfill()
        }

        // then
        self.wait(for: [expectation], timeout: 3)
        XCTAssertNotNil(fetchResult)
        switch fetchResult! {
        case .error(let message):
            XCTAssertEqual(message, "No dictionary received.")
        default:
            XCTFail("Unexpected fetch success.")
        }
    }

    func testFetchWhenDataIsInvalid()
    {
        // given
        let session = URLSessionMock()
        session.data = Data()

        // when
        let expectation = self.expectation(description: "\(#function)")
        var fetchResult: FetchResult<DictionaryEntries>?
        JSONFetchService.fetchData(withSession: session) { (result) in
            fetchResult = result
            expectation.fulfill()
        }

        // then
        self.wait(for: [expectation], timeout: 3)
        XCTAssertNotNil(fetchResult)
        switch fetchResult! {
        case .error(let message):
            XCTAssertEqual(message, "Unable to parse the dictionary source.")
        default:
            XCTFail("Unexpected fetch success.")
        }
    }

    func testFetchWhenDataIsEmpty()
    {
        // given
        let session = URLSessionMock()
        session.data = TestDictionary.emptyDictionaryData

        // when
        let expectation = self.expectation(description: "\(#function)")
        var fetchResult: FetchResult<DictionaryEntries>?
        JSONFetchService.fetchData(withSession: session) { (result) in
            fetchResult = result
            expectation.fulfill()
        }

        // then
        self.wait(for: [expectation], timeout: 3)
        XCTAssertNotNil(fetchResult)
        switch fetchResult! {
        case .error(let message):
            XCTAssertEqual(message, "The fetched dictionary source is empty.")
        default:
            XCTFail("Unexpected fetch success.")
        }
    }

    func testFetchWhenDataIsValid()
    {
        // given
        let session = URLSessionMock()
        session.data = TestDictionary.validDictionaryData

        // when
        let expectation = self.expectation(description: "\(#function)")
        var fetchResult: FetchResult<DictionaryEntries>?
        JSONFetchService.fetchData(withSession: session) { (result) in
            fetchResult = result
            expectation.fulfill()
        }

        // then
        self.wait(for: [expectation], timeout: 3)
        XCTAssertNotNil(fetchResult)
        switch fetchResult! {
        case .success(let entries):
            XCTAssertEqual(entries.count, TestDictionary.wordDictionary.count)
        default:
            XCTFail("Unexpected fetch success.")
        }
    }
}
