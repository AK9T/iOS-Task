//
//  APIManagerTests.swift
//  PremierSwift
//
//  Created by Akshay Khamankar on 10/02/25.
//  Copyright © 2025 Deliveroo. All rights reserved.
//

import XCTest
@testable import PremierSwift

// "" Mock Response Model
struct MockResponse: Codable, Equatable {
    let message: String
}

//  Mock URLSession for testing API calls
final class MockURLSession: URLSession {
    var testData: Data?
    var testResponse: URLResponse?
    var testError: Error?

    override func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask {
        return MockURLSessionDataTask {
            completionHandler(self.testData, self.testResponse, self.testError)
        }
    }
}

final class MockURLSessionDataTask: URLSessionDataTask {
    private let closure: () -> Void

    init(closure: @escaping () -> Void) {
        self.closure = closure
    }

    override func resume() {
        closure()
    }
}

// "" Unit Test for APIManager
final class APIManagerTests: XCTestCase {

    var apiManager: APIManager!
    var mockSession: MockURLSession!

    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        apiManager = APIManager(urlSession: mockSession)
    }

    override func tearDown() {
        apiManager = nil
        mockSession = nil
        super.tearDown()
    }

    // "" Test Successful API Call
    func testExecute_Success() {
        // Given
        let expectedResponse = MockResponse(message: "Success")
        let jsonData = try! JSONEncoder().encode(expectedResponse)

        mockSession.testData = jsonData
        mockSession.testResponse = HTTPURLResponse(url: URL(string: "https://api.themoviedb.org/3/test")!,
                                                   statusCode: 200, httpVersion: nil, headerFields: nil)

        let request = Request<MockResponse>(method: .get, path: "/test")

        let expectation = self.expectation(description: "API request should succeed")

        // When
        apiManager.execute(request) { result in
            switch result {
            case .success(let response):
                XCTAssertEqual(response, expectedResponse, "❌ Response does not match expected value")
                expectation.fulfill()
            case .failure:
                XCTFail("❌ Expected success but received failure")
            }
        }

        waitForExpectations(timeout: 2)
    }

    // "" Test Network Error
    func testExecute_NetworkError() {
        // Given
        mockSession.testError = NSError(domain: "NetworkError", code: -1009, userInfo: nil)

        let request = Request<MockResponse>(method: .get, path: "/test")

        let expectation = self.expectation(description: "API request should fail with network error")

        // When
        apiManager.execute(request) { result in
            switch result {
            case .success:
                XCTFail("❌ Expected failure but received success")
            case .failure(let error):
                XCTAssertEqual(error, .networkError, "❌ Expected network error but got \(error)")
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 2)
    }

    // "" Test Parsing Error (Invalid JSON Response)
    func testExecute_ParsingError() {
        // Given
        mockSession.testData = "Invalid JSON".data(using: .utf8)

        let request = Request<MockResponse>(method: .get, path: "/test")

        let expectation = self.expectation(description: "API request should fail with parsing error")

        // When
        apiManager.execute(request) { result in
            switch result {
            case .success:
                XCTFail("❌ Expected failure but received success")
            case .failure(let error):
                XCTAssertEqual(error, .parsingError, "❌ Expected parsing error but got \(error)")
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 2)
    }

    // "" Test URL Request Formation
    func testUrlRequestFormation() {
        // Given
        let request = Request<MockResponse>(method: .get, path: "/test")

        // When
        let urlRequest = apiManager.urlRequest(for: request)

        // Then
        XCTAssertEqual(urlRequest.httpMethod, "GET", "❌ HTTP method should be GET")
        XCTAssertTrue(urlRequest.url!.absoluteString.contains("api_key"), "❌ API key should be included in the URL")
    }
}
