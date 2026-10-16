//
//  SearchViewModel.swift
//  ArtSearch
//
//  Created by Avi Pogrow on 10/16/26.
//

import Foundation
import Combine

enum SearchPhase: Equatable {
    case idle
    case loading
    case loaded([Artwork])
    case empty
    case failed(String)
}

@MainActor final class SearchViewModel: ObservableObject {
    @Published var query = ""
    @Published private(set) var phase: SearchPhase = .idle

    private let service = ArtworkService()
    private var searchTask: Task<Void, Never>?

    func submit() {
        searchTask?.cancel()
        let term = query
        phase = .loading
        searchTask = Task {
            do {
                let results = try await loadResults(for: term)
                guard !Task.isCancelled else { return }
                phase = results.isEmpty ? .empty : .loaded(results)
            } catch {
                guard !Task.isCancelled else { return }
                phase = .failed("Search failed. Try again.")
            }
        }
    }

    func refresh() async {                 // async, so .refreshable can await it
        searchTask?.cancel()
        let term = query
        do {
            let results = try await loadResults(for: term)
            phase = results.isEmpty ? .empty : .loaded(results)
        } catch {
            // keep the old list on screen if a refresh fails
        }
    }

    private func loadResults(for term: String) async throws -> [Artwork] {
        let ids = try await service.searchIDs(for: term)
        var results: [Artwork] = []
        for id in ids.prefix(20) {
            if let artwork = try? await service.artwork(id: id) {
                results.append(artwork)
            }
        }
        return results
    }
}
