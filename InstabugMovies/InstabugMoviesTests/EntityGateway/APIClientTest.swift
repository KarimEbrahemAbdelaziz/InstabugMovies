//
//  APIClientTests.swift
//  InstabugMoviesTests
//
//  Created by Karim Ebrahem on 3/24/19.
//  Copyright © 2019 Karim Ebrahem. All rights reserved.
//

@testable import InstabugMovies
import XCTest

class APIClientTest: XCTestCase {

    let urlSessionStub = URLSessionStub()
    var apiClient: ApiClientImplementation!
    
    override func setUp() {
        super.setUp()
        
        apiClient = ApiClientImplementation(urlSession: urlSessionStub)
    }

    override func tearDown() {
        super.tearDown()
        
        apiClient = nil
    }
    
    //MARK: - Tests
    
    func testExecuteSuccessfulHTTPResponseParsesOk() {
        // Given
        let expectedUtf8StringResponse = "{ \"SomeProperty\" : \"SomeValue\" }"
        let expectedData = expectedUtf8StringResponse.data(using: .utf8)
        let expected2xxReponse = HTTPURLResponse(statusCode: 200)
        
        urlSessionStub.enqueue(response: (data: expectedData, response: expected2xxReponse, error: nil))
        
        let executeCompletionHandlerExpectation = expectation(description: "Execute http request completion handler expectation")
        
        // When
        apiClient.execute(request: TestDoubleRequest()) { (result: Result<APIResponse<TestDoubleAPIEntity>>) in
            // Then
            guard let response = try? result.dematerialize() else {
                XCTFail("A successfull response should've been returned")
                return
            }
            XCTAssertEqual(expectedUtf8StringResponse, response.entity.utf8String, "The string is not the expected one")
            XCTAssertTrue(expected2xxReponse === response.httpUrlResponse, "The http response is not the expected one")
            XCTAssertEqual(expectedData?.base64EncodedString(), response.data?.base64EncodedString(), "Data doesn't match")
            
            executeCompletionHandlerExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testExecuteSuccessfulHTTPResponsePrasesError() {
        // Given
        let expectedUtf8StringResponse = "{ \"SomeProperty\" : \"SomeValue\" }"
        let expectedData = expectedUtf8StringResponse.data(using: .utf8)
        let expected2xxReponse = HTTPURLResponse(statusCode: 200)
        let expectedParsingErrorMessage = "A parsing error occured"
        
        urlSessionStub.enqueue(response: (data: expectedData, response: expected2xxReponse, error: nil))
        
        let executeCompletionHandlerExpectation = expectation(description: "Execute http request completion handler expectation")
        
        // When
        apiClient.execute(request: TestDoubleRequest()) { (result: Result<APIResponse<TestDoubleErrorParseAPIEntity>>) in
            // Then
            do {
                let _ = try result.dematerialize()
                XCTFail("Expected parse error to be thrown")
            } catch let error as APIParseError {
                XCTAssertTrue(expected2xxReponse === error.httpUrlResponse, "The http response is not the expected one")
                XCTAssertEqual(expectedData?.base64EncodedString(), error.data?.base64EncodedString(), "Data doesn't match")
                XCTAssertEqual(expectedParsingErrorMessage, error.localizedDescription, "Error message doesn't match")
            } catch {
                XCTFail("Expected parse error to be thrown")
            }
            
            executeCompletionHandlerExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testExecuteNon2xxResponseCode() {
        // Given
        let expectedUtf8StringResponse = "{ \"SomeProperty\" : \"SomeValue\" }"
        let expectedData = expectedUtf8StringResponse.data(using: .utf8)
        let expected4xxReponse = HTTPURLResponse(statusCode: 400)
        
        urlSessionStub.enqueue(response: (data: expectedData, response: expected4xxReponse, error: nil))
        
        let executeCompletionHandlerExpectation = expectation(description: "Execute http request completion handler expectation")
        
        // When
        apiClient.execute(request: TestDoubleRequest()) { (result: Result<APIResponse<TestDoubleAPIEntity>>) in
            // Then
            do {
                let _ = try result.dematerialize()
                XCTFail("Expected api error to be thrown")
            } catch let error as APIError {
                XCTAssertTrue(expected4xxReponse === error.httpUrlResponse, "The http response is not the expected one")
                XCTAssertEqual(expectedData?.base64EncodedString(), error.data?.base64EncodedString(), "Data doesn't match")
            } catch {
                XCTFail("Expected api error to be thrown")
            }
            
            executeCompletionHandlerExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testExecuteErrorNoHTTPUrlResponse() {
        // Given
        let expectedErrorMessage = "Random network error"
        let expectedError = NSError.createError(withMessage: expectedErrorMessage)
        
        urlSessionStub.enqueue(response: (data: nil, response: nil, error: expectedError))
        
        let executeCompletionHandlerExpectation = expectation(description: "Execute http request completion handler expectation")
        
        // When
        apiClient.execute(request: TestDoubleRequest()) { (result: Result<APIResponse<TestDoubleAPIEntity>>) in
            // Then
            do {
                let _ = try result.dematerialize()
                XCTFail("Expected network error to be thrown")
            } catch let error as NetworkRequestError {
                XCTAssertEqual(expectedErrorMessage, error.localizedDescription, "Error message doesn't match")
            } catch {
                XCTFail("Expected network error to be thrown")
            }
            
            executeCompletionHandlerExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }

}

private struct TestDoubleRequest: APIRequest {
    var urlRequest: URLRequest {
        return URLRequest(url: URL.googleUrl)
    }
}

private struct TestDoubleAPIEntity: InitializableWithData {
    var utf8String: String
    
    init(data: Data?) throws {
        utf8String = String(data: data!, encoding: .utf8)!
    }
}

private struct TestDoubleErrorParseAPIEntity: InitializableWithData {
    init(data: Data?) throws {
        throw NSError.createPraseError()
    }
}
