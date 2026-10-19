//
//  FakeHTTPClient.swift
//  ArtSearchTests
//
//  Created by Avi Pogrow on 10/19/26.
//

import Foundation
@testable import ArtSearch

struct FakeHTTPClient: HTTPClient {
    var body = Data()
    var statusCode = 200

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        let response = HTTPURLResponse(url: request.url!, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
        
        return (body, response)
    }
}
