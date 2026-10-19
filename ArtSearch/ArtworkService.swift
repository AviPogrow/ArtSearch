//
//  ArtworkService.swift
//  ArtSearch
//
//  Created by Avi Pogrow on 10/16/26.
//

import Foundation

protocol HTTPClient: Sendable {
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

protocol ArtworkSearching: Sendable {
    func searchIDs(for term: String) async throws -> [Int]
    func artwork(id: Int) async throws -> Artwork
}

struct SearchResponse: Decodable {
    let objectIDs: [Int]?                               // the Met sends null when nothing matches
}


struct ArtworkService: ArtworkSearching {
        private let baseURL = "https://collectionapi.metmuseum.org/public/collection"
        private let client: any HTTPClient                                  // ① NEW

        init(client: any HTTPClient = URLSession.shared) {                  // ② NEW
            self.client = client
        }
    
    
 

    func searchIDs(for term: String) async throws -> [Int] {
        var components = URLComponents(string: "\(baseURL)/v1.1/search")!
        components.queryItems = [
            URLQueryItem(name: "hasImages", value: "true"),
            URLQueryItem(name: "q", value: term)        // the Met requires q to be last
        ]
        let data = try await fetch(components.url!)
        return try JSONDecoder().decode(SearchResponse.self, from: data).objectIDs ?? []
    }

    func artwork(id: Int) async throws -> Artwork {
        let data = try await fetch(URL(string: "\(baseURL)/v1/objects/\(id)")!)
        return try JSONDecoder().decode(Artwork.self, from: data)
    }

    private func fetch(_ url: URL) async throws -> Data {
           let (data, response) = try await client.data(for: URLRequest(url: url))   // ③ CHANGED
           guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
               throw URLError(.badServerResponse)
           }
        return data
    }
}

extension URLSession: HTTPClient {
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        
        try await data(for: request, delegate: nil)
    }
}
