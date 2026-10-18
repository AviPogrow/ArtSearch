//
//  SearchViewModel.swift
//  ArtSearch
//
//  Created by Avi Pogrow on 10/16/26.
import Foundation
import Combine

enum SearchPhase: Equatable {
    case idle
    case loading
    case loaded([Artwork])
    case empty
    case failed(String)
}

struct SearchState: Equatable {
    var query = ""
    var phase: SearchPhase = .idle
}

@MainActor final class SearchViewModel: ObservableObject {
    @Published private(set) var state = SearchState()

    private let service: ArtworkService

    // whoever creates the SearchViewModel injects this in
    init(service: ArtworkService) {
        self.service = service
    }
    
    // the app uses this one; it builds the real service on the main actor
    convenience init() {
        self.init(service: ArtworkService())
    }
    
    
    private var searchTask: Task<Void, Never>?

    func send(_ intent: SearchIntent) {
        print("intent:", intent)                  // the intent log
        switch intent {
        case .queryChanged(let text):
            state.query = text                    // not sent by the view until step 3
        case .searchSubmitted:
            startSearch(showsLoading: true)
        case .refreshPulled:
            startSearch(showsLoading: false)
        }
    }
    
    func sendAndWait(_ intent: SearchIntent) async {
        send(intent)              // the same single door: logs, switches, starts the work
        await searchTask?.value   // then wait for the task that send just started
    }

    private func startSearch(showsLoading: Bool) {
        searchTask?.cancel()
        let term = state.query
        if showsLoading { state.phase = .loading }
        searchTask = Task {
            do {
                let results = try await loadResults(for: term)
                guard !Task.isCancelled else { return }
                state.phase = results.isEmpty ? .empty : .loaded(results)
            } catch {
                guard !Task.isCancelled else { return }
                state.phase = .failed("Search failed. Try again.")
            }
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
