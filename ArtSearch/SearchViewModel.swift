//
//  SearchViewModel.swift
//  ArtSearch
//
//  Created by Avi Pogrow on 10/16/26.
//

import Foundation
import Combine

@MainActor final class SearchViewModel: ObservableObject {
    @Published var query = ""                                // the view binds to this
    @Published private(set) var artworks: [Artwork] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    private let service = ArtworkService()
    private var searchTask: Task<Void, Never>?

    func submit() {
        searchTask?.cancel()                                 // a new search replaces the old one
        let term = query
        isLoading = true
        errorMessage = nil
        searchTask = Task {
            do {
                let ids = try await service.searchIDs(for: term)
                var results: [Artwork] = []
                for id in ids.prefix(20) {
                    if let artwork = try? await service.artwork(id: id) {
                        results.append(artwork)
                    }
                }
                guard !Task.isCancelled else { return }
                artworks = results
            } catch {
                guard !Task.isCancelled else { return }
                errorMessage = "Search failed. Try again."
            }
            isLoading = false
        }
    }
}
