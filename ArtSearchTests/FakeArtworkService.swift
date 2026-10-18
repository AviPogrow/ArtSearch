//
//  FakeArtworkService.swift
//  ArtSearchTests
//
//  Created by Avi Pogrow on 10/18/26.
//

import Foundation
@testable import ArtSearch

struct FakeArtworkService: ArtworkSearching {
    var ids: [Int] = []                  // what searchIDs will return
    var artworks: [Int: Artwork] = [:]   // what artwork(id:) will return, by ID
    var shouldFail = false               // set to true to simulate a network failure

    func searchIDs(for term: String) async throws -> [Int] {
        if shouldFail { throw URLError(.notConnectedToInternet) }
        return ids
    }

    func artwork(id: Int) async throws -> Artwork {
        guard let artwork = artworks[id] else { throw URLError(.fileDoesNotExist) }
        return artwork
    }
}
